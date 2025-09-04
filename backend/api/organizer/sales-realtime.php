<?php
require_once '../../config/cors.php';
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$organizer_id = isset($_GET['organizer_id']) ? (int)$_GET['organizer_id'] : 0;
$event_id = isset($_GET['event_id']) ? (int)$_GET['event_id'] : 0;

if ($organizer_id <= 0) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'ID de organizador requerido'
    ]);
    exit;
}

try {
    $where_clause = "WHERE e.organizer_id = ?";
    $params = [$organizer_id];

    if ($event_id > 0) {
        $where_clause .= " AND e.id = ?";
        $params[] = $event_id;
    }

    $query = "SELECT 
        e.id as event_id,
        e.title as event_title,
        e.event_date,
        e.capacity as total_capacity,
        COALESCE(SUM(s.quantity), 0) as tickets_sold,
        (e.capacity - COALESCE(SUM(s.quantity), 0)) as remaining_capacity,
        ROUND((COALESCE(SUM(s.quantity), 0) / e.capacity) * 100, 1) as occupancy_rate,
        COUNT(s.id) as total_sales,
        COALESCE(SUM(s.total_amount), 0) as total_revenue,
        COALESCE(AVG(s.total_amount), 0) as average_sale_amount,
        COALESCE(SUM(CASE WHEN s.created_at >= DATE_SUB(NOW(), INTERVAL 1 HOUR) THEN 1 ELSE 0 END), 0) as sales_last_hour,
        COALESCE(SUM(CASE WHEN DATE(s.created_at) = CURDATE() THEN 1 ELSE 0 END), 0) as sales_today,
        COALESCE(SUM(CASE WHEN s.created_at >= DATE_SUB(NOW(), INTERVAL 1 WEEK) THEN 1 ELSE 0 END), 0) as sales_this_week,
        MAX(s.created_at) as last_sale_time
        FROM events e
        LEFT JOIN sales s ON e.id = s.event_id AND s.status = 'completed'
        $where_clause
        AND e.status = 'published'
        GROUP BY e.id, e.title, e.event_date, e.capacity
        ORDER BY e.event_date ASC";

    $stmt = $db->prepare($query);
    $stmt->execute($params);

    $events_data = [];
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        // Get recent sales for this event
        $recent_sales_query = "SELECT 
            s.id,
            s.quantity,
            s.total_amount as amount,
            u.name as buyer_name,
            u.email as buyer_email,
            s.payment_method,
            tt.name as ticket_type,
            s.created_at,
            CASE 
                WHEN TIMESTAMPDIFF(MINUTE, s.created_at, NOW()) < 60 
                THEN CONCAT(TIMESTAMPDIFF(MINUTE, s.created_at, NOW()), ' min')
                WHEN TIMESTAMPDIFF(HOUR, s.created_at, NOW()) < 24 
                THEN CONCAT(TIMESTAMPDIFF(HOUR, s.created_at, NOW()), ' h')
                ELSE CONCAT(TIMESTAMPDIFF(DAY, s.created_at, NOW()), ' d')
            END as time_ago
            FROM sales s
            JOIN users u ON s.user_id = u.id
            LEFT JOIN ticket_types tt ON s.ticket_type_id = tt.id
            WHERE s.event_id = ? AND s.status = 'completed'
            ORDER BY s.created_at DESC
            LIMIT 5";

        $recent_stmt = $db->prepare($recent_sales_query);
        $recent_stmt->execute([$row['event_id']]);
        $recent_sales = $recent_stmt->fetchAll(PDO::FETCH_ASSOC);

        // Get hourly sales for the last 24 hours
        $hourly_query = "SELECT 
            HOUR(s.created_at) as hour,
            COUNT(*) as sales,
            SUM(s.total_amount) as revenue
            FROM sales s
            WHERE s.event_id = ? 
            AND s.status = 'completed'
            AND s.created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
            GROUP BY HOUR(s.created_at)
            ORDER BY hour ASC";

        $hourly_stmt = $db->prepare($hourly_query);
        $hourly_stmt->execute([$row['event_id']]);
        $hourly_sales = $hourly_stmt->fetchAll(PDO::FETCH_ASSOC);

        $events_data[] = [
            'eventId' => (int)$row['event_id'],
            'eventTitle' => $row['event_title'],
            'eventDate' => $row['event_date'],
            'totalCapacity' => (int)$row['total_capacity'],
            'ticketsSold' => (int)$row['tickets_sold'],
            'remainingCapacity' => (int)$row['remaining_capacity'],
            'occupancyRate' => (float)$row['occupancy_rate'],
            'totalSales' => (int)$row['total_sales'],
            'totalRevenue' => (int)$row['total_revenue'],
            'averageSaleAmount' => (int)$row['average_sale_amount'],
            'salesLastHour' => (int)$row['sales_last_hour'],
            'salesToday' => (int)$row['sales_today'],
            'salesThisWeek' => (int)$row['sales_this_week'],
            'lastSaleTime' => $row['last_sale_time'],
            'recentSales' => array_map(function($sale) {
                return [
                    'id' => (int)$sale['id'],
                    'quantity' => (int)$sale['quantity'],
                    'amount' => (int)$sale['amount'],
                    'buyerName' => $sale['buyer_name'],
                    'buyerEmail' => $sale['buyer_email'],
                    'paymentMethod' => $sale['payment_method'],
                    'ticketType' => $sale['ticket_type'],
                    'createdAt' => $sale['created_at'],
                    'timeAgo' => 'hace ' . $sale['time_ago']
                ];
            }, $recent_sales),
            'hourlySales' => array_map(function($hourly) {
                return [
                    'hour' => (int)$hourly['hour'],
                    'sales' => (int)$hourly['sales'],
                    'revenue' => (int)$hourly['revenue']
                ];
            }, $hourly_sales),
            'timestamp' => date('Y-m-d H:i:s')
        ];
    }

    http_response_code(200);
    echo json_encode([
        'success' => true,
        'data' => $events_data,
        'timestamp' => date('Y-m-d H:i:s')
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error al obtener datos en tiempo real: ' . $e->getMessage()
    ]);
}
?>

<?php
require_once '../../config/cors.php';
require_once '../../config/database.php';

$database = new Database();
$db = $database->getConnection();

$organizer_id = isset($_GET['organizer_id']) ? (int)$_GET['organizer_id'] : 0;

if ($organizer_id <= 0) {
    http_response_code(400);
    echo json_encode([
        'success' => false,
        'message' => 'ID de organizador requerido'
    ]);
    exit;
}

try {
    // Overview stats
    $overview_query = "SELECT 
        COUNT(CASE WHEN status IN ('published', 'draft') THEN 1 END) as total_events,
        COUNT(CASE WHEN status = 'published' THEN 1 END) as published_events,
        COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_events
        FROM events 
        WHERE organizer_id = ?";

    $stmt = $db->prepare($overview_query);
    $stmt->execute([$organizer_id]);
    $overview = $stmt->fetch(PDO::FETCH_ASSOC);

    // Sales stats
    $sales_query = "SELECT 
        COUNT(*) as total_sales,
        SUM(total_amount) as total_revenue,
        SUM(quantity) as total_tickets_sold,
        COUNT(DISTINCT user_id) as unique_customers,
        AVG(total_amount) as average_order_value
        FROM sales s
        JOIN events e ON s.event_id = e.id
        WHERE e.organizer_id = ? AND s.status = 'completed'";

    $stmt = $db->prepare($sales_query);
    $stmt->execute([$organizer_id]);
    $sales_stats = $stmt->fetch(PDO::FETCH_ASSOC);

    // Monthly trend
    $trend_query = "SELECT 
        DATE_FORMAT(s.created_at, '%Y-%m') as month,
        COUNT(*) as sales,
        SUM(s.total_amount) as revenue
        FROM sales s
        JOIN events e ON s.event_id = e.id
        WHERE e.organizer_id = ? AND s.status = 'completed'
        AND s.created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH)
        GROUP BY DATE_FORMAT(s.created_at, '%Y-%m')
        ORDER BY month ASC";

    $stmt = $db->prepare($trend_query);
    $stmt->execute([$organizer_id]);
    $monthly_trend = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Top events
    $top_events_query = "SELECT 
        e.id,
        e.title,
        e.event_date as date,
        COUNT(s.id) as sales_count,
        SUM(s.total_amount) as revenue,
        SUM(s.quantity) as tickets_sold,
        e.capacity as total_capacity,
        ROUND((SUM(s.quantity) / e.capacity) * 100, 1) as occupancy_rate
        FROM events e
        LEFT JOIN sales s ON e.id = s.event_id AND s.status = 'completed'
        WHERE e.organizer_id = ?
        GROUP BY e.id, e.title, e.event_date, e.capacity
        ORDER BY revenue DESC
        LIMIT 5";

    $stmt = $db->prepare($top_events_query);
    $stmt->execute([$organizer_id]);
    $top_events = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Recent activity
    $activity_query = "SELECT 
        'sale' as type,
        s.id,
        CONCAT('Nueva venta de ', s.quantity, ' boleto(s)') as description,
        s.total_amount as amount,
        e.title as event_title,
        s.created_at,
        CASE 
            WHEN TIMESTAMPDIFF(MINUTE, s.created_at, NOW()) < 60 
            THEN CONCAT(TIMESTAMPDIFF(MINUTE, s.created_at, NOW()), ' minutos')
            WHEN TIMESTAMPDIFF(HOUR, s.created_at, NOW()) < 24 
            THEN CONCAT(TIMESTAMPDIFF(HOUR, s.created_at, NOW()), ' horas')
            ELSE CONCAT(TIMESTAMPDIFF(DAY, s.created_at, NOW()), ' días')
        END as time_ago
        FROM sales s
        JOIN events e ON s.event_id = e.id
        WHERE e.organizer_id = ? AND s.status = 'completed'
        ORDER BY s.created_at DESC
        LIMIT 10";

    $stmt = $db->prepare($activity_query);
    $stmt->execute([$organizer_id]);
    $recent_activity = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Format response
    $response = [
        'success' => true,
        'data' => [
            'overview' => [
                'totalEvents' => (int)($overview['total_events'] ?? 0),
                'publishedEvents' => (int)($overview['published_events'] ?? 0),
                'draftEvents' => (int)($overview['draft_events'] ?? 0),
                'totalSales' => (int)($sales_stats['total_sales'] ?? 0),
                'totalRevenue' => (int)($sales_stats['total_revenue'] ?? 0),
                'totalTicketsSold' => (int)($sales_stats['total_tickets_sold'] ?? 0),
                'uniqueCustomers' => (int)($sales_stats['unique_customers'] ?? 0),
                'averageOrderValue' => (int)($sales_stats['average_order_value'] ?? 0)
            ],
            'monthlyTrend' => array_map(function($row) {
                return [
                    'month' => $row['month'],
                    'sales' => (int)$row['sales'],
                    'revenue' => (int)$row['revenue']
                ];
            }, $monthly_trend),
            'topEvents' => array_map(function($row) {
                return [
                    'id' => (int)$row['id'],
                    'title' => $row['title'],
                    'date' => $row['date'],
                    'salesCount' => (int)$row['sales_count'],
                    'revenue' => (int)$row['revenue'],
                    'ticketsSold' => (int)$row['tickets_sold'],
                    'totalCapacity' => (int)$row['total_capacity'],
                    'occupancyRate' => (float)$row['occupancy_rate']
                ];
            }, $top_events),
            'recentActivity' => array_map(function($row) {
                return [
                    'type' => $row['type'],
                    'id' => (int)$row['id'],
                    'description' => $row['description'],
                    'amount' => (int)$row['amount'],
                    'eventTitle' => $row['event_title'],
                    'createdAt' => $row['created_at'],
                    'timeAgo' => 'hace ' . $row['time_ago']
                ];
            }, $recent_activity)
        ],
        'timestamp' => date('Y-m-d H:i:s')
    ];

    http_response_code(200);
    echo json_encode($response);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error al obtener estadísticas: ' . $e->getMessage()
    ]);
}
?>

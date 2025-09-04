<?php
require_once '../../config/cors.php';
require_once '../../config/database.php';
require_once '../../models/Event.php';

$database = new Database();
$db = $database->getConnection();

$event = new Event($db);

// Get query parameters
$category = isset($_GET['category']) ? $_GET['category'] : '';
$location = isset($_GET['location']) ? $_GET['location'] : '';
$search = isset($_GET['search']) ? $_GET['search'] : '';
$featured = isset($_GET['featured']) ? $_GET['featured'] : '';

try {
    // Build query
    $query = "SELECT 
                e.id,
                e.title,
                e.description,
                e.event_date as date,
                e.event_time as time,
                e.venue,
                e.location,
                c.name as category,
                e.image_url,
                e.price_from,
                e.price_to,
                e.capacity,
                COALESCE(ticket_sales.tickets_sold, 0) as tickets_sold,
                e.slug,
                e.featured,
                e.status
              FROM events e
              LEFT JOIN categories c ON e.category_id = c.id
              LEFT JOIN (
                  SELECT event_id, COUNT(*) as tickets_sold
                  FROM sales 
                  WHERE status = 'completed'
                  GROUP BY event_id
              ) ticket_sales ON e.id = ticket_sales.event_id
              WHERE e.status = 'published'
              AND e.event_date >= CURDATE()";

    $params = [];

    if (!empty($category)) {
        $query .= " AND c.name = ?";
        $params[] = $category;
    }

    if (!empty($location)) {
        $query .= " AND e.location = ?";
        $params[] = $location;
    }

    if (!empty($search)) {
        $query .= " AND (e.title LIKE ? OR e.description LIKE ?)";
        $params[] = "%$search%";
        $params[] = "%$search%";
    }

    if ($featured === 'true') {
        $query .= " AND e.featured = 1";
    }

    $query .= " ORDER BY e.event_date ASC";

    $stmt = $db->prepare($query);
    $stmt->execute($params);

    $events = [];
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $events[] = [
            'id' => (int)$row['id'],
            'title' => $row['title'],
            'description' => $row['description'],
            'date' => $row['date'],
            'time' => $row['time'],
            'venue' => $row['venue'],
            'location' => $row['location'],
            'category' => $row['category'],
            'image_url' => $row['image_url'] ?: "/placeholder.svg?height=300&width=400&query=" . urlencode($row['title']),
            'price_from' => (int)$row['price_from'],
            'price_to' => (int)$row['price_to'],
            'capacity' => (int)$row['capacity'],
            'tickets_sold' => (int)$row['tickets_sold'],
            'slug' => $row['slug'],
            'featured' => (bool)$row['featured']
        ];
    }

    http_response_code(200);
    echo json_encode([
        'success' => true,
        'records' => $events,
        'count' => count($events)
    ]);

} catch (Exception $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'message' => 'Error al obtener eventos: ' . $e->getMessage()
    ]);
}
?>

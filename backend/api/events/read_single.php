<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/Event.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize event object
$event = new Event($db);

// Get ID or slug from URL
$event->id = isset($_GET['id']) ? $_GET['id'] : null;
$slug = isset($_GET['slug']) ? $_GET['slug'] : null;

if($slug) {
    // Find event by slug
    $query = "SELECT id FROM events WHERE slug = ? LIMIT 0,1";
    $stmt = $db->prepare($query);
    $stmt->bindParam(1, $slug);
    $stmt->execute();
    
    if($stmt->rowCount() > 0) {
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        $event->id = $row['id'];
    } else {
        http_response_code(404);
        echo json_encode(array("message" => "Event not found."));
        exit();
    }
}

// Get event details
$event_data = $event->read_single();

if($event_data) {
    // Get ticket types for this event
    $ticket_query = "SELECT id, name, description, price, quantity, sold, max_per_order, status 
                     FROM ticket_types WHERE event_id = ? AND status = 'active'";
    $ticket_stmt = $db->prepare($ticket_query);
    $ticket_stmt->bindParam(1, $event->id);
    $ticket_stmt->execute();
    
    $ticket_types = array();
    while($ticket_row = $ticket_stmt->fetch(PDO::FETCH_ASSOC)) {
        $ticket_types[] = array(
            "id" => $ticket_row['id'],
            "name" => $ticket_row['name'],
            "description" => $ticket_row['description'],
            "price" => (float)$ticket_row['price'],
            "quantity" => (int)$ticket_row['quantity'],
            "sold" => (int)$ticket_row['sold'],
            "available" => (int)$ticket_row['quantity'] - (int)$ticket_row['sold'],
            "maxPerOrder" => (int)$ticket_row['max_per_order'],
            "status" => $ticket_row['status']
        );
    }

    $event_item = array(
        "id" => $event_data['id'],
        "title" => $event_data['title'],
        "slug" => $event_data['slug'],
        "description" => $event_data['description'],
        "longDescription" => $event_data['long_description'],
        "date" => $event_data['date'],
        "time" => $event_data['time'],
        "venue" => $event_data['venue'],
        "location" => $event_data['location'],
        "locationDisplay" => strtoupper($event_data['location']),
        "category" => $event_data['category_slug'] ?? 'general',
        "categoryDisplay" => $event_data['category_name'] ?? 'General',
        "organizer" => $event_data['organizer_name'] ?? 'Organizador',
        "price" => (float)$event_data['price'],
        "capacity" => (int)$event_data['total_capacity'],
        "ticketsSold" => (int)$event_data['tickets_sold'],
        "revenue" => (float)$event_data['revenue'],
        "status" => $event_data['status'],
        "salesStartDate" => $event_data['sales_start_date'],
        "salesEndDate" => $event_data['sales_end_date'],
        "youtubeUrl" => $event_data['youtube_url'],
        "imageUrl" => $event_data['image_url'],
        "featured" => (bool)$event_data['featured'],
        "seatMapId" => $event_data['seat_map_id'],
        "createdAt" => $event_data['created_at'],
        "updatedAt" => $event_data['updated_at'],
        "ticketTypes" => $ticket_types
    );

    // Set response code - 200 OK
    http_response_code(200);

    // Show event data
    echo json_encode($event_item);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user event does not exist
    echo json_encode(array("message" => "Event does not exist."));
}
?>

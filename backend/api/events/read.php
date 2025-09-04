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

// Check if organizer_id is provided
$organizer_id = isset($_GET['organizer_id']) ? $_GET['organizer_id'] : null;

// Query events
if($organizer_id) {
    $stmt = $event->readByOrganizer($organizer_id);
} else {
    $stmt = $event->read();
}

$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $events_arr = array();
    $events_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $event_item = array(
            "id" => $id,
            "title" => $title,
            "slug" => $slug,
            "description" => $description,
            "longDescription" => $long_description,
            "date" => $date,
            "time" => $time,
            "venue" => $venue,
            "location" => $location,
            "locationDisplay" => strtoupper($location),
            "category" => $category_slug ?? 'general',
            "categoryDisplay" => $category_name ?? 'General',
            "organizer" => $organizer_name ?? 'Organizador',
            "price" => (float)$price,
            "capacity" => (int)$total_capacity,
            "ticketsSold" => (int)$tickets_sold,
            "revenue" => (float)$revenue,
            "status" => $status,
            "salesStartDate" => $sales_start_date,
            "salesEndDate" => $sales_end_date,
            "youtubeUrl" => $youtube_url,
            "imageUrl" => $image_url,
            "featured" => (bool)$featured,
            "seatMapId" => $seat_map_id,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at,
            "totalSales" => (int)($total_sales ?? 0)
        );

        array_push($events_arr["records"], $event_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show events data in json format
    echo json_encode($events_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no events found
    echo json_encode(array("message" => "No events found."));
}
?>

<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/SeatMap.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize seat map object
$seatMap = new SeatMap($db);

// Get ID from URL
$seatMap->id = isset($_GET['id']) ? $_GET['id'] : die();

// Get seat map details
$seat_map_data = $seatMap->read_single();

if($seat_map_data) {
    $seat_map_item = array(
        "id" => $seat_map_data['id'],
        "name" => $seat_map_data['name'],
        "venueName" => $seat_map_data['venue_name'],
        "totalCapacity" => (int)$seat_map_data['total_capacity'],
        "mapData" => json_decode($seat_map_data['map_data'], true),
        "templateId" => $seat_map_data['template_id'],
        "templateName" => $seat_map_data['template_name'],
        "createdBy" => $seat_map_data['created_by'],
        "creatorName" => $seat_map_data['creator_name'],
        "createdAt" => $seat_map_data['created_at'],
        "updatedAt" => $seat_map_data['updated_at']
    );

    // Set response code - 200 OK
    http_response_code(200);

    // Show seat map data
    echo json_encode($seat_map_item);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user seat map does not exist
    echo json_encode(array("message" => "Seat map does not exist."));
}
?>

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

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Make sure data is not empty
if(
    !empty($data->name) &&
    !empty($data->venue_name) &&
    !empty($data->total_capacity) &&
    !empty($data->map_data) &&
    !empty($data->created_by)
) {
    // Set seat map property values
    $seatMap->name = $data->name;
    $seatMap->venue_name = $data->venue_name;
    $seatMap->total_capacity = $data->total_capacity;
    $seatMap->map_data = $data->map_data;
    $seatMap->template_id = $data->template_id ?? null;
    $seatMap->created_by = $data->created_by;

    // Create the seat map
    if($seatMap->create()) {
        // Set response code - 201 created
        http_response_code(201);

        // Tell the user
        echo json_encode(array(
            "message" => "Seat map was created.",
            "id" => $seatMap->id
        ));
    } else {
        // Set response code - 503 service unavailable
        http_response_code(503);

        // Tell the user
        echo json_encode(array("message" => "Unable to create seat map."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "Unable to create seat map. Data is incomplete."));
}
?>

<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/Seat.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize seat object
$seat = new Seat($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Make sure data is not empty
if(!empty($data->seat_ids) && !empty($data->user_id)) {
    
    // Occupy seats (final purchase)
    if($seat->occupySeats($data->seat_ids, $data->user_id)) {
        // Set response code - 200 OK
        http_response_code(200);

        // Tell the user
        echo json_encode(array(
            "message" => "Seats purchased successfully.",
            "seat_ids" => $data->seat_ids,
            "user_id" => $data->user_id
        ));
    } else {
        // Set response code - 409 conflict
        http_response_code(409);

        // Tell the user
        echo json_encode(array("message" => "Unable to purchase seats. Some seats may already be taken."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "Unable to purchase seats. Data is incomplete."));
}
?>

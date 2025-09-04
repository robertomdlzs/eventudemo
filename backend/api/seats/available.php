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

// Get event_id from URL
$event_id = isset($_GET['event_id']) ? $_GET['event_id'] : die();

// Get available seats
$stmt = $seat->getAvailableSeats($event_id);
$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $seats_arr = array();
    $seats_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $seat_item = array(
            "id" => $id,
            "seatNumber" => $seat_number,
            "rowNumber" => $row_number,
            "status" => $status,
            "positionX" => (int)$position_x,
            "positionY" => (int)$position_y,
            "section" => array(
                "name" => $section_name,
                "type" => $section_type,
                "priceModifier" => (float)$price_modifier,
                "color" => $color
            ),
            "seatMapName" => $seat_map_name
        );

        array_push($seats_arr["records"], $seat_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show seats data in json format
    echo json_encode($seats_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no available seats found
    echo json_encode(array("message" => "No available seats found."));
}
?>

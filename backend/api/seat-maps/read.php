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

// Query seat maps
$stmt = $seatMap->read();
$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $seat_maps_arr = array();
    $seat_maps_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $seat_map_item = array(
            "id" => $id,
            "name" => $name,
            "venueName" => $venue_name,
            "totalCapacity" => (int)$total_capacity,
            "mapData" => json_decode($map_data, true),
            "templateId" => $template_id,
            "templateName" => $template_name,
            "createdBy" => $created_by,
            "creatorName" => $creator_name,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at
        );

        array_push($seat_maps_arr["records"], $seat_map_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show seat maps data in json format
    echo json_encode($seat_maps_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no seat maps found
    echo json_encode(array("message" => "No seat maps found."));
}
?>

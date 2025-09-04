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

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Make sure data is not empty
if(
    !empty($data->title) &&
    !empty($data->description) &&
    !empty($data->date) &&
    !empty($data->time) &&
    !empty($data->venue) &&
    !empty($data->location) &&
    !empty($data->organizer_id)
) {
    // Set event property values
    $event->title = $data->title;
    $event->description = $data->description;
    $event->long_description = $data->long_description ?? '';
    $event->date = $data->date;
    $event->time = $data->time;
    $event->venue = $data->venue;
    $event->location = $data->location;
    $event->category_id = $data->category_id ?? null;
    $event->organizer_id = $data->organizer_id;
    $event->total_capacity = $data->total_capacity ?? 0;
    $event->price = $data->price ?? 0.00;
    $event->status = $data->status ?? 'draft';
    $event->sales_start_date = $data->sales_start_date ?? null;
    $event->youtube_url = $data->youtube_url ?? null;
    $event->image_url = $data->image_url ?? null;
    $event->featured = $data->featured ?? false;

    // Create the event
    if($event->create()) {
        // Set response code - 201 created
        http_response_code(201);

        // Tell the user
        echo json_encode(array(
            "message" => "Event was created.",
            "id" => $event->id,
            "slug" => $event->slug
        ));
    } else {
        // Set response code - 503 service unavailable
        http_response_code(503);

        // Tell the user
        echo json_encode(array("message" => "Unable to create event."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "Unable to create event. Data is incomplete."));
}
?>

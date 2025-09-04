<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Get event_id if provided
$event_id = isset($_GET['event_id']) ? $_GET['event_id'] : null;

// Build query
$query = "SELECT 
            tt.id, tt.name, tt.description, tt.price, tt.quantity, 
            tt.sold, tt.max_per_order, tt.status, tt.sale_start, 
            tt.sale_end, tt.created_at, tt.updated_at,
            e.title as event_title, e.slug as event_slug
          FROM ticket_types tt
          JOIN events e ON tt.event_id = e.id
          WHERE 1=1";

$params = array();

if($event_id) {
    $query .= " AND tt.event_id = ?";
    $params[] = $event_id;
}

$query .= " ORDER BY tt.created_at DESC";

$stmt = $db->prepare($query);
$stmt->execute($params);

$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $ticket_types_arr = array();
    $ticket_types_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $ticket_type_item = array(
            "id" => $id,
            "name" => $name,
            "description" => $description,
            "price" => (float)$price,
            "quantity" => (int)$quantity,
            "sold" => (int)$sold,
            "available" => (int)$quantity - (int)$sold,
            "maxPerOrder" => (int)$max_per_order,
            "status" => $status,
            "saleStart" => $sale_start,
            "saleEnd" => $sale_end,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at,
            "event" => array(
                "title" => $event_title,
                "slug" => $event_slug
            )
        );

        array_push($ticket_types_arr["records"], $ticket_type_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show ticket types data in json format
    echo json_encode($ticket_types_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no ticket types found
    echo json_encode(array("message" => "No ticket types found."));
}
?>

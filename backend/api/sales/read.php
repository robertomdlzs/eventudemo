<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Get filters
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;
$event_id = isset($_GET['event_id']) ? $_GET['event_id'] : null;
$organizer_id = isset($_GET['organizer_id']) ? $_GET['organizer_id'] : null;
$status = isset($_GET['status']) ? $_GET['status'] : null;

// Build query
$query = "SELECT 
            s.id, s.quantity, s.unit_price, s.total_amount, s.status,
            s.payment_method, s.buyer_name, s.buyer_email, s.created_at,
            e.title as event_title, e.slug as event_slug, e.date as event_date,
            e.venue as event_venue, e.location as event_location,
            tt.name as ticket_type_name,
            CONCAT(u.first_name, ' ', u.last_name) as user_name
          FROM sales s
          JOIN events e ON s.event_id = e.id
          JOIN ticket_types tt ON s.ticket_type_id = tt.id
          JOIN users u ON s.user_id = u.id
          WHERE 1=1";

$params = array();

if($user_id) {
    $query .= " AND s.user_id = ?";
    $params[] = $user_id;
}

if($event_id) {
    $query .= " AND s.event_id = ?";
    $params[] = $event_id;
}

if($organizer_id) {
    $query .= " AND e.organizer_id = ?";
    $params[] = $organizer_id;
}

if($status) {
    $query .= " AND s.status = ?";
    $params[] = $status;
}

$query .= " ORDER BY s.created_at DESC";

$stmt = $db->prepare($query);
$stmt->execute($params);

$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $sales_arr = array();
    $sales_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $sale_item = array(
            "id" => $id,
            "quantity" => (int)$quantity,
            "unitPrice" => (float)$unit_price,
            "totalAmount" => (float)$total_amount,
            "status" => $status,
            "paymentMethod" => $payment_method,
            "buyerName" => $buyer_name,
            "buyerEmail" => $buyer_email,
            "createdAt" => $created_at,
            "event" => array(
                "title" => $event_title,
                "slug" => $event_slug,
                "date" => $event_date,
                "venue" => $event_venue,
                "location" => strtoupper($event_location)
            ),
            "ticketType" => $ticket_type_name,
            "userName" => $user_name
        );

        array_push($sales_arr["records"], $sale_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show sales data in json format
    echo json_encode($sales_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no sales found
    echo json_encode(array("message" => "No sales found."));
}
?>

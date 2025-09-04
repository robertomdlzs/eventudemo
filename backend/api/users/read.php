<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/User.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize user object
$user = new User($db);

// Query users
$stmt = $user->read();
$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $users_arr = array();
    $users_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $user_item = array(
            "id" => $id,
            "name" => $first_name . " " . $last_name,
            "firstName" => $first_name,
            "lastName" => $last_name,
            "email" => $email,
            "phone" => $phone,
            "role" => $role,
            "status" => $status,
            "is2FAEnabled" => (bool)$is_2fa_enabled,
            "emailVerifiedAt" => $email_verified_at,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at,
            "lastLogin" => $last_login,
            "eventsCreated" => (int)$events_created,
            "ticketsSold" => (int)$tickets_sold
        );

        array_push($users_arr["records"], $user_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show users data in json format
    echo json_encode($users_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no users found
    echo json_encode(array("message" => "No users found."));
}
?>

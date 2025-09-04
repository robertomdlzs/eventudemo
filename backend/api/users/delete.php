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

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Check if data is not empty
if(!empty($data->id)) {
    // Set user property values
    $user->id = $data->id;

    // Delete the user
    if($user->delete()) {
        // Set response code - 200 ok
        http_response_code(200);

        // Tell the user
        echo json_encode(array("message" => "Usuario eliminado exitosamente."));
    } else {
        // Set response code - 503 service unavailable
        http_response_code(503);

        // Tell the user
        echo json_encode(array("message" => "No se pudo eliminar el usuario."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "No se pudo eliminar el usuario. ID no proporcionado."));
}
?>

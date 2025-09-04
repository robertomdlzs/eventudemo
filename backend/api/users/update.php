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
if(!empty($data->id) && !empty($data->name)) {
    // Split name into first_name and last_name
    $name_parts = explode(' ', $data->name, 2);
    $user->first_name = $name_parts[0];
    $user->last_name = isset($name_parts[1]) ? $name_parts[1] : '';
    
    // Set user property values
    $user->id = $data->id;
    $user->email = $data->email;
    $user->phone = $data->phone ?? null;
    $user->role = $data->role;
    $user->status = $data->status;

    // Update the user
    if($user->update()) {
        // Set response code - 200 ok
        http_response_code(200);

        // Tell the user
        echo json_encode(array("message" => "Usuario actualizado exitosamente."));
    } else {
        // Set response code - 503 service unavailable
        http_response_code(503);

        // Tell the user
        echo json_encode(array("message" => "No se pudo actualizar el usuario."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "No se pudo actualizar el usuario. Datos incompletos."));
}
?>

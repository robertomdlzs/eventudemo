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
if(!empty($data->name) && !empty($data->email) && !empty($data->role)) {
    // Split name into first_name and last_name
    $name_parts = explode(' ', $data->name, 2);
    $user->first_name = $name_parts[0];
    $user->last_name = isset($name_parts[1]) ? $name_parts[1] : '';
    
    // Set user property values
    $user->email = $data->email;
    $user->phone = $data->phone ?? null;
    $user->role = $data->role;
    $user->status = $data->status ?? 'active';
    $user->password_hash = $data->password ?? 'default_password_123'; // Default password

    // Check if email already exists
    if($user->emailExists()) {
        // Set response code - 400 bad request
        http_response_code(400);

        // Tell the user
        echo json_encode(array("message" => "El email ya existe."));
        return;
    }

    // Create the user
    if($user->create()) {
        // Set response code - 201 created
        http_response_code(201);

        // Tell the user
        echo json_encode(array("message" => "Usuario creado exitosamente."));
    } else {
        // Set response code - 503 service unavailable
        http_response_code(503);

        // Tell the user
        echo json_encode(array("message" => "No se pudo crear el usuario."));
    }
} else {
    // Set response code - 400 bad request
    http_response_code(400);

    // Tell the user
    echo json_encode(array("message" => "No se pudo crear el usuario. Datos incompletos."));
}
?>

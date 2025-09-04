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

// Check if email and password are provided
if(!empty($data->email) && !empty($data->password)) {
    
    // Attempt login
    if($user->login($data->email, $data->password)) {
        
        // Set response code - 200 OK
        http_response_code(200);
        
        // Create response array
        $response = array(
            "message" => "Login successful.",
            "user" => array(
                "id" => $user->id,
                "firstName" => $user->first_name,
                "lastName" => $user->last_name,
                "name" => $user->first_name . " " . $user->last_name,
                "email" => $user->email,
                "role" => $user->role,
                "status" => $user->status
            )
        );
        
        // Start session and store user data
        session_start();
        $_SESSION['user_id'] = $user->id;
        $_SESSION['user_email'] = $user->email;
        $_SESSION['user_role'] = $user->role;
        
        echo json_encode($response);
        
    } else {
        // Set response code - 401 unauthorized
        http_response_code(401);
        
        // Tell the user login failed
        echo json_encode(array("message" => "Login failed. Invalid credentials."));
    }
    
} else {
    // Set response code - 400 bad request
    http_response_code(400);
    
    // Tell the user data is incomplete
    echo json_encode(array("message" => "Unable to login. Data is incomplete."));
}
?>

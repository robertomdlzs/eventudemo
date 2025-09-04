<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

echo json_encode([
    'message' => 'Eventu API Backend',
    'version' => '1.0.0',
    'status' => 'active',
    'endpoints' => [
        'events' => '/api/events/',
        'categories' => '/api/categories/',
        'users' => '/api/users/',
        'auth' => '/api/auth/',
        'sales' => '/api/sales/',
        'organizer' => '/api/organizer/'
    ]
]);
?>

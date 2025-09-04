<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Query to get seat map templates
$query = "SELECT 
            id, name, description, template_data, thumbnail_url,
            is_public, created_by, created_at, updated_at,
            (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = smt.created_by) as creator_name
          FROM seat_map_templates smt
          WHERE is_public = 1
          ORDER BY name ASC";

$stmt = $db->prepare($query);
$stmt->execute();

$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $templates_arr = array();
    $templates_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $template_item = array(
            "id" => $id,
            "name" => $name,
            "description" => $description,
            "templateData" => json_decode($template_data, true),
            "thumbnailUrl" => $thumbnail_url,
            "isPublic" => (bool)$is_public,
            "createdBy" => $created_by,
            "creatorName" => $creator_name,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at
        );

        array_push($templates_arr["records"], $template_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show templates data in json format
    echo json_encode($templates_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no templates found
    echo json_encode(array("message" => "No seat map templates found."));
}
?>

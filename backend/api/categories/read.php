<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Query to get categories
$query = "SELECT 
            id, name, slug, description, icon, color, status,
            created_at, updated_at,
            (SELECT COUNT(*) FROM events WHERE category_id = c.id) as event_count
          FROM categories c
          WHERE status = 'active'
          ORDER BY name ASC";

$stmt = $db->prepare($query);
$stmt->execute();

$num = $stmt->rowCount();

// Check if more than 0 record found
if($num > 0) {
    $categories_arr = array();
    $categories_arr["records"] = array();

    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        extract($row);

        $category_item = array(
            "id" => $id,
            "name" => $name,
            "slug" => $slug,
            "description" => $description,
            "icon" => $icon,
            "color" => $color,
            "eventCount" => (int)$event_count,
            "status" => $status,
            "createdAt" => $created_at,
            "updatedAt" => $updated_at
        );

        array_push($categories_arr["records"], $category_item);
    }

    // Set response code - 200 OK
    http_response_code(200);

    // Show categories data in json format
    echo json_encode($categories_arr);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user no categories found
    echo json_encode(array("message" => "No categories found."));
}
?>

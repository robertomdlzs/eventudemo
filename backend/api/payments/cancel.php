<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/Payment.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize payment object
$payment = new Payment($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Make sure payment ID is provided
if(!empty($data->payment_id)) {
    
    try {
        // Start transaction
        $db->beginTransaction();
        
        // Get payment details
        $payment->id = $data->payment_id;
        $payment_data = $payment->read_single();
        
        if(!$payment_data) {
            throw new Exception("Payment not found");
        }
        
        // Check if payment can be cancelled
        if($payment_data['status'] !== 'pending' && $payment_data['status'] !== 'processing') {
            throw new Exception("Payment cannot be cancelled. Current status: " . $payment_data['status']);
        }
        
        // Update payment status to cancelled
        $payment->updateStatus('cancelled', null, json_encode(['reason' => 'User cancellation']));
        
        // Update corresponding sale status
        $update_sale_query = "UPDATE sales SET status='cancelled' WHERE id=?";
        $update_sale_stmt = $db->prepare($update_sale_query);
        $update_sale_stmt->execute([$payment_data['sale_id']]);
        
        // If seats were reserved, release them
        $release_seats_query = "UPDATE seats s
                                JOIN sales sa ON sa.id = ?
                                SET s.status = 'available'
                                WHERE s.status = 'reserved'";
        $release_seats_stmt = $db->prepare($release_seats_query);
        $release_seats_stmt->execute([$payment_data['sale_id']]);
        
        // Commit transaction
        $db->commit();
        
        // Set response code - 200 OK
        http_response_code(200);
        
        echo json_encode(array(
            "message" => "Payment cancelled successfully.",
            "payment_id" => $payment->id,
            "status" => "cancelled"
        ));
        
    } catch(Exception $e) {
        // Rollback transaction
        $db->rollback();
        
        // Set response code - 400 Bad Request
        http_response_code(400);
        
        echo json_encode(array(
            "message" => "Payment cancellation failed: " . $e->getMessage()
        ));
    }
    
} else {
    // Set response code - 400 bad request
    http_response_code(400);
    
    echo json_encode(array("message" => "Payment ID is required."));
}
?>

<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/Payment.php';
include_once '../../models/PaymentGateway.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Get webhook data
$payload = file_get_contents('php://input');
$signature = $_SERVER['HTTP_X_SIGNATURE'] ?? '';
$gateway_type = $_GET['gateway'] ?? 'test';

try {
    // Verify webhook signature
    $gateway = new PaymentGateway($gateway_type);
    
    if(!$gateway->verifyWebhook($payload, $signature)) {
        http_response_code(401);
        echo json_encode(array("message" => "Invalid webhook signature"));
        exit();
    }
    
    // Parse webhook data
    $webhook_data = json_decode($payload, true);
    
    if(!$webhook_data) {
        http_response_code(400);
        echo json_encode(array("message" => "Invalid webhook payload"));
        exit();
    }
    
    // Extract payment information based on gateway
    $transaction_id = null;
    $status = null;
    
    switch($gateway_type) {
        case 'stripe':
            $transaction_id = $webhook_data['data']['object']['id'] ?? null;
            $status = $webhook_data['data']['object']['status'] ?? null;
            break;
        case 'paypal':
            $transaction_id = $webhook_data['resource']['id'] ?? null;
            $status = $webhook_data['resource']['state'] ?? null;
            break;
        case 'mercadopago':
            $transaction_id = $webhook_data['data']['id'] ?? null;
            $status = $webhook_data['data']['status'] ?? null;
            break;
        case 'wompi':
            $transaction_id = $webhook_data['data']['id'] ?? null;
            $status = $webhook_data['data']['status'] ?? null;
            break;
        default:
            $transaction_id = $webhook_data['transaction_id'] ?? null;
            $status = $webhook_data['status'] ?? null;
    }
    
    if(!$transaction_id || !$status) {
        http_response_code(400);
        echo json_encode(array("message" => "Missing transaction ID or status"));
        exit();
    }
    
    // Find payment by transaction ID
    $query = "SELECT id FROM payments WHERE gateway_transaction_id = ? LIMIT 1";
    $stmt = $db->prepare($query);
    $stmt->execute([$transaction_id]);
    
    if($stmt->rowCount() > 0) {
        $payment_row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        // Update payment status
        $payment = new Payment($db);
        $payment->id = $payment_row['id'];
        
        $payment->updateStatus($status, $transaction_id, $payload);
        
        // Update corresponding sale status
        $sale_status = ($status === 'completed' || $status === 'approved') ? 'completed' : 'cancelled';
        
        $update_sale_query = "UPDATE sales s 
                              JOIN payments p ON s.id = p.sale_id 
                              SET s.status = ? 
                              WHERE p.id = ?";
        $update_sale_stmt = $db->prepare($update_sale_query);
        $update_sale_stmt->execute([$sale_status, $payment->id]);
        
        // Log webhook processing
        error_log("Webhook processed: Gateway={$gateway_type}, Transaction={$transaction_id}, Status={$status}");
        
        http_response_code(200);
        echo json_encode(array("message" => "Webhook processed successfully"));
        
    } else {
        http_response_code(404);
        echo json_encode(array("message" => "Payment not found"));
    }
    
} catch(Exception $e) {
    error_log("Webhook processing error: " . $e->getMessage());
    
    http_response_code(500);
    echo json_encode(array("message" => "Webhook processing failed"));
}
?>

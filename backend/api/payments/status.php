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

// Get payment ID from URL
$payment->id = isset($_GET['id']) ? $_GET['id'] : die();

// Get payment details
$payment_data = $payment->read_single();

if($payment_data) {
    $payment_item = array(
        "id" => $payment_data['id'],
        "saleId" => $payment_data['sale_id'],
        "paymentMethod" => $payment_data['payment_method'],
        "paymentGateway" => $payment_data['payment_gateway'],
        "gatewayTransactionId" => $payment_data['gateway_transaction_id'],
        "amount" => (float)$payment_data['amount'],
        "currency" => $payment_data['currency'],
        "status" => $payment_data['status'],
        "gatewayResponse" => json_decode($payment_data['gateway_response'], true),
        "processedAt" => $payment_data['processed_at'],
        "createdAt" => $payment_data['created_at'],
        "updatedAt" => $payment_data['updated_at'],
        "sale" => array(
            "amount" => (float)$payment_data['sale_amount'],
            "buyerName" => $payment_data['buyer_name'],
            "buyerEmail" => $payment_data['buyer_email']
        ),
        "event" => array(
            "title" => $payment_data['event_title']
        )
    );

    // Set response code - 200 OK
    http_response_code(200);

    // Show payment data
    echo json_encode($payment_item);
} else {
    // Set response code - 404 Not found
    http_response_code(404);

    // Tell the user payment does not exist
    echo json_encode(array("message" => "Payment does not exist."));
}
?>

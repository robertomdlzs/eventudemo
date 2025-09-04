<?php
// Headers
include_once '../../config/cors.php';
include_once '../../config/database.php';
include_once '../../models/Payment.php';
include_once '../../models/PaymentGateway.php';

// Get database connection
$database = new Database();
$db = $database->getConnection();

// Initialize payment object
$payment = new Payment($db);

// Get posted data
$data = json_decode(file_get_contents("php://input"));

// Make sure data is not empty
if(
    !empty($data->user_id) &&
    !empty($data->event_id) &&
    !empty($data->payment_method) &&
    !empty($data->payment_details)
) {
    
    try {
        // Start transaction
        $db->beginTransaction();
        
        // Create sale record first
        $sale_query = "INSERT INTO sales 
                       SET user_id=:user_id, event_id=:event_id, 
                           ticket_type_id=:ticket_type_id, quantity=:quantity,
                           unit_price=:unit_price, total_amount=:total_amount,
                           status='pending', payment_method=:payment_method,
                           buyer_name=:buyer_name, buyer_email=:buyer_email";
        
        $sale_stmt = $db->prepare($sale_query);
        $sale_stmt->bindParam(":user_id", $data->user_id);
        $sale_stmt->bindParam(":event_id", $data->event_id);
        $sale_stmt->bindParam(":ticket_type_id", $data->payment_details->ticket_type_id);
        $sale_stmt->bindParam(":quantity", $data->payment_details->quantity);
        $sale_stmt->bindParam(":unit_price", $data->payment_details->unit_price);
        $sale_stmt->bindParam(":total_amount", $data->payment_details->total_amount);
        $sale_stmt->bindParam(":payment_method", $data->payment_method);
        $sale_stmt->bindParam(":buyer_name", $data->payment_details->buyer_name);
        $sale_stmt->bindParam(":buyer_email", $data->payment_details->buyer_email);
        
        if(!$sale_stmt->execute()) {
            throw new Exception("Failed to create sale record");
        }
        
        $sale_id = $db->lastInsertId();
        
        // Create payment record
        $payment->sale_id = $sale_id;
        $payment->payment_method = $data->payment_method;
        $payment->payment_gateway = $data->payment_details->gateway ?? 'test';
        $payment->amount = $data->payment_details->total_amount;
        $payment->currency = $data->payment_details->currency ?? 'COP';
        $payment->status = 'pending';
        
        if(!$payment->create()) {
            throw new Exception("Failed to create payment record");
        }
        
        // Process payment through gateway
        $gateway = new PaymentGateway($payment->payment_gateway);
        $payment_result = $gateway->processPayment($data->payment_details);
        
        if($payment_result['success']) {
            // Update payment status
            $payment->updateStatus(
                $payment_result['status'],
                $payment_result['transaction_id'],
                json_encode($payment_result)
            );
            
            // Update sale status
            $update_sale_query = "UPDATE sales SET status='completed' WHERE id=?";
            $update_sale_stmt = $db->prepare($update_sale_query);
            $update_sale_stmt->execute([$sale_id]);
            
            // If seats were selected, mark them as sold
            if(!empty($data->seat_ids)) {
                include_once '../../models/Seat.php';
                $seat = new Seat($db);
                $seat->occupySeats($data->seat_ids, $data->user_id);
            }
            
            // Commit transaction
            $db->commit();
            
            // Set response code - 200 OK
            http_response_code(200);
            
            echo json_encode(array(
                "message" => "Payment processed successfully.",
                "payment_id" => $payment->id,
                "sale_id" => $sale_id,
                "transaction_id" => $payment_result['transaction_id'],
                "status" => $payment_result['status']
            ));
            
        } else {
            // Update payment status to failed
            $payment->updateStatus(
                $payment_result['status'],
                null,
                json_encode($payment_result)
            );
            
            // Update sale status to cancelled
            $update_sale_query = "UPDATE sales SET status='cancelled' WHERE id=?";
            $update_sale_stmt = $db->prepare($update_sale_query);
            $update_sale_stmt->execute([$sale_id]);
            
            // Commit transaction (to save the failed records)
            $db->commit();
            
            // Set response code - 402 Payment Required
            http_response_code(402);
            
            echo json_encode(array(
                "message" => "Payment failed: " . $payment_result['message'],
                "payment_id" => $payment->id,
                "status" => $payment_result['status']
            ));
        }
        
    } catch(Exception $e) {
        // Rollback transaction
        $db->rollback();
        
        // Set response code - 500 Internal Server Error
        http_response_code(500);
        
        echo json_encode(array(
            "message" => "Payment processing failed: " . $e->getMessage()
        ));
    }
    
} else {
    // Set response code - 400 bad request
    http_response_code(400);
    
    echo json_encode(array("message" => "Unable to process payment. Data is incomplete."));
}
?>

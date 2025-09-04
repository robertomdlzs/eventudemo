<?php
class Payment {
    private $conn;
    private $table_name = "payments";

    public $id;
    public $sale_id;
    public $payment_method;
    public $payment_gateway;
    public $gateway_transaction_id;
    public $amount;
    public $currency;
    public $status;
    public $gateway_response;
    public $processed_at;
    public $created_at;
    public $updated_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Create payment record
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET sale_id=:sale_id, payment_method=:payment_method,
                      payment_gateway=:payment_gateway, amount=:amount,
                      currency=:currency, status=:status";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->payment_method = htmlspecialchars(strip_tags($this->payment_method));
        $this->payment_gateway = htmlspecialchars(strip_tags($this->payment_gateway));
        $this->currency = htmlspecialchars(strip_tags($this->currency));
        $this->status = htmlspecialchars(strip_tags($this->status));

        // Bind values
        $stmt->bindParam(":sale_id", $this->sale_id);
        $stmt->bindParam(":payment_method", $this->payment_method);
        $stmt->bindParam(":payment_gateway", $this->payment_gateway);
        $stmt->bindParam(":amount", $this->amount);
        $stmt->bindParam(":currency", $this->currency);
        $stmt->bindParam(":status", $this->status);

        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }

    // Update payment status
    public function updateStatus($status, $gateway_transaction_id = null, $gateway_response = null) {
        $query = "UPDATE " . $this->table_name . "
                  SET status=:status, gateway_transaction_id=:gateway_transaction_id,
                      gateway_response=:gateway_response, processed_at=CURRENT_TIMESTAMP,
                      updated_at=CURRENT_TIMESTAMP
                  WHERE id=:id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $status = htmlspecialchars(strip_tags($status));
        $gateway_transaction_id = htmlspecialchars(strip_tags($gateway_transaction_id));

        // Bind values
        $stmt->bindParam(":status", $status);
        $stmt->bindParam(":gateway_transaction_id", $gateway_transaction_id);
        $stmt->bindParam(":gateway_response", $gateway_response);
        $stmt->bindParam(":id", $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Get payment by ID
    public function read_single() {
        $query = "SELECT 
                    p.id, p.sale_id, p.payment_method, p.payment_gateway,
                    p.gateway_transaction_id, p.amount, p.currency, p.status,
                    p.gateway_response, p.processed_at, p.created_at, p.updated_at,
                    s.total_amount as sale_amount, s.buyer_name, s.buyer_email,
                    e.title as event_title
                  FROM " . $this->table_name . " p
                  JOIN sales s ON p.sale_id = s.id
                  JOIN events e ON s.event_id = e.id
                  WHERE p.id = ? LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->sale_id = $row['sale_id'];
            $this->payment_method = $row['payment_method'];
            $this->payment_gateway = $row['payment_gateway'];
            $this->gateway_transaction_id = $row['gateway_transaction_id'];
            $this->amount = $row['amount'];
            $this->currency = $row['currency'];
            $this->status = $row['status'];
            $this->gateway_response = $row['gateway_response'];
            $this->processed_at = $row['processed_at'];
            $this->created_at = $row['created_at'];
            $this->updated_at = $row['updated_at'];
            return $row;
        }
        return false;
    }
}
?>

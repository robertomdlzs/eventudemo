<?php
class User {
    private $conn;
    private $table_name = "users";

    public $id;
    public $first_name;
    public $last_name;
    public $email;
    public $phone;
    public $password_hash;
    public $role;
    public $status;
    public $is_2fa_enabled;
    public $two_factor_secret;
    public $email_verified_at;
    public $created_at;
    public $updated_at;
    public $last_login;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all users
    public function read() {
        $query = "SELECT 
                    id, first_name, last_name, email, phone, role, status, 
                    is_2fa_enabled, email_verified_at, created_at, 
                    updated_at, last_login,
                    (SELECT COUNT(*) FROM events WHERE organizer_id = u.id) as events_created,
                    (SELECT COALESCE(SUM(s.quantity), 0) FROM sales s 
                     JOIN events e ON s.event_id = e.id 
                     WHERE e.organizer_id = u.id AND s.status = 'completed') as tickets_sold
                  FROM " . $this->table_name . " u
                  ORDER BY created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt;
    }

    // Get single user
    public function read_single() {
        $query = "SELECT 
                    id, first_name, last_name, email, phone, role, status, 
                    is_2fa_enabled, email_verified_at, created_at, 
                    updated_at, last_login
                  FROM " . $this->table_name . " 
                  WHERE id = ? LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->first_name = $row['first_name'];
            $this->last_name = $row['last_name'];
            $this->email = $row['email'];
            $this->phone = $row['phone'];
            $this->role = $row['role'];
            $this->status = $row['status'];
            $this->is_2fa_enabled = $row['is_2fa_enabled'];
            $this->email_verified_at = $row['email_verified_at'];
            $this->created_at = $row['created_at'];
            $this->updated_at = $row['updated_at'];
            $this->last_login = $row['last_login'];
            return true;
        }
        return false;
    }

    // Create user
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET first_name=:first_name, last_name=:last_name, 
                      email=:email, phone=:phone, password_hash=:password_hash, 
                      role=:role, status=:status";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->first_name = htmlspecialchars(strip_tags($this->first_name));
        $this->last_name = htmlspecialchars(strip_tags($this->last_name));
        $this->email = htmlspecialchars(strip_tags($this->email));
        $this->phone = htmlspecialchars(strip_tags($this->phone));
        $this->password_hash = password_hash($this->password_hash, PASSWORD_DEFAULT);
        $this->role = htmlspecialchars(strip_tags($this->role));
        $this->status = htmlspecialchars(strip_tags($this->status));

        // Bind values
        $stmt->bindParam(":first_name", $this->first_name);
        $stmt->bindParam(":last_name", $this->last_name);
        $stmt->bindParam(":email", $this->email);
        $stmt->bindParam(":phone", $this->phone);
        $stmt->bindParam(":password_hash", $this->password_hash);
        $stmt->bindParam(":role", $this->role);
        $stmt->bindParam(":status", $this->status);

        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }

    // Update user
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET first_name=:first_name, last_name=:last_name, 
                      email=:email, phone=:phone, role=:role, status=:status,
                      updated_at=CURRENT_TIMESTAMP
                  WHERE id=:id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->first_name = htmlspecialchars(strip_tags($this->first_name));
        $this->last_name = htmlspecialchars(strip_tags($this->last_name));
        $this->email = htmlspecialchars(strip_tags($this->email));
        $this->phone = htmlspecialchars(strip_tags($this->phone));
        $this->role = htmlspecialchars(strip_tags($this->role));
        $this->status = htmlspecialchars(strip_tags($this->status));
        $this->id = htmlspecialchars(strip_tags($this->id));

        // Bind values
        $stmt->bindParam(":first_name", $this->first_name);
        $stmt->bindParam(":last_name", $this->last_name);
        $stmt->bindParam(":email", $this->email);
        $stmt->bindParam(":phone", $this->phone);
        $stmt->bindParam(":role", $this->role);
        $stmt->bindParam(":status", $this->status);
        $stmt->bindParam(":id", $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Delete user
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Login user
    public function login($email, $password) {
        $query = "SELECT id, first_name, last_name, email, password_hash, role, status 
                  FROM " . $this->table_name . " 
                  WHERE email = ? AND status = 'active' LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $email);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row && password_verify($password, $row['password_hash'])) {
            $this->id = $row['id'];
            $this->first_name = $row['first_name'];
            $this->last_name = $row['last_name'];
            $this->email = $row['email'];
            $this->role = $row['role'];
            $this->status = $row['status'];

            // Update last login
            $update_query = "UPDATE " . $this->table_name . " 
                           SET last_login = CURRENT_TIMESTAMP 
                           WHERE id = ?";
            $update_stmt = $this->conn->prepare($update_query);
            $update_stmt->bindParam(1, $this->id);
            $update_stmt->execute();

            return true;
        }
        return false;
    }

    // Check if email exists
    public function emailExists() {
        $query = "SELECT id FROM " . $this->table_name . " WHERE email = ? LIMIT 0,1";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->email);
        $stmt->execute();

        if($stmt->rowCount() > 0) {
            return true;
        }
        return false;
    }
}
?>

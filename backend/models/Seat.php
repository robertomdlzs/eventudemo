<?php
class Seat {
    private $conn;
    private $table_name = "seats";

    public $id;
    public $section_id;
    public $seat_number;
    public $row_number;
    public $status;
    public $position_x;
    public $position_y;
    public $created_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get seats by section
    public function readBySection($section_id) {
        $query = "SELECT 
                    s.id, s.seat_number, s.row_number, s.status,
                    s.position_x, s.position_y, s.created_at,
                    ss.name as section_name, ss.section_type,
                    ss.price_modifier, ss.color
                  FROM " . $this->table_name . " s
                  JOIN seat_sections ss ON s.section_id = ss.id
                  WHERE s.section_id = ?
                  ORDER BY s.row_number, s.seat_number";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $section_id);
        $stmt->execute();
        return $stmt;
    }

    // Get available seats for event
    public function getAvailableSeats($event_id) {
        $query = "SELECT 
                    s.id, s.seat_number, s.row_number, s.status,
                    s.position_x, s.position_y,
                    ss.name as section_name, ss.section_type,
                    ss.price_modifier, ss.color,
                    sm.name as seat_map_name
                  FROM " . $this->table_name . " s
                  JOIN seat_sections ss ON s.section_id = ss.id
                  JOIN seat_maps sm ON ss.seat_map_id = sm.id
                  JOIN events e ON e.seat_map_id = sm.id
                  WHERE e.id = ? AND s.status = 'available'
                  ORDER BY ss.name, s.row_number, s.seat_number";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $event_id);
        $stmt->execute();
        return $stmt;
    }

    // Reserve seats
    public function reserveSeats($seat_ids, $user_id) {
        $this->conn->beginTransaction();
        
        try {
            $placeholders = str_repeat('?,', count($seat_ids) - 1) . '?';
            $query = "UPDATE " . $this->table_name . " 
                      SET status = 'reserved' 
                      WHERE id IN ($placeholders) AND status = 'available'";
            
            $stmt = $this->conn->prepare($query);
            $stmt->execute($seat_ids);
            
            if($stmt->rowCount() == count($seat_ids)) {
                $this->conn->commit();
                return true;
            } else {
                $this->conn->rollback();
                return false;
            }
        } catch(Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Occupy seats (final purchase)
    public function occupySeats($seat_ids, $user_id) {
        $this->conn->beginTransaction();
        
        try {
            $placeholders = str_repeat('?,', count($seat_ids) - 1) . '?';
            $query = "UPDATE " . $this->table_name . " 
                      SET status = 'sold' 
                      WHERE id IN ($placeholders) AND status IN ('available', 'reserved')";
            
            $stmt = $this->conn->prepare($query);
            $stmt->execute($seat_ids);
            
            if($stmt->rowCount() == count($seat_ids)) {
                $this->conn->commit();
                return true;
            } else {
                $this->conn->rollback();
                return false;
            }
        } catch(Exception $e) {
            $this->conn->rollback();
            return false;
        }
    }

    // Create seat
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET section_id=:section_id, seat_number=:seat_number,
                      row_number=:row_number, status=:status,
                      position_x=:position_x, position_y=:position_y";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->seat_number = htmlspecialchars(strip_tags($this->seat_number));
        $this->row_number = htmlspecialchars(strip_tags($this->row_number));
        $this->status = htmlspecialchars(strip_tags($this->status));

        // Bind values
        $stmt->bindParam(":section_id", $this->section_id);
        $stmt->bindParam(":seat_number", $this->seat_number);
        $stmt->bindParam(":row_number", $this->row_number);
        $stmt->bindParam(":status", $this->status);
        $stmt->bindParam(":position_x", $this->position_x);
        $stmt->bindParam(":position_y", $this->position_y);

        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }
}
?>

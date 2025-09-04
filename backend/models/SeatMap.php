<?php
class SeatMap {
    private $conn;
    private $table_name = "seat_maps";

    public $id;
    public $name;
    public $venue_name;
    public $total_capacity;
    public $map_data;
    public $template_id;
    public $created_by;
    public $created_at;
    public $updated_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all seat maps
    public function read() {
        $query = "SELECT 
                    sm.id, sm.name, sm.venue_name, sm.total_capacity,
                    sm.map_data, sm.template_id, sm.created_by,
                    sm.created_at, sm.updated_at,
                    CONCAT(u.first_name, ' ', u.last_name) as creator_name,
                    smt.name as template_name
                  FROM " . $this->table_name . " sm
                  LEFT JOIN users u ON sm.created_by = u.id
                  LEFT JOIN seat_map_templates smt ON sm.template_id = smt.id
                  ORDER BY sm.created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt;
    }

    // Get single seat map
    public function read_single() {
        $query = "SELECT 
                    sm.id, sm.name, sm.venue_name, sm.total_capacity,
                    sm.map_data, sm.template_id, sm.created_by,
                    sm.created_at, sm.updated_at,
                    CONCAT(u.first_name, ' ', u.last_name) as creator_name,
                    smt.name as template_name
                  FROM " . $this->table_name . " sm
                  LEFT JOIN users u ON sm.created_by = u.id
                  LEFT JOIN seat_map_templates smt ON sm.template_id = smt.id
                  WHERE sm.id = ? LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->name = $row['name'];
            $this->venue_name = $row['venue_name'];
            $this->total_capacity = $row['total_capacity'];
            $this->map_data = $row['map_data'];
            $this->template_id = $row['template_id'];
            $this->created_by = $row['created_by'];
            $this->created_at = $row['created_at'];
            $this->updated_at = $row['updated_at'];
            return $row;
        }
        return false;
    }

    // Create seat map
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET name=:name, venue_name=:venue_name, 
                      total_capacity=:total_capacity, map_data=:map_data,
                      template_id=:template_id, created_by=:created_by";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->venue_name = htmlspecialchars(strip_tags($this->venue_name));
        $this->map_data = json_encode($this->map_data);

        // Bind values
        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":venue_name", $this->venue_name);
        $stmt->bindParam(":total_capacity", $this->total_capacity);
        $stmt->bindParam(":map_data", $this->map_data);
        $stmt->bindParam(":template_id", $this->template_id);
        $stmt->bindParam(":created_by", $this->created_by);

        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }

    // Update seat map
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET name=:name, venue_name=:venue_name,
                      total_capacity=:total_capacity, map_data=:map_data,
                      template_id=:template_id, updated_at=CURRENT_TIMESTAMP
                  WHERE id=:id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->name = htmlspecialchars(strip_tags($this->name));
        $this->venue_name = htmlspecialchars(strip_tags($this->venue_name));
        $this->map_data = json_encode($this->map_data);

        // Bind values
        $stmt->bindParam(":name", $this->name);
        $stmt->bindParam(":venue_name", $this->venue_name);
        $stmt->bindParam(":total_capacity", $this->total_capacity);
        $stmt->bindParam(":map_data", $this->map_data);
        $stmt->bindParam(":template_id", $this->template_id);
        $stmt->bindParam(":id", $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Delete seat map
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }
}
?>

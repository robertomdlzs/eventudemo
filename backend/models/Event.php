<?php
class Event {
    private $conn;
    private $table_name = "events";

    public $id;
    public $title;
    public $slug;
    public $description;
    public $long_description;
    public $date;
    public $time;
    public $venue;
    public $location;
    public $category_id;
    public $organizer_id;
    public $total_capacity;
    public $price;
    public $status;
    public $sales_start_date;
    public $sales_end_date;
    public $youtube_url;
    public $image_url;
    public $featured;
    public $seat_map_id;
    public $created_at;
    public $updated_at;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Get all events with category and organizer info
    public function read() {
        $query = "SELECT 
                    e.id, e.title, e.slug, e.description, e.long_description,
                    e.date, e.time, e.venue, e.location, e.total_capacity,
                    e.price, e.status, e.sales_start_date, e.sales_end_date,
                    e.youtube_url, e.image_url, e.featured, e.seat_map_id,
                    e.created_at, e.updated_at,
                    c.name as category_name, c.slug as category_slug,
                    CONCAT(u.first_name, ' ', u.last_name) as organizer_name,
                    COALESCE(SUM(tt.sold), 0) as tickets_sold,
                    COALESCE(SUM(s.total_amount), 0) as revenue,
                    COUNT(DISTINCT s.id) as total_sales
                  FROM " . $this->table_name . " e
                  LEFT JOIN categories c ON e.category_id = c.id
                  LEFT JOIN users u ON e.organizer_id = u.id
                  LEFT JOIN ticket_types tt ON e.id = tt.event_id
                  LEFT JOIN sales s ON e.id = s.event_id AND s.status = 'completed'
                  GROUP BY e.id
                  ORDER BY e.created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt;
    }

    // Get events by organizer
    public function readByOrganizer($organizer_id) {
        $query = "SELECT 
                    e.id, e.title, e.slug, e.description, e.long_description,
                    e.date, e.time, e.venue, e.location, e.total_capacity,
                    e.price, e.status, e.sales_start_date, e.sales_end_date,
                    e.youtube_url, e.image_url, e.featured, e.seat_map_id,
                    e.created_at, e.updated_at,
                    c.name as category_name, c.slug as category_slug,
                    COALESCE(SUM(tt.sold), 0) as tickets_sold,
                    COALESCE(SUM(s.total_amount), 0) as revenue,
                    COUNT(DISTINCT s.id) as total_sales
                  FROM " . $this->table_name . " e
                  LEFT JOIN categories c ON e.category_id = c.id
                  LEFT JOIN ticket_types tt ON e.id = tt.event_id
                  LEFT JOIN sales s ON e.id = s.event_id AND s.status = 'completed'
                  WHERE e.organizer_id = ?
                  GROUP BY e.id
                  ORDER BY e.created_at DESC";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $organizer_id);
        $stmt->execute();
        return $stmt;
    }

    // Get single event
    public function read_single() {
        $query = "SELECT 
                    e.id, e.title, e.slug, e.description, e.long_description,
                    e.date, e.time, e.venue, e.location, e.total_capacity,
                    e.price, e.status, e.sales_start_date, e.sales_end_date,
                    e.youtube_url, e.image_url, e.featured, e.seat_map_id,
                    e.created_at, e.updated_at, e.category_id, e.organizer_id,
                    c.name as category_name, c.slug as category_slug,
                    CONCAT(u.first_name, ' ', u.last_name) as organizer_name,
                    COALESCE(SUM(tt.sold), 0) as tickets_sold,
                    COALESCE(SUM(s.total_amount), 0) as revenue
                  FROM " . $this->table_name . " e
                  LEFT JOIN categories c ON e.category_id = c.id
                  LEFT JOIN users u ON e.organizer_id = u.id
                  LEFT JOIN ticket_types tt ON e.id = tt.event_id
                  LEFT JOIN sales s ON e.id = s.event_id AND s.status = 'completed'
                  WHERE e.id = ?
                  GROUP BY e.id
                  LIMIT 0,1";

        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);
        $stmt->execute();

        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if($row) {
            $this->title = $row['title'];
            $this->slug = $row['slug'];
            $this->description = $row['description'];
            $this->long_description = $row['long_description'];
            $this->date = $row['date'];
            $this->time = $row['time'];
            $this->venue = $row['venue'];
            $this->location = $row['location'];
            $this->category_id = $row['category_id'];
            $this->organizer_id = $row['organizer_id'];
            $this->total_capacity = $row['total_capacity'];
            $this->price = $row['price'];
            $this->status = $row['status'];
            $this->sales_start_date = $row['sales_start_date'];
            $this->sales_end_date = $row['sales_end_date'];
            $this->youtube_url = $row['youtube_url'];
            $this->image_url = $row['image_url'];
            $this->featured = $row['featured'];
            $this->seat_map_id = $row['seat_map_id'];
            $this->created_at = $row['created_at'];
            $this->updated_at = $row['updated_at'];
            return $row;
        }
        return false;
    }

    // Create event
    public function create() {
        $query = "INSERT INTO " . $this->table_name . "
                  SET title=:title, slug=:slug, description=:description,
                      long_description=:long_description, date=:date, time=:time,
                      venue=:venue, location=:location, category_id=:category_id,
                      organizer_id=:organizer_id, total_capacity=:total_capacity,
                      price=:price, status=:status, sales_start_date=:sales_start_date,
                      youtube_url=:youtube_url, image_url=:image_url, featured=:featured";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->title = htmlspecialchars(strip_tags($this->title));
        $this->slug = $this->generateSlug($this->title);
        $this->description = htmlspecialchars(strip_tags($this->description));
        $this->long_description = htmlspecialchars(strip_tags($this->long_description));
        $this->venue = htmlspecialchars(strip_tags($this->venue));
        $this->location = htmlspecialchars(strip_tags($this->location));
        $this->youtube_url = htmlspecialchars(strip_tags($this->youtube_url));
        $this->image_url = htmlspecialchars(strip_tags($this->image_url));

        // Bind values
        $stmt->bindParam(":title", $this->title);
        $stmt->bindParam(":slug", $this->slug);
        $stmt->bindParam(":description", $this->description);
        $stmt->bindParam(":long_description", $this->long_description);
        $stmt->bindParam(":date", $this->date);
        $stmt->bindParam(":time", $this->time);
        $stmt->bindParam(":venue", $this->venue);
        $stmt->bindParam(":location", $this->location);
        $stmt->bindParam(":category_id", $this->category_id);
        $stmt->bindParam(":organizer_id", $this->organizer_id);
        $stmt->bindParam(":total_capacity", $this->total_capacity);
        $stmt->bindParam(":price", $this->price);
        $stmt->bindParam(":status", $this->status);
        $stmt->bindParam(":sales_start_date", $this->sales_start_date);
        $stmt->bindParam(":youtube_url", $this->youtube_url);
        $stmt->bindParam(":image_url", $this->image_url);
        $stmt->bindParam(":featured", $this->featured);

        if($stmt->execute()) {
            $this->id = $this->conn->lastInsertId();
            return true;
        }
        return false;
    }

    // Update event
    public function update() {
        $query = "UPDATE " . $this->table_name . "
                  SET title=:title, slug=:slug, description=:description,
                      long_description=:long_description, date=:date, time=:time,
                      venue=:venue, location=:location, category_id=:category_id,
                      total_capacity=:total_capacity, price=:price, status=:status,
                      sales_start_date=:sales_start_date, youtube_url=:youtube_url,
                      image_url=:image_url, featured=:featured,
                      updated_at=CURRENT_TIMESTAMP
                  WHERE id=:id";

        $stmt = $this->conn->prepare($query);

        // Sanitize
        $this->title = htmlspecialchars(strip_tags($this->title));
        $this->slug = $this->generateSlug($this->title);
        $this->description = htmlspecialchars(strip_tags($this->description));
        $this->long_description = htmlspecialchars(strip_tags($this->long_description));
        $this->venue = htmlspecialchars(strip_tags($this->venue));
        $this->location = htmlspecialchars(strip_tags($this->location));
        $this->youtube_url = htmlspecialchars(strip_tags($this->youtube_url));
        $this->image_url = htmlspecialchars(strip_tags($this->image_url));

        // Bind values
        $stmt->bindParam(":title", $this->title);
        $stmt->bindParam(":slug", $this->slug);
        $stmt->bindParam(":description", $this->description);
        $stmt->bindParam(":long_description", $this->long_description);
        $stmt->bindParam(":date", $this->date);
        $stmt->bindParam(":time", $this->time);
        $stmt->bindParam(":venue", $this->venue);
        $stmt->bindParam(":location", $this->location);
        $stmt->bindParam(":category_id", $this->category_id);
        $stmt->bindParam(":total_capacity", $this->total_capacity);
        $stmt->bindParam(":price", $this->price);
        $stmt->bindParam(":status", $this->status);
        $stmt->bindParam(":sales_start_date", $this->sales_start_date);
        $stmt->bindParam(":youtube_url", $this->youtube_url);
        $stmt->bindParam(":image_url", $this->image_url);
        $stmt->bindParam(":featured", $this->featured);
        $stmt->bindParam(":id", $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Delete event
    public function delete() {
        $query = "DELETE FROM " . $this->table_name . " WHERE id = ?";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $this->id);

        if($stmt->execute()) {
            return true;
        }
        return false;
    }

    // Generate slug from title
    private function generateSlug($title) {
        $slug = strtolower($title);
        $slug = preg_replace('/[^a-z0-9\s-]/', '', $slug);
        $slug = preg_replace('/[\s-]+/', '-', $slug);
        $slug = trim($slug, '-');
        
        // Check if slug exists and make it unique
        $original_slug = $slug;
        $counter = 1;
        while($this->slugExists($slug)) {
            $slug = $original_slug . '-' . $counter;
            $counter++;
        }
        
        return $slug;
    }

    // Check if slug exists
    private function slugExists($slug) {
        $query = "SELECT id FROM " . $this->table_name . " WHERE slug = ?";
        if(isset($this->id)) {
            $query .= " AND id != ?";
        }
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $slug);
        if(isset($this->id)) {
            $stmt->bindParam(2, $this->id);
        }
        $stmt->execute();

        return $stmt->rowCount() > 0;
    }

    // Get featured events
    public function getFeatured() {
        $query = "SELECT 
                    e.id, e.title, e.slug, e.description, e.date, e.time,
                    e.venue, e.location, e.price, e.image_url,
                    c.name as category_name, c.slug as category_slug,
                    COALESCE(SUM(tt.sold), 0) as tickets_sold
                  FROM " . $this->table_name . " e
                  LEFT JOIN categories c ON e.category_id = c.id
                  LEFT JOIN ticket_types tt ON e.id = tt.event_id
                  WHERE e.featured = 1 AND e.status = 'published'
                  GROUP BY e.id
                  ORDER BY e.date ASC
                  LIMIT 6";

        $stmt = $this->conn->prepare($query);
        $stmt->execute();
        return $stmt;
    }

    // Search events
    public function search($search_term) {
        $query = "SELECT 
                    e.id, e.title, e.slug, e.description, e.date, e.time,
                    e.venue, e.location, e.price, e.image_url,
                    c.name as category_name, c.slug as category_slug
                  FROM " . $this->table_name . " e
                  LEFT JOIN categories c ON e.category_id = c.id
                  WHERE e.status = 'published' AND (
                    e.title LIKE ? OR 
                    e.description LIKE ? OR 
                    e.venue LIKE ? OR 
                    e.location LIKE ? OR
                    c.name LIKE ?
                  )
                  ORDER BY e.date ASC";

        $search_term = "%{$search_term}%";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(1, $search_term);
        $stmt->bindParam(2, $search_term);
        $stmt->bindParam(3, $search_term);
        $stmt->bindParam(4, $search_term);
        $stmt->bindParam(5, $search_term);
        $stmt->execute();
        return $stmt;
    }
}
?>

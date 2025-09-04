-- Create database
CREATE DATABASE IF NOT EXISTS eventu_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eventu_db;

-- Users table
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'organizer', 'user') DEFAULT 'user',
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    is_2fa_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255) NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
);

-- Categories table
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50),
    color VARCHAR(7) DEFAULT '#3B82F6',
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_slug (slug),
    INDEX idx_status (status)
);

-- Seat map templates
CREATE TABLE seat_map_templates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    template_data JSON NOT NULL,
    thumbnail_url VARCHAR(500),
    is_public BOOLEAN DEFAULT TRUE,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Seat maps
CREATE TABLE seat_maps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    venue_name VARCHAR(200),
    total_capacity INT DEFAULT 0,
    map_data JSON NOT NULL,
    template_id INT NULL,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (template_id) REFERENCES seat_map_templates(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Events table
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    long_description LONGTEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    category_id INT,
    organizer_id INT NOT NULL,
    total_capacity INT DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('draft', 'published', 'cancelled', 'completed') DEFAULT 'draft',
    sales_start_date TIMESTAMP NULL,
    sales_end_date TIMESTAMP NULL,
    youtube_url VARCHAR(500),
    image_url VARCHAR(500),
    featured BOOLEAN DEFAULT FALSE,
    seat_map_id INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_map_id) REFERENCES seat_maps(id) ON DELETE SET NULL,
    INDEX idx_slug (slug),
    INDEX idx_date (date),
    INDEX idx_status (status),
    INDEX idx_featured (featured),
    INDEX idx_organizer (organizer_id),
    INDEX idx_category (category_id)
);

-- Ticket types
CREATE TABLE ticket_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    sold INT DEFAULT 0,
    max_per_order INT DEFAULT 10,
    sale_start TIMESTAMP NULL,
    sale_end TIMESTAMP NULL,
    status ENUM('active', 'inactive', 'sold_out') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_event (event_id),
    INDEX idx_status (status)
);

-- Sales table
CREATE TABLE sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    ticket_type_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'completed', 'cancelled', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_reference VARCHAR(255),
    buyer_name VARCHAR(255) NOT NULL,
    buyer_email VARCHAR(255) NOT NULL,
    buyer_phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_type_id) REFERENCES ticket_types(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_event (event_id),
    INDEX idx_status (status),
    INDEX idx_created (created_at)
);

-- Individual tickets
CREATE TABLE tickets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    ticket_code VARCHAR(50) UNIQUE NOT NULL,
    qr_code TEXT,
    seat_info JSON NULL,
    status ENUM('valid', 'used', 'cancelled') DEFAULT 'valid',
    used_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
    INDEX idx_code (ticket_code),
    INDEX idx_sale (sale_id),
    INDEX idx_status (status)
);

-- Seat sections (for seat maps)
CREATE TABLE seat_sections (
    id INT AUTO_INCREMENT PRIMARY KEY,
    seat_map_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    section_type ENUM('seating', 'standing', 'vip', 'disabled') DEFAULT 'seating',
    capacity INT DEFAULT 0,
    price_modifier DECIMAL(5,2) DEFAULT 1.00,
    color VARCHAR(7) DEFAULT '#3B82F6',
    position_data JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (seat_map_id) REFERENCES seat_maps(id) ON DELETE CASCADE,
    INDEX idx_seat_map (seat_map_id)
);

-- Individual seats
CREATE TABLE seats (
    id INT AUTO_INCREMENT PRIMARY KEY,
    section_id INT NOT NULL,
    seat_number VARCHAR(10) NOT NULL,
    row_number VARCHAR(10),
    status ENUM('available', 'reserved', 'sold', 'blocked') DEFAULT 'available',
    position_x INT DEFAULT 0,
    position_y INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (section_id) REFERENCES seat_sections(id) ON DELETE CASCADE,
    INDEX idx_section (section_id),
    INDEX idx_status (status),
    UNIQUE KEY unique_seat_per_section (section_id, seat_number)
);

-- Event additional data (for flexible metadata)
CREATE TABLE event_additional_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    data_key VARCHAR(100) NOT NULL,
    data_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_event_key (event_id, data_key)
);

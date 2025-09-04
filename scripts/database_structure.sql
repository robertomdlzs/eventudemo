-- =====================================================
-- SCRIPT DE ESTRUCTURA DE BASE DE DATOS - EVENTU
-- =====================================================
-- Este script crea la estructura completa de la base de datos
-- para la plataforma de eventos Eventu
-- =====================================================

-- Crear la base de datos si no existe
CREATE DATABASE IF NOT EXISTS eventu_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE eventu_db;

-- =====================================================
-- TABLA DE USUARIOS
-- =====================================================
CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role ENUM('user', 'organizer', 'admin') DEFAULT 'user',
    is_active BOOLEAN DEFAULT TRUE,
    email_verified BOOLEAN DEFAULT FALSE,
    two_factor_enabled BOOLEAN DEFAULT FALSE,
    two_factor_secret VARCHAR(255),
    profile_picture_url TEXT,
    date_of_birth DATE,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    preferences JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL
);

-- =====================================================
-- TABLA DE EVENTOS
-- =====================================================
CREATE TABLE events (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    organizer_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    slug VARCHAR(255) UNIQUE NOT NULL,
    category VARCHAR(100) NOT NULL,
    subcategory VARCHAR(100),
    event_type ENUM('concert', 'sports', 'theater', 'conference', 'workshop', 'exhibition', 'other') NOT NULL,
    status ENUM('draft', 'published', 'cancelled', 'completed') DEFAULT 'draft',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP NOT NULL,
    timezone VARCHAR(50) DEFAULT 'UTC',
    venue_name VARCHAR(255) NOT NULL,
    venue_address TEXT NOT NULL,
    venue_city VARCHAR(100) NOT NULL,
    venue_state VARCHAR(100) NOT NULL,
    venue_country VARCHAR(100) NOT NULL,
    venue_postal_code VARCHAR(20) NOT NULL,
    venue_capacity INT NOT NULL,
    venue_type ENUM('indoor', 'outdoor', 'hybrid') DEFAULT 'indoor',
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    featured BOOLEAN DEFAULT FALSE,
    max_tickets_per_user INT DEFAULT 10,
    allow_waitlist BOOLEAN DEFAULT TRUE,
    waitlist_capacity INT DEFAULT 100,
    refund_policy TEXT,
    terms_conditions TEXT,
    seo_title VARCHAR(255),
    seo_description TEXT,
    seo_keywords TEXT,
    social_media_links JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    published_at TIMESTAMP NULL,
    deleted_at TIMESTAMP NULL,
    
    FOREIGN KEY (organizer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_events_status_date (status, start_date),
    INDEX idx_events_category (category),
    INDEX idx_events_organizer (organizer_id),
    INDEX idx_events_venue_location (venue_city, venue_state, venue_country),
    INDEX idx_events_featured (featured),
    INDEX idx_events_slug (slug)
);

-- =====================================================
-- TABLA DE SECCIONES DE MAPA DE ASIENTOS
-- =====================================================
CREATE TABLE seat_map_sections (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    type ENUM('seats', 'boxes', 'tables', 'general', 'vip', 'accessible') NOT NULL,
    x_position INT NOT NULL,
    y_position INT NOT NULL,
    width INT NOT NULL,
    height INT NOT NULL,
    capacity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    color VARCHAR(7) DEFAULT '#000000',
    rows_count INT NOT NULL,
    seats_per_row INT NOT NULL,
    description TEXT,
    category ENUM('economy', 'business', 'first', 'vip') DEFAULT 'economy',
    has_wheelchair_access BOOLEAN DEFAULT FALSE,
    is_premium BOOLEAN DEFAULT FALSE,
    amenities JSON,
    pricing_tiers JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_sections_event (event_id),
    INDEX idx_sections_type (type),
    INDEX idx_sections_price (price)
);

-- =====================================================
-- TABLA DE ASIENTOS
-- =====================================================
CREATE TABLE seats (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    section_id VARCHAR(36) NOT NULL,
    row_letter VARCHAR(10) NOT NULL,
    seat_number INT NOT NULL,
    x_position INT NOT NULL,
    y_position INT NOT NULL,
    status ENUM('available', 'selected', 'occupied', 'reserved', 'blocked') DEFAULT 'available',
    price DECIMAL(10, 2) NOT NULL,
    type ENUM('regular', 'vip', 'accessible', 'premium') DEFAULT 'regular',
    is_wheelchair_accessible BOOLEAN DEFAULT FALSE,
    has_extra_legroom BOOLEAN DEFAULT FALSE,
    is_aisle_seat BOOLEAN DEFAULT FALSE,
    is_window_seat BOOLEAN DEFAULT FALSE,
    category ENUM('economy', 'business', 'first') DEFAULT 'economy',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (section_id) REFERENCES seat_map_sections(id) ON DELETE CASCADE,
    UNIQUE KEY unique_seat (section_id, row_letter, seat_number),
    INDEX idx_seats_section (section_id),
    INDEX idx_seats_status (status),
    INDEX idx_seats_type (type),
    INDEX idx_seats_price (price)
);

-- =====================================================
-- TABLA DE TICKETS FÍSICOS
-- =====================================================
CREATE TABLE physical_tickets (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    seat_id VARCHAR(36),
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    qr_code TEXT NOT NULL,
    status ENUM('reserved', 'paid', 'issued', 'cancelled', 'refunded') DEFAULT 'reserved',
    price DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    final_price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    issue_date TIMESTAMP NULL,
    expiry_date TIMESTAMP NULL,
    refund_date TIMESTAMP NULL,
    refund_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE SET NULL,
    INDEX idx_tickets_event (event_id),
    INDEX idx_tickets_user (user_id),
    INDEX idx_tickets_status (status),
    INDEX idx_tickets_number (ticket_number),
    INDEX idx_tickets_qr (qr_code(100))
);

-- =====================================================
-- TABLA DE TICKETS DIGITALES
-- =====================================================
CREATE TABLE digital_tickets (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    qr_code TEXT NOT NULL,
    status ENUM('reserved', 'paid', 'issued', 'cancelled', 'refunded') DEFAULT 'reserved',
    price DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) DEFAULT 0.00,
    final_price DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    quantity INT DEFAULT 1,
    purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    issue_date TIMESTAMP NULL,
    expiry_date TIMESTAMP NULL,
    refund_date TIMESTAMP NULL,
    refund_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_digital_tickets_event (event_id),
    INDEX idx_digital_tickets_user (user_id),
    INDEX idx_digital_tickets_status (status),
    INDEX idx_digital_tickets_number (ticket_number)
);

-- =====================================================
-- TABLA DE RESERVAS DE ASIENTOS
-- =====================================================
CREATE TABLE seat_reservations (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    seat_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    event_id VARCHAR(36) NOT NULL,
    status ENUM('active', 'expired', 'cancelled', 'converted') DEFAULT 'active',
    reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    converted_to_ticket_id VARCHAR(36) NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (seat_id) REFERENCES seats(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    UNIQUE KEY unique_active_reservation (seat_id, user_id, event_id),
    INDEX idx_reservations_seat (seat_id),
    INDEX idx_reservations_user (user_id),
    INDEX idx_reservations_status (status),
    INDEX idx_reservations_expires (expires_at)
);

-- =====================================================
-- TABLA DE REGLAS DE PRECIOS DINÁMICOS
-- =====================================================
CREATE TABLE pricing_rules (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    type ENUM('time-based', 'demand-based', 'hybrid') NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    conditions JSON NOT NULL,
    price_adjustment JSON NOT NULL,
    applies_to JSON,
    priority INT DEFAULT 1,
    confidence DECIMAL(3, 2) DEFAULT 1.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_applied TIMESTAMP NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_pricing_rules_event (event_id),
    INDEX idx_pricing_rules_active (is_active),
    INDEX idx_pricing_rules_priority (priority),
    INDEX idx_pricing_rules_type (type)
);

-- =====================================================
-- TABLA DE CONDICIONES DE MERCADO
-- =====================================================
CREATE TABLE market_conditions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    event_id VARCHAR(36) NOT NULL,
    current_demand DECIMAL(5, 2) NOT NULL,
    time_to_event INT NOT NULL, -- en horas
    sales_velocity DECIMAL(10, 2) NOT NULL,
    competitor_prices JSON,
    seasonality DECIMAL(3, 2) NOT NULL,
    event_popularity DECIMAL(3, 2) NOT NULL,
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_market_conditions_event (event_id),
    INDEX idx_market_conditions_time (time_to_event),
    INDEX idx_market_conditions_demand (current_demand)
);

-- =====================================================
-- TABLA DE ARCHIVOS MULTIMEDIA
-- =====================================================
CREATE TABLE media_files (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    type ENUM('image', 'video', 'audio', 'document') NOT NULL,
    size BIGINT NOT NULL,
    url TEXT NOT NULL,
    alt_text TEXT,
    description TEXT,
    tags JSON,
    folder_id VARCHAR(36) NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP NULL,
    usage_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_media_files_type (type),
    INDEX idx_media_files_folder (folder_id),
    INDEX idx_media_files_tags ((CAST(tags AS CHAR(100)))),
    INDEX idx_media_files_usage (usage_count)
);

-- =====================================================
-- TABLA DE CARPETAS DE MEDIOS
-- =====================================================
CREATE TABLE media_folders (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(255) NOT NULL,
    parent_folder_id VARCHAR(36) NULL,
    path TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (parent_folder_id) REFERENCES media_folders(id) ON DELETE CASCADE,
    INDEX idx_media_folders_parent (parent_folder_id),
    INDEX idx_media_folders_path (path(100))
);

-- =====================================================
-- TABLA DE TRANSACCIONES DE PAGO
-- =====================================================
CREATE TABLE payment_transactions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    event_id VARCHAR(36) NOT NULL,
    ticket_ids JSON NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    payment_method ENUM('stripe', 'paypal', 'bank_transfer', 'crypto') NOT NULL,
    gateway_transaction_id VARCHAR(255),
    status ENUM('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
    gateway_response JSON,
    billing_address JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    INDEX idx_payments_user (user_id),
    INDEX idx_payments_event (event_id),
    INDEX idx_payments_status (status),
    INDEX idx_payments_method (payment_method),
    INDEX idx_payments_gateway_id (gateway_transaction_id)
);

-- =====================================================
-- TABLA DE CÓDIGOS DE DESCUENTO
-- =====================================================
CREATE TABLE discount_codes (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    code VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    discount_type ENUM('percentage', 'fixed', 'free_shipping') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_purchase DECIMAL(10, 2) DEFAULT 0.00,
    maximum_discount DECIMAL(10, 2) NULL,
    usage_limit INT NULL,
    used_count INT DEFAULT 0,
    valid_from TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valid_until TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE,
    applicable_events JSON,
    applicable_users JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_discount_codes_code (code),
    INDEX idx_discount_codes_active (is_active),
    INDEX idx_discount_codes_validity (valid_from, valid_until)
);

-- =====================================================
-- TABLA DE NOTIFICACIONES
-- =====================================================
CREATE TABLE notifications (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type ENUM('info', 'success', 'warning', 'error') DEFAULT 'info',
    is_read BOOLEAN DEFAULT FALSE,
    action_url TEXT,
    metadata JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_read (is_read),
    INDEX idx_notifications_type (type),
    INDEX idx_notifications_created (created_at)
);

-- =====================================================
-- TABLA DE LOGS DE AUDITORÍA
-- =====================================================
CREATE TABLE audit_logs (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id VARCHAR(36) NULL,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_audit_logs_user (user_id),
    INDEX idx_audit_logs_action (action),
    INDEX idx_audit_logs_entity (entity_type, entity_id),
    INDEX idx_audit_logs_created (created_at)
);

-- =====================================================
-- TABLA DE SESIONES WEB
-- =====================================================
CREATE TABLE web_sessions (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    user_id VARCHAR(36) NOT NULL,
    session_token VARCHAR(255) UNIQUE NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_sessions_user (user_id),
    INDEX idx_sessions_token (session_token),
    INDEX idx_sessions_active (is_active),
    INDEX idx_sessions_expires (expires_at)
);

-- =====================================================
-- TABLA DE CONFIGURACIONES DEL SISTEMA
-- =====================================================
CREATE TABLE system_configurations (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT NOT NULL,
    description TEXT,
    is_encrypted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_config_key (config_key)
);

-- =====================================================
-- ÍNDICES ADICIONALES PARA OPTIMIZACIÓN
-- =====================================================

-- Índices para búsquedas de eventos
CREATE INDEX idx_events_search ON events(title, description, venue_city, venue_state);
CREATE INDEX idx_events_dates ON events(start_date, end_date);

-- Índices para tickets
CREATE INDEX idx_tickets_event_user ON physical_tickets(event_id, user_id);
CREATE INDEX idx_tickets_event_status ON physical_tickets(event_id, status);

-- Índices para asientos
CREATE INDEX idx_seats_map_status ON seats(section_id, status);
CREATE INDEX idx_seats_position ON seats(x_position, y_position);

-- Índices para usuarios
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);

-- Índices para pagos
CREATE INDEX idx_payments_status_date ON payment_transactions(status, created_at);
CREATE INDEX idx_payments_user_date ON payment_transactions(user_id, created_at);

-- =====================================================
-- TRIGGERS PARA ACTUALIZACIÓN AUTOMÁTICA
-- =====================================================

DELIMITER //

-- Trigger para actualizar updated_at automáticamente
CREATE TRIGGER update_users_timestamp
    BEFORE UPDATE ON users
    FOR EACH ROW
    SET NEW.updated_at = CURRENT_TIMESTAMP;

CREATE TRIGGER update_events_timestamp
    BEFORE UPDATE ON events
    FOR EACH ROW
    SET NEW.updated_at = CURRENT_TIMESTAMP;

CREATE TRIGGER update_seats_timestamp
    BEFORE UPDATE ON seats
    FOR EACH ROW
    SET NEW.updated_at = CURRENT_TIMESTAMP;

CREATE TRIGGER update_tickets_timestamp
    BEFORE UPDATE ON physical_tickets
    FOR EACH ROW
    SET NEW.updated_at = CURRENT_TIMESTAMP;

-- Trigger para actualizar contador de uso de archivos multimedia
CREATE TRIGGER update_media_usage_count
    AFTER UPDATE ON media_files
    FOR EACH ROW
    IF NEW.last_used IS NOT NULL AND (OLD.last_used IS NULL OR NEW.last_used > OLD.last_used) THEN
        UPDATE media_files SET usage_count = usage_count + 1 WHERE id = NEW.id;
    END IF;

DELIMITER ;

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista de eventos activos con información del organizador
CREATE VIEW active_events AS
SELECT 
    e.*,
    CONCAT(u.first_name, ' ', u.last_name) as organizer_name,
    u.email as organizer_email
FROM events e
JOIN users u ON e.organizer_id = u.id
WHERE e.status = 'published' 
AND e.start_date > NOW()
AND e.deleted_at IS NULL;

-- Vista de tickets vendidos por evento
CREATE VIEW event_ticket_sales AS
SELECT 
    e.id as event_id,
    e.title as event_title,
    COUNT(pt.id) as tickets_sold,
    SUM(pt.final_price) as total_revenue,
    AVG(pt.final_price) as average_ticket_price
FROM events e
LEFT JOIN physical_tickets pt ON e.id = pt.event_id AND pt.status = 'issued'
WHERE e.deleted_at IS NULL
GROUP BY e.id, e.title;

-- Vista de asientos disponibles por evento
CREATE VIEW available_seats_by_event AS
SELECT 
    e.id as event_id,
    e.title as event_title,
    sms.name as section_name,
    COUNT(s.id) as total_seats,
    SUM(CASE WHEN s.status = 'available' THEN 1 ELSE 0 END) as available_seats,
    SUM(CASE WHEN s.status = 'occupied' THEN 1 ELSE 0 END) as occupied_seats
FROM events e
JOIN seat_map_sections sms ON e.id = sms.event_id
JOIN seats s ON sms.id = s.section_id
WHERE e.deleted_at IS NULL
GROUP BY e.id, e.title, sms.id, sms.name;

-- =====================================================
-- PROCEDIMIENTOS ALMACENADOS ÚTILES
-- =====================================================

DELIMITER //

-- Procedimiento para limpiar reservas expiradas
CREATE PROCEDURE CleanExpiredReservations()
BEGIN
    UPDATE seat_reservations 
    SET status = 'expired' 
    WHERE expires_at < NOW() AND status = 'active';
    
    UPDATE seats s
    JOIN seat_reservations sr ON s.id = sr.seat_id
    SET s.status = 'available'
    WHERE sr.status = 'expired';
END //

-- Procedimiento para obtener estadísticas de evento
CREATE PROCEDURE GetEventStats(IN event_id_param VARCHAR(36))
BEGIN
    SELECT 
        e.title,
        e.venue_name,
        e.start_date,
        COUNT(DISTINCT pt.id) as total_tickets_sold,
        SUM(pt.final_price) as total_revenue,
        COUNT(DISTINCT pt.user_id) as unique_buyers,
        e.venue_capacity,
        ROUND((COUNT(DISTINCT pt.id) / e.venue_capacity) * 100, 2) as occupancy_percentage
    FROM events e
    LEFT JOIN physical_tickets pt ON e.id = pt.event_id AND pt.status = 'issued'
    WHERE e.id = event_id_param
    GROUP BY e.id, e.title, e.venue_name, e.start_date, e.venue_capacity;
END //

DELIMITER ;

-- =====================================================
-- FIN DEL SCRIPT
-- =====================================================

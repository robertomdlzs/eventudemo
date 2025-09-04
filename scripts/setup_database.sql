-- Create database and user (run as postgres superuser)
-- CREATE DATABASE eventu_db;
-- CREATE USER eventu_user WITH PASSWORD 'your_secure_password';
-- GRANT ALL PRIVILEGES ON DATABASE eventu_db TO eventu_user;

-- Connect to eventu_db and run the following:

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create custom types
CREATE TYPE user_role AS ENUM ('user', 'organizer', 'admin');
CREATE TYPE event_status AS ENUM ('draft', 'published', 'cancelled', 'completed');
CREATE TYPE seat_status AS ENUM ('available', 'reserved', 'occupied', 'blocked');
CREATE TYPE seat_type AS ENUM ('regular', 'vip', 'premium', 'accessible');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    role user_role DEFAULT 'user',
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    icon VARCHAR(50) DEFAULT 'music',
    color VARCHAR(7) DEFAULT '#3B82F6',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events table
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    short_description VARCHAR(500),
    image_url VARCHAR(500),
    venue_name VARCHAR(255) NOT NULL,
    venue_address TEXT,
    venue_city VARCHAR(100) NOT NULL,
    venue_country VARCHAR(100) DEFAULT 'Colombia',
    start_date TIMESTAMP NOT NULL,
    end_date TIMESTAMP,
    min_price DECIMAL(10,2) NOT NULL,
    max_price DECIMAL(10,2),
    capacity INTEGER NOT NULL,
    tickets_sold INTEGER DEFAULT 0,
    category_id INTEGER REFERENCES categories(id),
    organizer_id INTEGER REFERENCES users(id),
    status event_status DEFAULT 'draft',
    featured BOOLEAN DEFAULT false,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seat maps table
CREATE TABLE seat_maps (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    layout_data JSONB,
    total_seats INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seats table
CREATE TABLE seats (
    id SERIAL PRIMARY KEY,
    seat_map_id INTEGER REFERENCES seat_maps(id) ON DELETE CASCADE,
    row_number INTEGER NOT NULL,
    seat_number INTEGER NOT NULL,
    section VARCHAR(50),
    price DECIMAL(10,2) NOT NULL,
    status seat_status DEFAULT 'available',
    seat_type seat_type DEFAULT 'regular',
    reserved_by INTEGER REFERENCES users(id),
    reserved_until TIMESTAMP,
    occupied_by INTEGER REFERENCES users(id),
    payment_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(seat_map_id, row_number, seat_number)
);

-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(255),
    status payment_status DEFAULT 'pending',
    processed_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add foreign key for payment_id in seats table
ALTER TABLE seats ADD CONSTRAINT fk_seats_payment 
    FOREIGN KEY (payment_id) REFERENCES payments(id);

-- Tickets table
CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    event_id INTEGER REFERENCES events(id),
    seat_id INTEGER REFERENCES seats(id),
    payment_id INTEGER REFERENCES payments(id),
    ticket_code VARCHAR(100) UNIQUE NOT NULL,
    qr_code TEXT,
    status VARCHAR(20) DEFAULT 'active',
    checked_in BOOLEAN DEFAULT false,
    checked_in_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_events_slug ON events(slug);
CREATE INDEX idx_events_category ON events(category_id);
CREATE INDEX idx_events_organizer ON events(organizer_id);
CREATE INDEX idx_events_status ON events(status);
CREATE INDEX idx_events_featured ON events(featured);
CREATE INDEX idx_events_start_date ON events(start_date);
CREATE INDEX idx_events_city ON events(venue_city);
CREATE INDEX idx_seats_status ON seats(status);
CREATE INDEX idx_seats_reserved_by ON seats(reserved_by);
CREATE INDEX idx_seats_occupied_by ON seats(occupied_by);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_tickets_user ON tickets(user_id);
CREATE INDEX idx_tickets_event ON tickets(event_id);
CREATE INDEX idx_tickets_code ON tickets(ticket_code);

-- Create GIN index for JSONB data
CREATE INDEX idx_seat_maps_layout ON seat_maps USING GIN (layout_data);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_seat_maps_updated_at BEFORE UPDATE ON seat_maps
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_seats_updated_at BEFORE UPDATE ON seats
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tickets_updated_at BEFORE UPDATE ON tickets
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample categories
INSERT INTO categories (name, slug, description, icon, color) VALUES
('Música', 'musica', 'Conciertos, festivales y eventos musicales', 'music', '#E11D48'),
('Teatro', 'teatro', 'Obras de teatro, musicales y espectáculos', 'drama', '#7C3AED'),
('Deportes', 'deportes', 'Eventos deportivos y competencias', 'trophy', '#059669'),
('Conferencias', 'conferencias', 'Conferencias, seminarios y eventos corporativos', 'presentation', '#DC2626'),
('Festivales', 'festivales', 'Festivales culturales y gastronómicos', 'calendar', '#D97706'),
('Familiar', 'familiar', 'Eventos para toda la familia', 'users', '#2563EB');

-- Insert sample admin user (password: admin123)
INSERT INTO users (email, password, first_name, last_name, role) VALUES
('admin@eventu.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAg9S6O', 'Admin', 'User', 'admin');

-- Insert sample organizer (password: organizer123)
INSERT INTO users (email, password, first_name, last_name, role) VALUES
('organizer@eventu.com', '$2a$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizador', 'Ejemplo', 'organizer');

-- Insert sample events
INSERT INTO events (
    title, slug, description, short_description, image_url,
    venue_name, venue_address, venue_city, venue_country,
    start_date, end_date, min_price, max_price, capacity,
    category_id, organizer_id, status, featured
) VALUES
(
    'Concierto de Rock Nacional',
    'concierto-rock-nacional',
    'Una noche épica de rock nacional con las mejores bandas del país. Disfruta de un espectáculo lleno de energía y música en vivo.',
    'Una noche épica de rock nacional con las mejores bandas del país',
    '/placeholder.svg?height=400&width=600&text=Rock+Nacional',
    'Estadio El Campín',
    'Carrera 30 # 57-60',
    'Bogotá',
    'Colombia',
    '2024-03-15 20:00:00',
    '2024-03-15 23:30:00',
    45000,
    85000,
    2000,
    1,
    2,
    'published',
    true
),
(
    'Festival de Jazz Internacional',
    'festival-jazz-internacional',
    'Festival internacional de jazz con artistas de renombre mundial. Tres días de música excepcional en un ambiente único.',
    'Festival internacional de jazz con artistas de renombre mundial',
    '/placeholder.svg?height=400&width=600&text=Jazz+Festival',
    'Teatro Mayor Julio Mario Santo Domingo',
    'Avenida Calle 170 # 67-51',
    'Bogotá',
    'Colombia',
    '2024-04-20 19:00:00',
    '2024-04-22 22:00:00',
    65000,
    120000,
    1200,
    1,
    2,
    'published',
    true
),
(
    'Obra de Teatro: Romeo y Julieta',
    'romeo-y-julieta',
    'La clásica obra de Shakespeare interpretada por el mejor elenco nacional. Una experiencia teatral inolvidable.',
    'La clásica obra de Shakespeare interpretada por el mejor elenco nacional',
    '/placeholder.svg?height=400&width=600&text=Romeo+y+Julieta',
    'Teatro Colón',
    'Calle 10 # 5-32',
    'Bogotá',
    'Colombia',
    '2024-03-25 20:00:00',
    '2024-03-25 22:30:00',
    35000,
    75000,
    800,
    2,
    2,
    'published',
    false
),
(
    'Partido de Fútbol: Nacional vs Millonarios',
    'nacional-vs-millonarios',
    'El clásico del fútbol colombiano. No te pierdas este emocionante encuentro entre dos de los equipos más importantes del país.',
    'El clásico del fútbol colombiano entre Nacional y Millonarios',
    '/placeholder.svg?height=400&width=600&text=Nacional+vs+Millonarios',
    'Estadio Atanasio Girardot',
    'Carrera 74 # 48-40',
    'Medellín',
    'Colombia',
    '2024-03-30 16:00:00',
    '2024-03-30 18:00:00',
    25000,
    150000,
    45000,
    3,
    2,
    'published',
    true
);

-- Insert sample seat maps and seats for the first event
INSERT INTO seat_maps (event_id, name, layout_data, total_seats) VALUES
(1, 'Planta Principal', '{"sections": [{"name": "VIP", "rows": 10, "seatsPerRow": 20}, {"name": "General", "rows": 20, "seatsPerRow": 25}]}', 700);

-- Insert sample seats for the seat map
DO $$
DECLARE
    seat_map_id INTEGER := 1;
    row_num INTEGER;
    seat_num INTEGER;
    current_price DECIMAL(10,2);
BEGIN
    -- VIP Section (rows 1-10, seats 1-20 each)
    FOR row_num IN 1..10 LOOP
        FOR seat_num IN 1..20 LOOP
            current_price := 85000; -- VIP price
            INSERT INTO seats (seat_map_id, row_number, seat_number, section, price, seat_type)
            VALUES (seat_map_id, row_num, seat_num, 'VIP', current_price, 'vip');
        END LOOP;
    END LOOP;
    
    -- General Section (rows 11-30, seats 1-25 each)
    FOR row_num IN 11..30 LOOP
        FOR seat_num IN 1..25 LOOP
            current_price := 45000; -- General price
            INSERT INTO seats (seat_map_id, row_number, seat_number, section, price, seat_type)
            VALUES (seat_map_id, row_num, seat_num, 'General', current_price, 'regular');
        END LOOP;
    END LOOP;
END $$;

-- Function to clean up expired reservations
CREATE OR REPLACE FUNCTION cleanup_expired_reservations()
RETURNS void AS $$
BEGIN
    UPDATE seats 
    SET status = 'available', 
        reserved_by = NULL, 
        reserved_until = NULL
    WHERE status = 'reserved' 
    AND reserved_until < NOW();
END;
$$ LANGUAGE plpgsql;

-- Create a scheduled job to clean up expired reservations (requires pg_cron extension)
-- SELECT cron.schedule('cleanup-reservations', '*/5 * * * *', 'SELECT cleanup_expired_reservations();');

COMMIT;

-- Base de datos SQLite para Eventu
-- Versión simplificada para desarrollo local

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin', 'organizer')),
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'suspended')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de eventos
CREATE TABLE IF NOT EXISTS events (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    slug TEXT UNIQUE NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue TEXT NOT NULL,
    location TEXT NOT NULL,
    category_id INTEGER,
    organizer_id INTEGER,
    total_capacity INTEGER DEFAULT 0,
    sold INTEGER DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0.00,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'cancelled')),
    featured BOOLEAN DEFAULT FALSE,
    image_url TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id),
    FOREIGN KEY (organizer_id) REFERENCES users(id)
);

-- Tabla de tipos de tickets
CREATE TABLE IF NOT EXISTS ticket_types (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    event_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    total_quantity INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    event_id INTEGER NOT NULL,
    ticket_type_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'cancelled')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (ticket_type_id) REFERENCES ticket_types(id)
);

-- Insertar datos de prueba
INSERT OR IGNORE INTO categories (id, name, description) VALUES 
(1, 'Conciertos', 'Eventos musicales y conciertos'),
(2, 'Deportes', 'Eventos deportivos'),
(3, 'Teatro', 'Obras de teatro y espectáculos'),
(4, 'Conferencias', 'Conferencias y seminarios'),
(5, 'Festivales', 'Festivales y eventos culturales');

INSERT OR IGNORE INTO users (id, email, password_hash, first_name, last_name, role, status) VALUES 
(1, 'admin@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'Sistema', 'admin', 'active'),
(2, 'organizer@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizador', 'Eventos', 'organizer', 'active'),
(3, 'user@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Usuario', 'Prueba', 'user', 'active');

INSERT OR IGNORE INTO events (id, title, slug, description, date, time, venue, location, category_id, organizer_id, total_capacity, sold, price, status, featured) VALUES 
(1, 'Concierto de Rock', 'concierto-rock-2025', 'Un increíble concierto de rock con las mejores bandas', '2025-02-15', '20:00:00', 'Estadio El Campín', 'Bogotá, Colombia', 1, 2, 50000, 0, 50000.00, 'active', TRUE),
(2, 'Partido de Fútbol', 'partido-futbol-2025', 'Clásico de fútbol colombiano', '2025-02-20', '15:00:00', 'Estadio Nemesio Camacho', 'Bogotá, Colombia', 2, 2, 40000, 0, 30000.00, 'active', TRUE),
(3, 'Obra de Teatro', 'obra-teatro-2025', 'Una hermosa obra de teatro clásico', '2025-02-25', '19:30:00', 'Teatro Colón', 'Bogotá, Colombia', 3, 2, 1000, 0, 25000.00, 'active', FALSE);

INSERT OR IGNORE INTO ticket_types (id, event_id, name, description, price, total_quantity, quantity) VALUES 
(1, 1, 'General', 'Entrada general al concierto', 50000.00, 40000, 40000),
(2, 1, 'VIP', 'Entrada VIP con beneficios especiales', 100000.00, 10000, 10000),
(3, 2, 'Norte', 'Tribuna Norte', 30000.00, 20000, 20000),
(4, 2, 'Sur', 'Tribuna Sur', 30000.00, 20000, 20000),
(5, 3, 'Palco', 'Palco principal', 25000.00, 500, 500),
(6, 3, 'General', 'Entrada general', 15000.00, 500, 500);




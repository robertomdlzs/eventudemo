-- =====================================================
-- EVENTU DATABASE SETUP FOR SUPABASE
-- =====================================================

-- Habilitar extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- TABLAS PRINCIPALES
-- =====================================================

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    status VARCHAR(50) DEFAULT 'active',
    phone VARCHAR(20),
    avatar_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de eventos
CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    category_id INTEGER REFERENCES categories(id),
    organizer_id INTEGER REFERENCES users(id),
    total_capacity INTEGER DEFAULT 0,
    sold INTEGER DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active',
    featured BOOLEAN DEFAULT false,
    image_url VARCHAR(500),
    video_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tipos de boletos
CREATE TABLE IF NOT EXISTS ticket_types (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    capacity INTEGER NOT NULL,
    sold INTEGER DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de ventas
CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id),
    user_id INTEGER REFERENCES users(id),
    ticket_type_id INTEGER REFERENCES ticket_types(id),
    quantity INTEGER NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    payment_status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de pagos
CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(id),
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50) DEFAULT 'pending',
    transaction_id VARCHAR(255),
    payment_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de boletos virtuales
CREATE TABLE IF NOT EXISTS virtual_tickets (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER REFERENCES sales(id),
    event_id INTEGER REFERENCES events(id),
    ticket_type_id INTEGER REFERENCES ticket_types(id),
    ticket_number VARCHAR(50) UNIQUE NOT NULL,
    qr_code TEXT,
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de check-in
CREATE TABLE IF NOT EXISTS check_in_records (
    id SERIAL PRIMARY KEY,
    event_id INTEGER REFERENCES events(id),
    sale_id INTEGER REFERENCES sales(id),
    ticket_number VARCHAR(50) NOT NULL,
    check_in_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    checked_by INTEGER REFERENCES users(id)
);

-- Tabla de medios
CREATE TABLE IF NOT EXISTS media_files (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de notificaciones
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) DEFAULT 'info',
    read BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- ÍNDICES PARA RENDIMIENTO
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_events_slug ON events(slug);
CREATE INDEX IF NOT EXISTS idx_events_date ON events(date);
CREATE INDEX IF NOT EXISTS idx_events_status ON events(status);
CREATE INDEX IF NOT EXISTS idx_events_featured ON events(featured);
CREATE INDEX IF NOT EXISTS idx_events_organizer ON events(organizer_id);
CREATE INDEX IF NOT EXISTS idx_events_category ON events(category_id);

CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);

CREATE INDEX IF NOT EXISTS idx_sales_user ON sales(user_id);
CREATE INDEX IF NOT EXISTS idx_sales_event ON sales(event_id);
CREATE INDEX IF NOT EXISTS idx_sales_status ON sales(status);

CREATE INDEX IF NOT EXISTS idx_ticket_types_event ON ticket_types(event_id);
CREATE INDEX IF NOT EXISTS idx_virtual_tickets_sale ON virtual_tickets(sale_id);
CREATE INDEX IF NOT EXISTS idx_virtual_tickets_number ON virtual_tickets(ticket_number);

-- =====================================================
-- TRIGGERS PARA UPDATED_AT
-- =====================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_events_updated_at BEFORE UPDATE ON events
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ticket_types_updated_at BEFORE UPDATE ON ticket_types
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sales_updated_at BEFORE UPDATE ON sales
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- DATOS DE PRUEBA
-- =====================================================

-- Insertar categorías
INSERT INTO categories (name, slug, description) VALUES
('Música', 'musica', 'Conciertos y eventos musicales'),
('Gastronomía', 'gastronomia', 'Festivales de comida y eventos culinarios'),
('Tecnología', 'tecnologia', 'Conferencias y eventos tecnológicos'),
('Deportes', 'deportes', 'Eventos deportivos y competencias'),
('Arte y Cultura', 'arte-cultura', 'Exposiciones y eventos culturales'),
('Educación', 'educacion', 'Seminarios y eventos educativos')
ON CONFLICT (slug) DO NOTHING;

-- Insertar usuarios
INSERT INTO users (email, password, first_name, last_name, role, status) VALUES
('admin@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'Principal', 'admin', 'active'),
('organizer@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizador', 'Eventos', 'organizer', 'active'),
('user@eventu.co', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Usuario', 'Demo', 'user', 'active')
ON CONFLICT (email) DO NOTHING;

-- Insertar eventos
INSERT INTO events (title, slug, description, date, time, venue, location, category_id, organizer_id, total_capacity, sold, price, featured, image_url) VALUES
('Concierto de Rock Nacional', 'concierto-rock-nacional-2024', 'Un increíble concierto de rock con las mejores bandas del país. Una noche llena de música, energía y diversión.', '2024-12-25', '20:00', 'Estadio El Campín', 'Bogotá, Colombia', 1, 2, 50000, 25000, 150000, true, '/images/rock-concert.jpg'),
('Festival de Comida Internacional', 'festival-comida-internacional-2024', 'Disfruta de la mejor gastronomía local e internacional. Chefs reconocidos y sabores únicos.', '2024-12-30', '12:00', 'Parque Simón Bolívar', 'Bogotá, Colombia', 2, 2, 10000, 5000, 50000, true, '/images/food-festival.jpg'),
('Conferencia de Tecnología 2025', 'conferencia-tecnologia-2025', 'Las últimas tendencias en tecnología y desarrollo. Innovación, IA y futuro digital.', '2025-01-15', '09:00', 'Centro de Convenciones', 'Medellín, Colombia', 3, 2, 2000, 800, 200000, false, '/images/tech-conference.jpg'),
('Maratón de Bogotá', 'maraton-bogota-2025', 'La carrera más importante de la capital. Participa en 5K, 10K o 21K.', '2025-02-15', '06:00', 'Parque Nacional', 'Bogotá, Colombia', 4, 2, 15000, 7500, 80000, true, '/images/marathon.jpg'),
('Exposición de Arte Moderno', 'exposicion-arte-moderno-2025', 'Obras de artistas contemporáneos colombianos e internacionales.', '2025-03-10', '10:00', 'Museo de Arte Moderno', 'Bogotá, Colombia', 5, 2, 5000, 2000, 25000, false, '/images/art-exhibition.jpg')
ON CONFLICT (slug) DO NOTHING;

-- Insertar tipos de boletos
INSERT INTO ticket_types (event_id, name, description, price, capacity, sold) VALUES
(1, 'General', 'Acceso general al concierto', 150000, 40000, 20000),
(1, 'VIP', 'Acceso VIP con beneficios especiales', 300000, 10000, 5000),
(2, 'Entrada General', 'Acceso a todas las zonas del festival', 50000, 8000, 4000),
(2, 'Premium', 'Acceso premium con degustaciones', 100000, 2000, 1000),
(3, 'Estudiante', 'Descuento para estudiantes', 150000, 1000, 400),
(3, 'Profesional', 'Entrada para profesionales', 200000, 1000, 400),
(4, '5K', 'Carrera de 5 kilómetros', 50000, 5000, 2500),
(4, '10K', 'Carrera de 10 kilómetros', 80000, 5000, 2500),
(4, '21K', 'Media maratón', 120000, 5000, 2500),
(5, 'Entrada General', 'Acceso a la exposición', 25000, 5000, 2000)
ON CONFLICT DO NOTHING;

-- =====================================================
-- CONFIGURACIÓN DE SEGURIDAD
-- =====================================================

-- Habilitar RLS (Row Level Security)
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE events ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE virtual_tickets ENABLE ROW LEVEL SECURITY;

-- Políticas básicas de seguridad
CREATE POLICY "Users can view their own data" ON users
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Events are viewable by everyone" ON events
    FOR SELECT USING (true);

CREATE POLICY "Sales are viewable by owner" ON sales
    FOR SELECT USING (auth.uid()::text = user_id::text);

-- =====================================================
-- FUNCIONES ÚTILES
-- =====================================================

-- Función para generar número de ticket único
CREATE OR REPLACE FUNCTION generate_ticket_number()
RETURNS TEXT AS $$
BEGIN
    RETURN 'TK-' || TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD') || '-' || LPAD(nextval('ticket_sequence')::text, 6, '0');
END;
$$ LANGUAGE plpgsql;

-- Secuencia para números de ticket
CREATE SEQUENCE IF NOT EXISTS ticket_sequence START 1;

-- =====================================================
-- VISTAS ÚTILES
-- =====================================================

-- Vista de eventos con información completa
CREATE OR REPLACE VIEW events_complete AS
SELECT 
    e.*,
    c.name as category_name,
    u.first_name || ' ' || u.last_name as organizer_name,
    (e.total_capacity - e.sold) as available_tickets,
    ROUND((e.sold::decimal / e.total_capacity * 100), 2) as sold_percentage
FROM events e
LEFT JOIN categories c ON e.category_id = c.id
LEFT JOIN users u ON e.organizer_id = u.id
WHERE e.status = 'active';

-- Vista de ventas con información completa
CREATE OR REPLACE VIEW sales_complete AS
SELECT 
    s.*,
    e.title as event_title,
    e.date as event_date,
    tt.name as ticket_type_name,
    u.first_name || ' ' || u.last_name as customer_name,
    u.email as customer_email
FROM sales s
LEFT JOIN events e ON s.event_id = e.id
LEFT JOIN ticket_types tt ON s.ticket_type_id = tt.id
LEFT JOIN users u ON s.user_id = u.id;

-- =====================================================
-- FINALIZACIÓN
-- =====================================================

-- Comentarios en las tablas
COMMENT ON TABLE users IS 'Usuarios del sistema (admin, organizadores, clientes)';
COMMENT ON TABLE events IS 'Eventos disponibles en la plataforma';
COMMENT ON TABLE ticket_types IS 'Tipos de boletos para cada evento';
COMMENT ON TABLE sales IS 'Ventas de boletos realizadas';
COMMENT ON TABLE payments IS 'Pagos asociados a las ventas';
COMMENT ON TABLE virtual_tickets IS 'Boletos virtuales generados';

-- Mensaje de éxito
DO $$
BEGIN
    RAISE NOTICE '✅ Base de datos Eventu configurada exitosamente en Supabase!';
    RAISE NOTICE '📊 Tablas creadas: users, events, categories, ticket_types, sales, payments, virtual_tickets, check_in_records, media_files, notifications';
    RAISE NOTICE '🔐 Seguridad: RLS habilitado, políticas configuradas';
    RAISE NOTICE '📈 Datos de prueba: 3 usuarios, 5 eventos, 10 tipos de boletos';
    RAISE NOTICE '🚀 ¡Listo para usar!';
END $$;

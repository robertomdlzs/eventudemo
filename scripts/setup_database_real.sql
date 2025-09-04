-- Script para crear la estructura de base de datos real de Eventu
-- Basado en el esquema original de la empresa pero adaptado para PostgreSQL

-- Crear base de datos si no existe
-- CREATE DATABASE eventu_db;

-- Conectar a la base de datos
-- \c eventu_db;

-- Tabla de eventos
CREATE TABLE IF NOT EXISTS eventu_events (
    ID VARCHAR(10) PRIMARY KEY,
    status SMALLINT NOT NULL DEFAULT 0,
    name VARCHAR(100) NOT NULL,
    fecha VARCHAR(160),
    location VARCHAR(160) NOT NULL,
    location_id INTEGER,
    image VARCHAR(200),
    date TIMESTAMP,
    date_end TIMESTAMP,
    visibility_start TIMESTAMP,
    visibility_end TIMESTAMP,
    web_visible BOOLEAN NOT NULL DEFAULT true,
    pos_boxes TEXT,
    checkin_start TIMESTAMP,
    chekin_end TIMESTAMP,
    cache_date TIMESTAMP,
    version BIGINT,
    grupo VARCHAR(50),
    grupo_label VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de usuarios
CREATE TABLE IF NOT EXISTS users (
    ID SERIAL PRIMARY KEY,
    status SMALLINT NOT NULL DEFAULT 1,
    nickname VARCHAR(60),
    t_document VARCHAR(5) NOT NULL DEFAULT 'CC',
    name VARCHAR(60),
    name2 VARCHAR(60),
    lastname VARCHAR(60),
    lastname2 VARCHAR(60),
    birthday DATE,
    gender SMALLINT,
    email VARCHAR(60),
    cellphone VARCHAR(60),
    password VARCHAR(60),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de órdenes
CREATE TABLE IF NOT EXISTS eventu_orders (
    ID SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    items TEXT,
    meta TEXT,
    ispaid BOOLEAN,
    tickets TEXT,
    method VARCHAR(30),
    comments TEXT,
    modified VARCHAR(60),
    message TEXT,
    payment_date VARCHAR(30),
    cashier INTEGER,
    version BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de productos
CREATE TABLE IF NOT EXISTS eventu_products (
    ID SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    status VARCHAR(50),
    name VARCHAR(100),
    price VARCHAR(20),
    stock INTEGER,
    meta TEXT,
    cat_id VARCHAR(10),
    cat_name VARCHAR(200),
    notes TEXT,
    version BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de tickets
CREATE TABLE IF NOT EXISTS eventu_tickets (
    ID SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL DEFAULT 0,
    order_id INTEGER,
    product_id INTEGER NOT NULL,
    checkins TEXT,
    checkins2 TEXT,
    code VARCHAR(30),
    data TEXT,
    version BIGINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de parámetros
CREATE TABLE IF NOT EXISTS params (
    ID VARCHAR(30) PRIMARY KEY,
    Param VARCHAR(10) NOT NULL,
    Value TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de datos adicionales de usuarios
CREATE TABLE IF NOT EXISTS users_data (
    user_id INTEGER NOT NULL DEFAULT 0,
    data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(ID) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_eventu_events_status ON eventu_events(status);
CREATE INDEX IF NOT EXISTS idx_eventu_events_date ON eventu_events(date);
CREATE INDEX IF NOT EXISTS idx_eventu_events_web_visible ON eventu_events(web_visible);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);
CREATE INDEX IF NOT EXISTS idx_eventu_orders_event_id ON eventu_orders(event_id);
CREATE INDEX IF NOT EXISTS idx_eventu_products_event_id ON eventu_products(event_id);
CREATE INDEX IF NOT EXISTS idx_eventu_tickets_event_id ON eventu_tickets(event_id);
CREATE INDEX IF NOT EXISTS idx_eventu_tickets_order_id ON eventu_tickets(order_id);

-- Datos de ejemplo
INSERT INTO users (nickname, name, name2, lastname, lastname2, email, cellphone, password, status) 
VALUES 
    ('admin', 'Administrador', '', 'Sistema', '', 'admin@eventu.com', '1234567890', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAg/9qm', 1),
    ('demo', 'Usuario', 'Demo', 'Prueba', '', 'demo@eventu.com', '0987654321', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/VcSAg/9qm', 1)
ON CONFLICT (email) DO NOTHING;

-- Eventos de ejemplo
INSERT INTO eventu_events (ID, status, name, fecha, location, date, web_visible, grupo) 
VALUES 
    ('EVT001', 1, 'Concierto de Rock', '2024-12-31 20:00:00', 'Estadio Nacional', '2024-12-31 20:00:00', true, 'musica'),
    ('EVT002', 1, 'Festival de Jazz', '2024-11-15 19:00:00', 'Teatro Colón', '2024-11-15 19:00:00', true, 'musica'),
    ('EVT003', 1, 'Obra de Teatro', '2024-10-20 21:00:00', 'Teatro Nacional', '2024-10-20 21:00:00', true, 'teatro')
ON CONFLICT (ID) DO NOTHING;

-- Parámetros del sistema
INSERT INTO params (ID, Param, Value) 
VALUES 
    ('app_name', 'APP', 'Eventu'),
    ('app_version', 'VER', '1.0.0'),
    ('currency', 'CUR', 'COP')
ON CONFLICT (ID) DO NOTHING;

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Triggers para actualizar updated_at
CREATE TRIGGER update_eventu_events_updated_at BEFORE UPDATE ON eventu_events FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventu_orders_updated_at BEFORE UPDATE ON eventu_orders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventu_products_updated_at BEFORE UPDATE ON eventu_products FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_eventu_tickets_updated_at BEFORE UPDATE ON eventu_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_params_updated_at BEFORE UPDATE ON params FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_users_data_updated_at BEFORE UPDATE ON users_data FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

COMMIT;

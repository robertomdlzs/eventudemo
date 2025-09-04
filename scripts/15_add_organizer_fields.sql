-- Script para agregar campos necesarios para el panel de organizador
-- Ejecutar después de crear las tablas principales

-- Agregar campo organizer_id a la tabla events si no existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'events' AND column_name = 'organizer_id') THEN
        ALTER TABLE events ADD COLUMN organizer_id INTEGER REFERENCES users(id);
    END IF;
END $$;

-- Agregar campos de check-in a la tabla sales si no existen
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'sales' AND column_name = 'checked_in') THEN
        ALTER TABLE sales ADD COLUMN checked_in BOOLEAN DEFAULT false;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'sales' AND column_name = 'check_in_time') THEN
        ALTER TABLE sales ADD COLUMN check_in_time TIMESTAMP;
    END IF;
END $$;

-- Agregar campo ticket_type_id a la tabla sales si no existe
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'sales' AND column_name = 'ticket_type_id') THEN
        ALTER TABLE sales ADD COLUMN ticket_type_id INTEGER REFERENCES ticket_types(id);
    END IF;
END $$;

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_events_organizer_id ON events(organizer_id);
CREATE INDEX IF NOT EXISTS idx_sales_checked_in ON sales(checked_in);
CREATE INDEX IF NOT EXISTS idx_sales_check_in_time ON sales(check_in_time);
CREATE INDEX IF NOT EXISTS idx_sales_ticket_type_id ON sales(ticket_type_id);
CREATE INDEX IF NOT EXISTS idx_sales_created_at ON sales(created_at);

-- Insertar datos de ejemplo para organizadores
INSERT INTO users (name, email, password, role, created_at, updated_at) 
VALUES 
    ('Juan Pérez', 'juan.perez@eventu.com', '$2b$10$example.hash', 'organizer', NOW(), NOW()),
    ('María García', 'maria.garcia@eventu.com', '$2b$10$example.hash', 'organizer', NOW(), NOW()),
    ('Carlos López', 'carlos.lopez@eventu.com', '$2b$10$example.hash', 'organizer', NOW(), NOW())
ON CONFLICT (email) DO NOTHING;

-- Asignar eventos existentes a organizadores (si no tienen organizer_id)
UPDATE events 
SET organizer_id = (SELECT id FROM users WHERE role = 'organizer' LIMIT 1)
WHERE organizer_id IS NULL;

-- Insertar datos de ejemplo para ventas con check-in
INSERT INTO sales (event_id, buyer_name, buyer_email, quantity, amount, payment_method, status, ticket_type_id, created_at, updated_at)
VALUES 
    (1, 'Ana Rodríguez', 'ana.rodriguez@email.com', 2, 100000, 'credit_card', 'completed', 1, NOW() - INTERVAL '2 hours', NOW() - INTERVAL '2 hours'),
    (1, 'Luis Martínez', 'luis.martinez@email.com', 1, 50000, 'debit_card', 'completed', 1, NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour'),
    (2, 'Carmen Silva', 'carmen.silva@email.com', 3, 150000, 'credit_card', 'completed', 2, NOW() - INTERVAL '30 minutes', NOW() - INTERVAL '30 minutes'),
    (2, 'Roberto Díaz', 'roberto.diaz@email.com', 1, 50000, 'cash', 'completed', 2, NOW() - INTERVAL '15 minutes', NOW() - INTERVAL '15 minutes'),
    (3, 'Patricia Ruiz', 'patricia.ruiz@email.com', 2, 120000, 'credit_card', 'completed', 3, NOW() - INTERVAL '10 minutes', NOW() - INTERVAL '10 minutes')
ON CONFLICT DO NOTHING;

-- Marcar algunos asistentes como check-in
UPDATE sales 
SET checked_in = true, check_in_time = NOW() - INTERVAL '1 hour'
WHERE id IN (1, 2);

UPDATE sales 
SET checked_in = true, check_in_time = NOW() - INTERVAL '30 minutes'
WHERE id = 3;

-- Crear vista para estadísticas del organizador
CREATE OR REPLACE VIEW organizer_stats AS
SELECT 
    e.organizer_id,
    u.name as organizer_name,
    COUNT(DISTINCT e.id) as total_events,
    COUNT(DISTINCT CASE WHEN e.status = 'published' THEN e.id END) as published_events,
    COUNT(DISTINCT CASE WHEN e.status = 'draft' THEN e.id END) as draft_events,
    COUNT(DISTINCT s.id) as total_sales,
    COALESCE(SUM(s.amount), 0) as total_revenue,
    COALESCE(SUM(s.quantity), 0) as total_tickets_sold,
    COUNT(DISTINCT s.buyer_email) as unique_customers,
    CASE 
        WHEN COUNT(DISTINCT s.id) > 0 
        THEN COALESCE(SUM(s.amount), 0) / COUNT(DISTINCT s.id)
        ELSE 0 
    END as average_order_value
FROM events e
LEFT JOIN sales s ON e.id = s.event_id
JOIN users u ON e.organizer_id = u.id
WHERE u.role = 'organizer'
GROUP BY e.organizer_id, u.name;

-- Crear vista para ventas en tiempo real
CREATE OR REPLACE VIEW realtime_sales AS
SELECT 
    e.organizer_id,
    e.id as event_id,
    e.title as event_title,
    e.date as event_date,
    e.total_capacity,
    COALESCE(SUM(s.quantity), 0) as tickets_sold,
    e.total_capacity - COALESCE(SUM(s.quantity), 0) as remaining_capacity,
    CASE 
        WHEN e.total_capacity > 0 
        THEN (COALESCE(SUM(s.quantity), 0) * 100.0 / e.total_capacity)
        ELSE 0 
    END as occupancy_rate,
    COUNT(s.id) as total_sales,
    COALESCE(SUM(s.amount), 0) as total_revenue,
    CASE 
        WHEN COUNT(s.id) > 0 
        THEN COALESCE(SUM(s.amount), 0) / COUNT(s.id)
        ELSE 0 
    END as average_sale_amount,
    COUNT(CASE WHEN s.created_at >= NOW() - INTERVAL '1 hour' THEN s.id END) as sales_last_hour,
    COUNT(CASE WHEN s.created_at >= DATE_TRUNC('day', NOW()) THEN s.id END) as sales_today,
    COUNT(CASE WHEN s.created_at >= DATE_TRUNC('week', NOW()) THEN s.id END) as sales_this_week,
    MAX(s.created_at) as last_sale_time
FROM events e
LEFT JOIN sales s ON e.id = s.event_id
WHERE e.status = 'published'
GROUP BY e.organizer_id, e.id, e.title, e.date, e.total_capacity;

-- Crear vista para actividad reciente
CREATE OR REPLACE VIEW recent_activity AS
SELECT 
    e.organizer_id,
    'sale' as type,
    s.id,
    'Nueva venta realizada' as description,
    s.amount,
    e.title as event_title,
    s.created_at,
    EXTRACT(EPOCH FROM (NOW() - s.created_at)) / 3600 as hours_ago
FROM sales s
JOIN events e ON s.event_id = e.id
ORDER BY s.created_at DESC;

-- Comentarios sobre las mejoras
COMMENT ON TABLE events IS 'Tabla de eventos con soporte para organizadores';
COMMENT ON COLUMN events.organizer_id IS 'ID del organizador responsable del evento';
COMMENT ON COLUMN sales.checked_in IS 'Indica si el asistente ha realizado check-in';
COMMENT ON COLUMN sales.check_in_time IS 'Timestamp del momento del check-in';
COMMENT ON COLUMN sales.ticket_type_id IS 'Tipo de boleto comprado';

COMMENT ON VIEW organizer_stats IS 'Vista para estadísticas generales del organizador';
COMMENT ON VIEW realtime_sales IS 'Vista para datos de ventas en tiempo real';
COMMENT ON VIEW recent_activity IS 'Vista para actividad reciente del organizador';

-- Verificar que todo se creó correctamente
SELECT 'Verificación de campos agregados:' as info;
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'events' AND column_name = 'organizer_id'
UNION ALL
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'sales' AND column_name IN ('checked_in', 'check_in_time', 'ticket_type_id');

SELECT 'Verificación de vistas creadas:' as info;
SELECT viewname FROM pg_views WHERE viewname IN ('organizer_stats', 'realtime_sales', 'recent_activity');

SELECT 'Verificación de datos de ejemplo:' as info;
SELECT COUNT(*) as total_organizers FROM users WHERE role = 'organizer';
SELECT COUNT(*) as total_sales_with_checkin FROM sales WHERE checked_in = true;

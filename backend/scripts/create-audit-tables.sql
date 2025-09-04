-- Tabla de logs de auditoría
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    resource_id VARCHAR(255),
    details JSONB,
    ip_address INET NOT NULL,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severity VARCHAR(20) DEFAULT 'low' CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    status VARCHAR(20) DEFAULT 'success' CHECK (status IN ('success', 'failure', 'warning'))
);

-- Tabla de notificaciones
CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(20) DEFAULT 'info' CHECK (type IN ('info', 'success', 'warning', 'error')),
    target VARCHAR(20) DEFAULT 'all' CHECK (target IN ('all', 'admins', 'organizers', 'users', 'specific')),
    recipients JSONB,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_by JSONB DEFAULT '[]',
    status VARCHAR(20) DEFAULT 'sent' CHECK (status IN ('sent', 'delivered', 'failed')),
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de check-in records
CREATE TABLE IF NOT EXISTS check_in_records (
    id SERIAL PRIMARY KEY,
    ticket_number VARCHAR(255) UNIQUE NOT NULL,
    event_name VARCHAR(255) NOT NULL,
    customer_name VARCHAR(255) NOT NULL,
    ticket_type VARCHAR(100) DEFAULT 'General',
    check_in_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    gate VARCHAR(100) NOT NULL,
    status VARCHAR(20) DEFAULT 'checked-in' CHECK (status IN ('checked-in', 'pending', 'duplicate', 'invalid')),
    operator VARCHAR(255) NOT NULL,
    event_id INTEGER REFERENCES events(id),
    sale_id INTEGER REFERENCES sales(id)
);

-- Tabla de reportes guardados
CREATE TABLE IF NOT EXISTS saved_reports (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    filters JSONB,
    schedule JSONB,
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de reportes programados
CREATE TABLE IF NOT EXISTS scheduled_reports (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,
    schedule JSONB NOT NULL,
    recipients JSONB,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_run TIMESTAMP,
    next_run TIMESTAMP
);

-- Tabla de backups
CREATE TABLE IF NOT EXISTS backups (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    size BIGINT NOT NULL,
    type VARCHAR(50) DEFAULT 'manual',
    status VARCHAR(20) DEFAULT 'completed' CHECK (status IN ('pending', 'completed', 'failed')),
    created_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    file_path TEXT
);

-- Tabla de backup schedules
CREATE TABLE IF NOT EXISTS backup_schedules (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    frequency VARCHAR(20) NOT NULL CHECK (frequency IN ('daily', 'weekly', 'monthly')),
    time TIME NOT NULL,
    retention_days INTEGER DEFAULT 30,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_by VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_backup TIMESTAMP,
    next_backup TIMESTAMP
);

-- Índices para mejorar rendimiento
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_timestamp ON audit_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_severity ON audit_logs(severity);

CREATE INDEX IF NOT EXISTS idx_notifications_target ON notifications(target);
CREATE INDEX IF NOT EXISTS idx_notifications_sent_at ON notifications(sent_at);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);

CREATE INDEX IF NOT EXISTS idx_check_in_records_ticket_number ON check_in_records(ticket_number);
CREATE INDEX IF NOT EXISTS idx_check_in_records_event_id ON check_in_records(event_id);
CREATE INDEX IF NOT EXISTS idx_check_in_records_check_in_time ON check_in_records(check_in_time);

CREATE INDEX IF NOT EXISTS idx_saved_reports_created_by ON saved_reports(created_by);
CREATE INDEX IF NOT EXISTS idx_scheduled_reports_status ON scheduled_reports(status);
CREATE INDEX IF NOT EXISTS idx_scheduled_reports_next_run ON scheduled_reports(next_run);

-- Insertar datos de ejemplo
INSERT INTO audit_logs (user_id, user_name, user_email, action, resource, details, ip_address, user_agent, severity, status) VALUES
('admin1', 'Admin Principal', 'admin@eventu.co', 'LOGIN', 'auth', '{"method": "email", "success": true}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'low', 'success'),
('admin1', 'Admin Principal', 'admin@eventu.co', 'CREATE_EVENT', 'events', '{"eventTitle": "Conferencia Tech 2024", "eventId": "event123"}', '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', 'medium', 'success')
ON CONFLICT DO NOTHING;

INSERT INTO notifications (title, message, type, target, status) VALUES
('Nuevo evento publicado', 'El evento "Conferencia Tech 2024" ha sido publicado exitosamente', 'success', 'all', 'delivered'),
('Mantenimiento programado', 'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 4:00 AM', 'warning', 'admins', 'sent')
ON CONFLICT DO NOTHING;

-- Crear vistas para reportes
CREATE OR REPLACE VIEW audit_summary AS
SELECT 
    DATE(timestamp) as date,
    action,
    severity,
    status,
    COUNT(*) as count
FROM audit_logs
GROUP BY DATE(timestamp), action, severity, status;

CREATE OR REPLACE VIEW notification_summary AS
SELECT 
    DATE(sent_at) as date,
    type,
    target,
    status,
    COUNT(*) as count
FROM notifications
GROUP BY DATE(sent_at), type, target, status;

-- Crear tabla de configuraciones del sistema
CREATE TABLE IF NOT EXISTS system_settings (
    id SERIAL PRIMARY KEY,
    site_name VARCHAR(255) NOT NULL DEFAULT 'Eventu',
    site_description TEXT DEFAULT 'La mejor plataforma para eventos en Colombia',
    contact_email VARCHAR(255) NOT NULL DEFAULT 'contacto@eventu.com',
    support_email VARCHAR(255) DEFAULT 'soporte@eventu.com',
    currency VARCHAR(10) DEFAULT 'COP',
    timezone VARCHAR(100) DEFAULT 'America/Bogota',
    maintenance_mode BOOLEAN DEFAULT false,
    registration_enabled BOOLEAN DEFAULT true,
    email_notifications BOOLEAN DEFAULT true,
    sms_notifications BOOLEAN DEFAULT false,
    max_tickets_per_purchase INTEGER DEFAULT 10,
    commission_rate DECIMAL(5,2) DEFAULT 5.00,
    -- Configuraciones de seguridad
    two_factor_auth BOOLEAN DEFAULT false,
    login_attempts_limit BOOLEAN DEFAULT true,
    max_login_attempts INTEGER DEFAULT 5,
    lockout_duration INTEGER DEFAULT 30,
    auto_logout BOOLEAN DEFAULT true,
    session_timeout INTEGER DEFAULT 60,
    password_min_length INTEGER DEFAULT 8,
    password_require_uppercase BOOLEAN DEFAULT true,
    password_require_lowercase BOOLEAN DEFAULT true,
    password_require_numbers BOOLEAN DEFAULT true,
    password_require_symbols BOOLEAN DEFAULT false,
    activity_logging BOOLEAN DEFAULT true,
    security_notifications BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_system_settings_created_at ON system_settings(created_at);
CREATE INDEX IF NOT EXISTS idx_system_settings_updated_at ON system_settings(updated_at);

-- Insertar configuración por defecto
INSERT INTO system_settings (
    site_name,
    site_description,
    contact_email,
    support_email,
    currency,
    timezone,
    maintenance_mode,
    registration_enabled,
    email_notifications,
    sms_notifications,
    max_tickets_per_purchase,
    commission_rate,
    -- Configuraciones de seguridad
    two_factor_auth,
    login_attempts_limit,
    max_login_attempts,
    lockout_duration,
    auto_logout,
    session_timeout,
    password_min_length,
    password_require_uppercase,
    password_require_lowercase,
    password_require_numbers,
    password_require_symbols,
    activity_logging,
    security_notifications,
    created_at,
    updated_at
) VALUES (
    'Eventu',
    'La mejor plataforma para eventos en Colombia',
    'contacto@eventu.com',
    'soporte@eventu.com',
    'COP',
    'America/Bogota',
    false,
    true,
    true,
    false,
    10,
    5.00,
    -- Configuraciones de seguridad por defecto
    false,
    true,
    5,
    30,
    true,
    60,
    8,
    true,
    true,
    true,
    false,
    true,
    true,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
) ON CONFLICT DO NOTHING;

-- Verificar la creación
SELECT 'Settings table created successfully' as status;

-- Script para crear tabla de evento próximo con cuenta regresiva
-- Esta tabla permitirá a los administradores configurar el evento destacado con cuenta regresiva

-- Crear tabla para evento próximo destacado
CREATE TABLE IF NOT EXISTS featured_countdown_event (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Título del evento',
    date VARCHAR(100) NOT NULL COMMENT 'Fecha del evento (formato display)',
    location VARCHAR(255) NOT NULL COMMENT 'Ubicación del evento',
    image_url VARCHAR(500) DEFAULT '/placeholder.jpg' COMMENT 'URL de la imagen del evento',
    event_slug VARCHAR(255) COMMENT 'Slug del evento para redireccionamiento',
    redirect_url VARCHAR(500) COMMENT 'URL personalizada de redireccionamiento',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Si el evento está activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_featured_countdown_active (is_active),
    INDEX idx_featured_countdown_created (created_at)
);

-- Insertar evento por defecto
INSERT INTO featured_countdown_event (
    title, 
    date, 
    location, 
    image_url, 
    event_slug, 
    is_active
) VALUES (
    'PANACA VIAJERO BARRANQUILLA',
    '20 DE JUNIO 2025',
    'PARQUE NORTE - BARRANQUILLA',
    '/placeholder.jpg',
    'panaca-viajero-barranquilla',
    TRUE
) ON DUPLICATE KEY UPDATE
    title = VALUES(title),
    date = VALUES(date),
    location = VALUES(location),
    image_url = VALUES(image_url),
    event_slug = VALUES(event_slug),
    is_active = VALUES(is_active),
    updated_at = CURRENT_TIMESTAMP;

-- Agregar comentarios para documentar la tabla
ALTER TABLE featured_countdown_event 
COMMENT = 'Tabla para gestionar el evento próximo destacado con cuenta regresiva';

-- Crear vista para obtener el evento activo
CREATE OR REPLACE VIEW active_featured_countdown AS
SELECT 
    id,
    title,
    date,
    location,
    image_url,
    event_slug,
    redirect_url,
    is_active,
    created_at,
    updated_at
FROM featured_countdown_event 
WHERE is_active = TRUE 
ORDER BY updated_at DESC 
LIMIT 1;


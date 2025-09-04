-- Crear tabla de carpetas de medios
CREATE TABLE IF NOT EXISTS media_folders (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id INTEGER REFERENCES media_folders(id) ON DELETE CASCADE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla de medios
CREATE TABLE IF NOT EXISTS media (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255),
    type VARCHAR(50) NOT NULL CHECK (type IN ('image', 'video', 'audio', 'document')),
    size BIGINT DEFAULT 0,
    url TEXT NOT NULL,
    folder_id INTEGER REFERENCES media_folders(id) ON DELETE SET NULL,
    alt TEXT,
    description TEXT,
    tags JSONB,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used TIMESTAMP,
    usage_count INTEGER DEFAULT 0
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_media_type ON media(type);
CREATE INDEX IF NOT EXISTS idx_media_folder_id ON media(folder_id);
CREATE INDEX IF NOT EXISTS idx_media_upload_date ON media(upload_date);
CREATE INDEX IF NOT EXISTS idx_media_folders_parent_id ON media_folders(parent_id);

-- Insertar carpetas de ejemplo
INSERT INTO media_folders (name, created_date) VALUES
('Branding', CURRENT_TIMESTAMP),
('Eventos', CURRENT_TIMESTAMP),
('Plantillas', CURRENT_TIMESTAMP),
('Documentos', CURRENT_TIMESTAMP),
('Videos', CURRENT_TIMESTAMP),
('Audio', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- Insertar medios de ejemplo
INSERT INTO media (name, original_name, type, size, url, folder_id, alt, description, tags, upload_date) VALUES
('eventu-logo.svg', 'eventu-logo.svg', 'image', 15420, '/uploads/eventu-logo.svg', 1, 'Logo de Eventu', 'Logo principal de la plataforma', '["logo", "branding"]', CURRENT_TIMESTAMP),
('panaca-poster.jpg', 'panaca-poster.jpg', 'image', 245680, '/uploads/panaca-poster.jpg', 2, 'Poster del evento Panaca', 'Imagen promocional del evento Panaca', '["evento", "poster", "panaca"]', CURRENT_TIMESTAMP),
('seat-map-example-1.png', 'seat-map-example-1.png', 'image', 89340, '/uploads/seat-map-example-1.png', 3, 'Ejemplo de mapa de asientos', 'Plantilla de mapa de asientos para eventos', '["mapa", "asientos", "plantilla"]', CURRENT_TIMESTAMP),
('manual-usuario.pdf', 'manual-usuario.pdf', 'document', 1024000, '/uploads/manual-usuario.pdf', 4, 'Manual de usuario', 'Documento con instrucciones de uso', '["manual", "documentacion"]', CURRENT_TIMESTAMP),
('video-promocional.mp4', 'video-promocional.mp4', 'video', 5242880, '/uploads/video-promocional.mp4', 5, 'Video promocional', 'Video promocional de la plataforma', '["video", "promocional"]', CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;

-- Verificar la creación
SELECT 'Media tables created successfully' as status;

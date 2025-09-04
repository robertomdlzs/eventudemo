-- Migración para agregar campos multimedia a la tabla events
-- Ejecutar después de crear la base de datos

-- Agregar campos multimedia a la tabla events
ALTER TABLE events 
ADD COLUMN IF NOT EXISTS main_image_url VARCHAR(500),
ADD COLUMN IF NOT EXISTS video_url VARCHAR(500),
ADD COLUMN IF NOT EXISTS gallery_images JSONB DEFAULT '[]'::jsonb,
ADD COLUMN IF NOT EXISTS social_links JSONB DEFAULT '{}'::jsonb;

-- Agregar comentarios para documentar los nuevos campos
COMMENT ON COLUMN events.main_image_url IS 'URL de la imagen principal del evento';
COMMENT ON COLUMN events.video_url IS 'URL del video promocional del evento';
COMMENT ON COLUMN events.gallery_images IS 'Array de URLs de imágenes de la galería del evento';
COMMENT ON COLUMN events.social_links IS 'Enlaces a redes sociales del evento (JSON)';

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_events_main_image ON events(main_image_url) WHERE main_image_url IS NOT NULL;
CREATE INDEX IF NOT EXISTS idx_events_video ON events(video_url) WHERE video_url IS NOT NULL;

-- Actualizar eventos existentes con datos de ejemplo (opcional)
UPDATE events 
SET 
    main_image_url = image_url,
    video_url = youtube_url,
    gallery_images = '[]'::jsonb,
    social_links = '{}'::jsonb
WHERE main_image_url IS NULL;

-- Verificar que los cambios se aplicaron correctamente
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'events' 
AND column_name IN ('main_image_url', 'video_url', 'gallery_images', 'social_links')
ORDER BY column_name;

-- Agregar campo phone a la tabla users
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20);

-- Crear índice para búsquedas por teléfono
CREATE INDEX IF NOT EXISTS idx_users_phone ON users(phone);

-- Comentario sobre el campo
COMMENT ON COLUMN users.phone IS 'Número de teléfono del usuario';

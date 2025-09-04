-- Agregar columna phone a la tabla users si no existe
ALTER TABLE users ADD COLUMN IF NOT EXISTS phone VARCHAR(20) NULL;

-- Actualizar algunos usuarios de ejemplo con números de teléfono
UPDATE users SET phone = '+57 300 123 4567' WHERE id = 1;
UPDATE users SET phone = '+57 310 987 6543' WHERE id = 2;
UPDATE users SET phone = '+57 315 555 1234' WHERE id = 3;








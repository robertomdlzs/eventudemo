-- Script corregido para insertar datos de ejemplo de mapas de asientos
-- Basado en la estructura actual de la base de datos

-- Primero, crear secciones de asientos
INSERT INTO seat_sections (name, seat_map_id, capacity, price, color, created_at) VALUES
-- Secciones para Teatro Principal (ID: 1)
('Orquesta', 1, 150, 80000, '#3b82f6', CURRENT_TIMESTAMP),
('Balcón', 1, 96, 60000, '#10b981', CURRENT_TIMESTAMP),
('Galería', 1, 60, 40000, '#f59e0b', CURRENT_TIMESTAMP),

-- Secciones para Arena Deportiva (ID: 2)
('VIP', 2, 100, 150000, '#8b5cf6', CURRENT_TIMESTAMP),
('Premium', 2, 250, 100000, '#ef4444', CURRENT_TIMESTAMP),
('General', 2, 600, 50000, '#6b7280', CURRENT_TIMESTAMP),

-- Secciones para Sala de Conciertos (ID: 3)
('Piso', 3, 300, 120000, '#06b6d4', CURRENT_TIMESTAMP),
('Mezzanine', 3, 200, 90000, '#f97316', CURRENT_TIMESTAMP),
('Superior', 3, 180, 60000, '#84cc16', CURRENT_TIMESTAMP);

-- Insertar asientos para Orquesta (sección ID: 1)
INSERT INTO seats (section_id, seat_number, row_number, status, position_x, position_y, created_at)
SELECT 
  1, 
  seat_num::varchar, 
  row_num::varchar, 
  'available',
  seat_num,
  row_num,
  CURRENT_TIMESTAMP
FROM generate_series(1, 10) AS row_num
CROSS JOIN generate_series(1, 15) AS seat_num;

-- Insertar asientos para Balcón (sección ID: 2)
INSERT INTO seats (section_id, seat_number, row_number, status, position_x, position_y, created_at)
SELECT 
  2, 
  seat_num::varchar, 
  (row_num + 10)::varchar, 
  'available',
  seat_num,
  row_num + 10,
  CURRENT_TIMESTAMP
FROM generate_series(1, 8) AS row_num
CROSS JOIN generate_series(1, 12) AS seat_num;

-- Insertar asientos para Galería (sección ID: 3)
INSERT INTO seats (section_id, seat_number, row_number, status, position_x, position_y, created_at)
SELECT 
  3, 
  seat_num::varchar, 
  (row_num + 18)::varchar, 
  'available',
  seat_num,
  row_num + 18,
  CURRENT_TIMESTAMP
FROM generate_series(1, 6) AS row_num
CROSS JOIN generate_series(1, 10) AS seat_num;

-- Insertar algunos asientos ocupados y reservados para demostración
UPDATE seats 
SET status = 'sold'
WHERE section_id = 1 AND row_number = '1' AND seat_number IN ('1', '2', '3');

UPDATE seats 
SET status = 'reserved'
WHERE section_id = 1 AND row_number = '2' AND seat_number IN ('1', '2');

-- Mostrar estadísticas
SELECT 
  'Mapas de asientos creados:' as info,
  COUNT(*) as total
FROM seat_maps;

SELECT 
  'Secciones creadas:' as info,
  COUNT(*) as total
FROM seat_sections;

SELECT 
  'Asientos creados:' as info,
  COUNT(*) as total
FROM seats;

SELECT 
  'Asientos por estado:' as info,
  status,
  COUNT(*) as total
FROM seats 
GROUP BY status;

SELECT 
  'Asientos por sección:' as info,
  ss.name as section_name,
  COUNT(s.id) as total_seats
FROM seat_sections ss
LEFT JOIN seats s ON ss.id = s.section_id
GROUP BY ss.id, ss.name
ORDER BY ss.id;

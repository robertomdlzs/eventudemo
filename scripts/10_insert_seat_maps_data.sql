-- Script para insertar datos de ejemplo de mapas de asientos
-- Ejecutar después de crear la base de datos

-- Insertar mapas de asientos de ejemplo
INSERT INTO seat_maps (name, venue_name, total_capacity, map_data, created_by, created_at, updated_at) VALUES
(
  'Teatro Principal',
  'Teatro Colón',
  300,
  '{
    "sections": [
      {
        "id": "orchestra",
        "name": "Orquesta",
        "color": "#3b82f6",
        "price": 80000,
        "rows": 10,
        "seatsPerRow": 15,
        "startRow": 1
      },
      {
        "id": "balcony",
        "name": "Balcón",
        "color": "#10b981",
        "price": 60000,
        "rows": 8,
        "seatsPerRow": 12,
        "startRow": 11
      },
      {
        "id": "gallery",
        "name": "Galería",
        "color": "#f59e0b",
        "price": 40000,
        "rows": 6,
        "seatsPerRow": 10,
        "startRow": 19
      }
    ]
  }'::jsonb,
  1,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'Arena Deportiva',
  'Estadio El Campín',
  5000,
  '{
    "sections": [
      {
        "id": "vip",
        "name": "VIP",
        "color": "#8b5cf6",
        "price": 150000,
        "rows": 5,
        "seatsPerRow": 20,
        "startRow": 1
      },
      {
        "id": "premium",
        "name": "Premium",
        "color": "#ef4444",
        "price": 100000,
        "rows": 10,
        "seatsPerRow": 25,
        "startRow": 6
      },
      {
        "id": "general",
        "name": "General",
        "color": "#6b7280",
        "price": 50000,
        "rows": 20,
        "seatsPerRow": 30,
        "startRow": 16
      }
    ]
  }'::jsonb,
  1,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
),
(
  'Sala de Conciertos',
  'Centro de Convenciones',
  800,
  '{
    "sections": [
      {
        "id": "floor",
        "name": "Piso",
        "color": "#06b6d4",
        "price": 120000,
        "rows": 15,
        "seatsPerRow": 20,
        "startRow": 1
      },
      {
        "id": "mezzanine",
        "name": "Mezzanine",
        "color": "#f97316",
        "price": 90000,
        "rows": 8,
        "seatsPerRow": 25,
        "startRow": 16
      },
      {
        "id": "upper",
        "name": "Superior",
        "color": "#84cc16",
        "price": 60000,
        "rows": 6,
        "seatsPerRow": 30,
        "startRow": 24
      }
    ]
  }'::jsonb,
  1,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
);

-- Insertar asientos para el Teatro Principal (ID: 1)
-- Orquesta (150 asientos)
INSERT INTO seats (seat_map_id, row_number, seat_number, status, price, section, type, created_at) 
SELECT 
  1, 
  row_num, 
  seat_num, 
  'available',
  CASE 
    WHEN row_num = 1 THEN 120000  -- VIP (primera fila)
    ELSE 80000                    -- Regular
  END,
  'Orquesta',
  CASE 
    WHEN row_num = 1 THEN 'vip'
    WHEN row_num = 10 AND (seat_num = 1 OR seat_num = 15) THEN 'accessible'
    ELSE 'regular'
  END,
  CURRENT_TIMESTAMP
FROM generate_series(1, 10) AS row_num
CROSS JOIN generate_series(1, 15) AS seat_num;

-- Balcón (96 asientos)
INSERT INTO seats (seat_map_id, row_number, seat_number, status, price, section, type, created_at) 
SELECT 
  1, 
  row_num + 10, 
  seat_num, 
  'available',
  60000,
  'Balcón',
  CASE 
    WHEN row_num = 8 AND (seat_num = 1 OR seat_num = 12) THEN 'accessible'
    ELSE 'regular'
  END,
  CURRENT_TIMESTAMP
FROM generate_series(1, 8) AS row_num
CROSS JOIN generate_series(1, 12) AS seat_num;

-- Galería (60 asientos)
INSERT INTO seats (seat_map_id, row_number, seat_number, status, price, section, type, created_at) 
SELECT 
  1, 
  row_num + 18, 
  seat_num, 
  'available',
  40000,
  'Galería',
  CASE 
    WHEN row_num = 6 AND (seat_num = 1 OR seat_num = 10) THEN 'accessible'
    ELSE 'regular'
  END,
  CURRENT_TIMESTAMP
FROM generate_series(1, 6) AS row_num
CROSS JOIN generate_series(1, 10) AS seat_num;

-- Insertar algunos asientos ocupados y reservados para demostración
UPDATE seats 
SET status = 'occupied', 
    occupied_by = 1, 
    occupied_at = CURRENT_TIMESTAMP 
WHERE seat_map_id = 1 AND row_number = 1 AND seat_number IN (1, 2, 3);

UPDATE seats 
SET status = 'reserved', 
    reserved_by = 2, 
    reserved_at = CURRENT_TIMESTAMP 
WHERE seat_map_id = 1 AND row_number = 2 AND seat_number IN (1, 2);

-- Asignar mapas de asientos a algunos eventos existentes
UPDATE events 
SET seat_map_id = 1 
WHERE id = 1;  -- Asumiendo que el evento con ID 1 existe

UPDATE events 
SET seat_map_id = 2 
WHERE id = 2;  -- Asumiendo que el evento con ID 2 existe

-- Mostrar estadísticas
SELECT 
  'Mapas de asientos creados:' as info,
  COUNT(*) as total
FROM seat_maps;

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
  'Asientos por tipo:' as info,
  type,
  COUNT(*) as total
FROM seats 
GROUP BY type;

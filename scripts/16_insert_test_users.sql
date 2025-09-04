-- Script para insertar usuarios de prueba con diferentes roles
-- Estos usuarios pueden ser utilizados para probar el sistema de autenticación y redirección

-- Limpiar usuarios de prueba existentes (opcional)
-- DELETE FROM users WHERE email LIKE '%@test.eventu.com';

-- Insertar usuarios de prueba con diferentes roles
INSERT INTO users (name, email, password, role, status, created_at, updated_at) 
VALUES 
    -- Administrador
    (
        'Admin Eventu',
        'admin@test.eventu.com',
        '$2b$10$example.hash.admin', -- En producción usar bcrypt real
        'admin',
        'active',
        NOW(),
        NOW()
    ),
    
    -- Organizador 1
    (
        'Juan Pérez Organizador',
        'organizer1@test.eventu.com',
        '$2b$10$example.hash.organizer1',
        'organizer',
        'active',
        NOW(),
        NOW()
    ),
    
    -- Organizador 2
    (
        'María García Organizadora',
        'organizer2@test.eventu.com',
        '$2b$10$example.hash.organizer2',
        'organizer',
        'active',
        NOW(),
        NOW()
    ),
    
    -- Usuario normal 1
    (
        'Carlos López Usuario',
        'user1@test.eventu.com',
        '$2b$10$example.hash.user1',
        'user',
        'active',
        NOW(),
        NOW()
    ),
    
    -- Usuario normal 2
    (
        'Ana Rodríguez Usuaria',
        'user2@test.eventu.com',
        '$2b$10$example.hash.user2',
        'user',
        'active',
        NOW(),
        NOW()
    ),
    
    -- Usuario normal 3
    (
        'Luis Martínez Cliente',
        'user3@test.eventu.com',
        '$2b$10$example.hash.user3',
        'user',
        'active',
        NOW(),
        NOW()
    )
ON CONFLICT (email) DO NOTHING;

-- Asignar eventos a organizadores de prueba
UPDATE events 
SET organizer_id = (SELECT id FROM users WHERE email = 'organizer1@test.eventu.com' LIMIT 1)
WHERE id IN (1, 2, 3);

UPDATE events 
SET organizer_id = (SELECT id FROM users WHERE email = 'organizer2@test.eventu.com' LIMIT 1)
WHERE id IN (4, 5, 6);

-- Insertar ventas de prueba para usuarios
INSERT INTO sales (event_id, buyer_name, buyer_email, quantity, amount, payment_method, status, ticket_type_id, created_at, updated_at)
VALUES 
    -- Ventas para user1
    (1, 'Carlos López Usuario', 'user1@test.eventu.com', 2, 100000, 'credit_card', 'completed', 1, NOW() - INTERVAL '2 days', NOW() - INTERVAL '2 days'),
    (2, 'Carlos López Usuario', 'user1@test.eventu.com', 1, 50000, 'debit_card', 'completed', 2, NOW() - INTERVAL '1 day', NOW() - INTERVAL '1 day'),
    
    -- Ventas para user2
    (3, 'Ana Rodríguez Usuaria', 'user2@test.eventu.com', 3, 150000, 'credit_card', 'completed', 1, NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),
    (4, 'Ana Rodríguez Usuaria', 'user2@test.eventu.com', 1, 75000, 'cash', 'completed', 3, NOW() - INTERVAL '12 hours', NOW() - INTERVAL '12 hours'),
    
    -- Ventas para user3
    (5, 'Luis Martínez Cliente', 'user3@test.eventu.com', 2, 120000, 'credit_card', 'completed', 2, NOW() - INTERVAL '6 hours', NOW() - INTERVAL '6 hours'),
    (6, 'Luis Martínez Cliente', 'user3@test.eventu.com', 1, 60000, 'debit_card', 'completed', 1, NOW() - INTERVAL '1 hour', NOW() - INTERVAL '1 hour')
ON CONFLICT DO NOTHING;

-- Marcar algunos check-ins
UPDATE sales 
SET checked_in = true, check_in_time = NOW() - INTERVAL '1 hour'
WHERE buyer_email = 'user1@test.eventu.com' AND event_id = 1;

UPDATE sales 
SET checked_in = true, check_in_time = NOW() - INTERVAL '30 minutes'
WHERE buyer_email = 'user2@test.eventu.com' AND event_id = 3;

-- Verificar la inserción
SELECT 'Usuarios de prueba creados:' as info;
SELECT 
    name,
    email,
    role,
    status,
    created_at
FROM users 
WHERE email LIKE '%@test.eventu.com'
ORDER BY role, name;

SELECT 'Eventos asignados a organizadores:' as info;
SELECT 
    e.title,
    e.date,
    u.name as organizer_name,
    u.email as organizer_email
FROM events e
JOIN users u ON e.organizer_id = u.id
WHERE u.email LIKE '%@test.eventu.com'
ORDER BY u.name, e.date;

SELECT 'Ventas de usuarios de prueba:' as info;
SELECT 
    s.buyer_name,
    s.buyer_email,
    e.title as event_title,
    s.quantity,
    s.amount,
    s.status,
    s.checked_in
FROM sales s
JOIN events e ON s.event_id = e.id
WHERE s.buyer_email LIKE '%@test.eventu.com'
ORDER BY s.buyer_name, s.created_at;

-- Información de acceso para pruebas
SELECT '=== INFORMACIÓN DE ACCESO PARA PRUEBAS ===' as info;
SELECT 
    'Email: ' || email || ' | Rol: ' || role || ' | Contraseña: test123' as credentials
FROM users 
WHERE email LIKE '%@test.eventu.com'
ORDER BY role, email;

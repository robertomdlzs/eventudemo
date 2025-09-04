-- Script corregido para insertar datos de prueba en la base de datos PostgreSQL
-- Ejecutar después de crear las tablas con los scripts anteriores

-- Limpiar datos existentes (opcional - comentar si no se desea)
-- DELETE FROM tickets;
-- DELETE FROM payments;
-- DELETE FROM sales;
-- DELETE FROM ticket_types;
-- DELETE FROM events;
-- DELETE FROM seat_maps;
-- DELETE FROM categories;
-- DELETE FROM users;

-- Insertar usuarios de prueba
INSERT INTO users (first_name, last_name, email, password_hash, role, status, phone, created_at, email_verified_at) VALUES
('Juan', 'Pérez', 'juan.perez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active', '+57 300 123 4567', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('María', 'García', 'maria.garcia@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', '+57 300 234 5678', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Carlos', 'López', 'carlos.lopez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active', '+57 300 345 6789', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Ana', 'Martínez', 'ana.martinez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', '+57 300 456 7890', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Luis', 'Rodríguez', 'luis.rodriguez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', '+57 300 567 8901', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Sofía', 'Hernández', 'sofia.hernandez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', '+57 300 678 9012', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Diego', 'González', 'diego.gonzalez@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', '+57 300 789 0123', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Valentina', 'Díaz', 'valentina.diaz@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active', '+57 300 890 1234', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insertar categorías de eventos (con slug)
INSERT INTO categories (name, slug, description, color, icon, created_at) VALUES
('Música', 'musica', 'Conciertos, festivales y eventos musicales', '#FF6B6B', 'music', CURRENT_TIMESTAMP),
('Deportes', 'deportes', 'Eventos deportivos y competencias', '#4ECDC4', 'sports', CURRENT_TIMESTAMP),
('Tecnología', 'tecnologia', 'Conferencias, hackathons y eventos tech', '#45B7D1', 'tech', CURRENT_TIMESTAMP),
('Arte y Cultura', 'arte-y-cultura', 'Exposiciones, teatro y eventos culturales', '#96CEB4', 'art', CURRENT_TIMESTAMP),
('Negocios', 'negocios', 'Conferencias, networking y eventos empresariales', '#FFEAA7', 'business', CURRENT_TIMESTAMP),
('Educación', 'educacion', 'Seminarios, talleres y eventos educativos', '#DDA0DD', 'education', CURRENT_TIMESTAMP),
('Entretenimiento', 'entretenimiento', 'Shows, comedia y eventos de entretenimiento', '#FFB347', 'entertainment', CURRENT_TIMESTAMP),
('Gastronomía', 'gastronomia', 'Festivales de comida y eventos culinarios', '#98D8C8', 'food', CURRENT_TIMESTAMP);

-- Insertar mapas de asientos (con estructura correcta)
INSERT INTO seat_maps (name, venue_name, total_capacity, map_data, created_at) VALUES
('Arena Central', 'Parque Simón Bolívar', 5000, '{"sections": [{"name": "VIP", "rows": 10, "seats_per_row": 20}, {"name": "General", "rows": 50, "seats_per_row": 80}]}', CURRENT_TIMESTAMP),
('Teatro Clásico', 'Teatro Colón', 800, '{"sections": [{"name": "Platea", "rows": 15, "seats_per_row": 25}, {"name": "Balcón", "rows": 8, "seats_per_row": 30}]}', CURRENT_TIMESTAMP),
('Auditorio Moderno', 'Centro de Convenciones Ágora', 800, '{"sections": [{"name": "Principal", "rows": 20, "seats_per_row": 40}]}', CURRENT_TIMESTAMP),
('Estadio Deportivo', 'Estadio El Campín', 36000, '{"sections": [{"name": "Norte", "rows": 30, "seats_per_row": 100}, {"name": "Sur", "rows": 30, "seats_per_row": 100}, {"name": "Este", "rows": 25, "seats_per_row": 80}, {"name": "Oeste", "rows": 25, "seats_per_row": 80}]}', CURRENT_TIMESTAMP),
('Sala de Conferencias', 'Hotel Intercontinental', 500, '{"sections": [{"name": "Principal", "rows": 12, "seats_per_row": 15}]}', CURRENT_TIMESTAMP);

-- Insertar eventos
INSERT INTO events (title, slug, description, long_description, date, time, venue, location, category_id, organizer_id, total_capacity, price, status, sales_start_date, sales_end_date, youtube_url, image_url, featured, seat_map_id, created_at) VALUES
('Festival de Música Rock 2025', 'festival-musica-rock-2025', 'El evento musical más grande del año con las mejores bandas de rock', 'Un festival épico que reunirá a las mejores bandas de rock nacionales e internacionales. Tres días de música, comida y diversión en el corazón de Bogotá. Incluye zona VIP, food trucks y actividades complementarias.', '2025-03-15', '18:00', 'Parque Simón Bolívar', 'Bogotá', 1, 2, 5000, 150000, 'published', '2024-12-01', '2025-03-10', 'https://youtube.com/watch?v=example1', '/images/rock-festival.jpg', true, 1, CURRENT_TIMESTAMP),
('Conferencia de Tecnología Innovación 2025', 'conferencia-tecnologia-innovacion-2025', 'La conferencia más importante de tecnología e innovación', 'Únete a los líderes de la industria tecnológica en esta conferencia de tres días. Networking, charlas inspiradoras y las últimas tendencias en tecnología. Incluye workshops prácticos y zona de exhibición.', '2025-02-20', '09:00', 'Centro de Convenciones Ágora', 'Bogotá', 3, 3, 800, 250000, 'published', '2024-11-15', '2025-02-15', 'https://youtube.com/watch?v=example2', '/images/tech-conference.jpg', true, 3, CURRENT_TIMESTAMP),
('Clásico Nacional de Fútbol', 'clasico-nacional-futbol-2025', 'El partido más esperado del año', 'El clásico entre los dos equipos más grandes del país. Una noche llena de emoción, pasión y fútbol de la más alta calidad. No te pierdas este espectáculo deportivo.', '2025-04-10', '20:00', 'Estadio El Campín', 'Bogotá', 2, 2, 36000, 80000, 'published', '2024-12-20', '2025-04-05', 'https://youtube.com/watch?v=example3', '/images/soccer-match.jpg', false, 4, CURRENT_TIMESTAMP),
('Exposición de Arte Contemporáneo', 'exposicion-arte-contemporaneo-2025', 'Una muestra de los mejores artistas contemporáneos', 'Explora las obras más innovadoras del arte contemporáneo colombiano e internacional. Incluye instalaciones interactivas, performances en vivo y charlas con los artistas.', '2025-01-25', '10:00', 'Museo de Arte Moderno', 'Bogotá', 4, 3, 300, 45000, 'published', '2024-11-01', '2025-01-20', 'https://youtube.com/watch?v=example4', '/images/art-exhibition.jpg', false, 2, CURRENT_TIMESTAMP),
('Cumbre Empresarial Latinoamericana', 'cumbre-empresarial-latinoamericana-2025', 'El evento empresarial más importante de la región', 'Reúne a los líderes empresariales más influyentes de Latinoamérica. Networking de alto nivel, charlas magistrales y oportunidades de negocio únicas.', '2025-05-15', '08:00', 'Hotel Intercontinental', 'Bogotá', 5, 2, 500, 350000, 'published', '2024-12-01', '2025-05-10', 'https://youtube.com/watch?v=example5', '/images/business-summit.jpg', true, 5, CURRENT_TIMESTAMP),
('Festival Gastronómico Bogotá', 'festival-gastronomico-bogota-2025', 'Los mejores sabores de Colombia', 'Un viaje culinario por los sabores más auténticos de Colombia. Chefs reconocidos, degustaciones, talleres de cocina y la mejor gastronomía nacional.', '2025-06-20', '12:00', 'Plaza de Bolívar', 'Bogotá', 8, 3, 2000, 75000, 'published', '2025-01-15', '2025-06-15', 'https://youtube.com/watch?v=example6', '/images/food-festival.jpg', false, NULL, CURRENT_TIMESTAMP),
('Concierto Sinfónico Beethoven', 'concierto-sinfonico-beethoven-2025', 'La Novena Sinfonía en todo su esplendor', 'La Orquesta Sinfónica Nacional interpreta las obras más importantes de Beethoven. Una noche de música clásica en un ambiente elegante.', '2025-07-10', '19:30', 'Teatro Colón', 'Bogotá', 1, 2, 800, 120000, 'published', '2025-02-01', '2025-07-05', 'https://youtube.com/watch?v=example7', '/images/symphony-concert.jpg', false, 2, CURRENT_TIMESTAMP),
('Maratón de Bogotá 2025', 'maraton-bogota-2025', 'La carrera más importante de la ciudad', 'Participa en la maratón más grande de Bogotá. Recorrido por los lugares más emblemáticos de la ciudad. Categorías para todos los niveles.', '2025-08-15', '06:00', 'Parque Metropolitano', 'Bogotá', 2, 3, 10000, 35000, 'published', '2025-03-01', '2025-08-10', 'https://youtube.com/watch?v=example8', '/images/marathon.jpg', false, NULL, CURRENT_TIMESTAMP);

-- Insertar tipos de boletos (con estructura correcta)
INSERT INTO ticket_types (event_id, name, description, price, quantity, max_per_order, created_at) VALUES
(1, 'VIP', 'Acceso VIP con asientos preferenciales, bebidas incluidas y meet & greet', 250000, 200, 4, CURRENT_TIMESTAMP),
(1, 'General', 'Acceso general al festival', 150000, 4800, 10, CURRENT_TIMESTAMP),
(2, 'Premium', 'Acceso completo a la conferencia con networking exclusivo', 350000, 100, 2, CURRENT_TIMESTAMP),
(2, 'Estándar', 'Acceso a charlas y exhibición', 250000, 700, 5, CURRENT_TIMESTAMP),
(3, 'Preferencial', 'Asientos en las mejores ubicaciones del estadio', 120000, 5000, 6, CURRENT_TIMESTAMP),
(3, 'General', 'Asientos generales del estadio', 80000, 31000, 10, CURRENT_TIMESTAMP),
(4, 'Guía Incluida', 'Entrada con tour guiado por expertos', 65000, 100, 4, CURRENT_TIMESTAMP),
(4, 'General', 'Entrada general a la exposición', 45000, 200, 6, CURRENT_TIMESTAMP),
(5, 'VIP Executive', 'Acceso VIP con networking exclusivo y cena de gala', 500000, 50, 2, CURRENT_TIMESTAMP),
(5, 'Profesional', 'Acceso completo a la cumbre', 350000, 450, 3, CURRENT_TIMESTAMP),
(6, 'Gourmet', 'Acceso completo con degustaciones premium', 120000, 300, 4, CURRENT_TIMESTAMP),
(6, 'General', 'Acceso general al festival', 75000, 1700, 8, CURRENT_TIMESTAMP),
(7, 'Palco', 'Asientos en palco con servicio de bebidas', 180000, 100, 4, CURRENT_TIMESTAMP),
(7, 'Platea', 'Asientos en platea del teatro', 120000, 700, 6, CURRENT_TIMESTAMP),
(8, 'Elite', 'Kit completo de corredor con beneficios especiales', 50000, 500, 2, CURRENT_TIMESTAMP),
(8, 'General', 'Inscripción general a la maratón', 35000, 9500, 1, CURRENT_TIMESTAMP);

-- Insertar ventas (con estructura correcta)
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone, created_at) VALUES
(4, 1, 1, 2, 250000, 500000, 'completed', 'credit_card', 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-15 14:30:00'),
(5, 1, 2, 4, 150000, 600000, 'completed', 'credit_card', 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-16 10:15:00'),
(6, 2, 3, 1, 350000, 350000, 'completed', 'bank_transfer', 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-17 16:45:00'),
(7, 2, 4, 2, 250000, 500000, 'completed', 'credit_card', 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-18 11:20:00'),
(4, 3, 5, 3, 120000, 360000, 'completed', 'credit_card', 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-19 09:30:00'),
(8, 3, 6, 2, 80000, 160000, 'completed', 'credit_card', 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-20 15:45:00'),
(5, 4, 7, 1, 65000, 65000, 'completed', 'cash', 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-21 13:15:00'),
(6, 4, 8, 2, 45000, 90000, 'completed', 'credit_card', 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-22 17:30:00'),
(7, 5, 9, 1, 500000, 500000, 'completed', 'bank_transfer', 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-23 08:45:00'),
(8, 5, 10, 2, 350000, 700000, 'completed', 'credit_card', 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-24 12:00:00'),
(4, 6, 11, 3, 120000, 360000, 'completed', 'credit_card', 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-25 14:20:00'),
(5, 6, 12, 4, 75000, 300000, 'completed', 'credit_card', 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-26 10:30:00'),
(6, 7, 13, 2, 180000, 360000, 'completed', 'credit_card', 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2024-12-27 16:15:00'),
(7, 7, 14, 1, 120000, 120000, 'completed', 'cash', 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2024-12-28 19:45:00'),
(8, 8, 15, 1, 50000, 50000, 'completed', 'credit_card', 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2024-12-29 07:30:00'),
(4, 8, 16, 1, 35000, 35000, 'completed', 'credit_card', 'Ana Martínez', 'ana.martinez@eventu.com', '+57 300 456 7890', '2024-12-30 11:20:00'),
(5, 1, 1, 1, 250000, 250000, 'pending', 'credit_card', 'Luis Rodríguez', 'luis.rodriguez@eventu.com', '+57 300 567 8901', '2024-12-31 14:10:00'),
(6, 2, 4, 1, 250000, 250000, 'pending', 'bank_transfer', 'Sofía Hernández', 'sofia.hernandez@eventu.com', '+57 300 678 9012', '2025-01-01 09:25:00'),
(7, 3, 6, 2, 80000, 160000, 'cancelled', 'credit_card', 'Diego González', 'diego.gonzalez@eventu.com', '+57 300 789 0123', '2025-01-02 16:40:00'),
(8, 4, 8, 1, 45000, 45000, 'completed', 'cash', 'Valentina Díaz', 'valentina.diaz@eventu.com', '+57 300 890 1234', '2025-01-03 13:55:00');

-- Insertar pagos (con estructura correcta)
INSERT INTO payments (sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, status, gateway_response, created_at) VALUES
(1, 'credit_card', 'stripe', 'ch_1234567890', 500000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567890"}', '2024-12-15 14:32:00'),
(2, 'credit_card', 'stripe', 'ch_1234567891', 600000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567891"}', '2024-12-16 10:17:00'),
(3, 'bank_transfer', 'payu', 'payu_123456', 350000, 'completed', '{"gateway": "payu", "transaction_id": "payu_123456"}', '2024-12-17 16:47:00'),
(4, 'credit_card', 'stripe', 'ch_1234567892', 500000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567892"}', '2024-12-18 11:22:00'),
(5, 'credit_card', 'stripe', 'ch_1234567893', 360000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567893"}', '2024-12-19 09:32:00'),
(6, 'credit_card', 'stripe', 'ch_1234567894', 160000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567894"}', '2024-12-20 15:47:00'),
(7, 'cash', 'cash', 'CASH-001', 65000, 'completed', '{"gateway": "cash", "receipt": "CASH-001"}', '2024-12-21 13:17:00'),
(8, 'credit_card', 'stripe', 'ch_1234567895', 90000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567895"}', '2024-12-22 17:32:00'),
(9, 'bank_transfer', 'payu', 'payu_123457', 500000, 'completed', '{"gateway": "payu", "transaction_id": "payu_123457"}', '2024-12-23 08:47:00'),
(10, 'credit_card', 'stripe', 'ch_1234567896', 700000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567896"}', '2024-12-24 12:02:00'),
(11, 'credit_card', 'stripe', 'ch_1234567897', 360000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567897"}', '2024-12-25 14:22:00'),
(12, 'credit_card', 'stripe', 'ch_1234567898', 300000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567898"}', '2024-12-26 10:32:00'),
(13, 'credit_card', 'stripe', 'ch_1234567899', 360000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567899"}', '2024-12-27 16:17:00'),
(14, 'cash', 'cash', 'CASH-002', 120000, 'completed', '{"gateway": "cash", "receipt": "CASH-002"}', '2024-12-28 19:47:00'),
(15, 'credit_card', 'stripe', 'ch_1234567900', 50000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567900"}', '2024-12-29 07:32:00'),
(16, 'credit_card', 'stripe', 'ch_1234567901', 35000, 'completed', '{"gateway": "stripe", "charge_id": "ch_1234567901"}', '2024-12-30 11:22:00'),
(20, 'cash', 'cash', 'CASH-003', 45000, 'completed', '{"gateway": "cash", "receipt": "CASH-003"}', '2025-01-03 13:57:00');

-- Insertar boletos (con estructura correcta)
INSERT INTO tickets (sale_id, ticket_code, status, created_at) VALUES
(1, 'TKT-001-001', 'valid', '2024-12-15 14:32:00'),
(1, 'TKT-001-002', 'valid', '2024-12-15 14:32:00'),
(2, 'TKT-002-001', 'valid', '2024-12-16 10:17:00'),
(2, 'TKT-002-002', 'valid', '2024-12-16 10:17:00'),
(2, 'TKT-002-003', 'valid', '2024-12-16 10:17:00'),
(2, 'TKT-002-004', 'valid', '2024-12-16 10:17:00'),
(3, 'TKT-003-001', 'valid', '2024-12-17 16:47:00'),
(4, 'TKT-004-001', 'valid', '2024-12-18 11:22:00'),
(4, 'TKT-004-002', 'valid', '2024-12-18 11:22:00'),
(5, 'TKT-005-001', 'valid', '2024-12-19 09:32:00'),
(5, 'TKT-005-002', 'valid', '2024-12-19 09:32:00'),
(5, 'TKT-005-003', 'valid', '2024-12-19 09:32:00'),
(6, 'TKT-006-001', 'valid', '2024-12-20 15:47:00'),
(6, 'TKT-006-002', 'valid', '2024-12-20 15:47:00'),
(7, 'TKT-007-001', 'valid', '2024-12-21 13:17:00'),
(8, 'TKT-008-001', 'valid', '2024-12-22 17:32:00'),
(8, 'TKT-008-002', 'valid', '2024-12-22 17:32:00'),
(9, 'TKT-009-001', 'valid', '2024-12-23 08:47:00'),
(10, 'TKT-010-001', 'valid', '2024-12-24 12:02:00'),
(10, 'TKT-010-002', 'valid', '2024-12-24 12:02:00'),
(11, 'TKT-011-001', 'valid', '2024-12-25 14:22:00'),
(11, 'TKT-011-002', 'valid', '2024-12-25 14:22:00'),
(11, 'TKT-011-003', 'valid', '2024-12-25 14:22:00'),
(12, 'TKT-012-001', 'valid', '2024-12-26 10:32:00'),
(12, 'TKT-012-002', 'valid', '2024-12-26 10:32:00'),
(12, 'TKT-012-003', 'valid', '2024-12-26 10:32:00'),
(12, 'TKT-012-004', 'valid', '2024-12-26 10:32:00'),
(13, 'TKT-013-001', 'valid', '2024-12-27 16:17:00'),
(13, 'TKT-013-002', 'valid', '2024-12-27 16:17:00'),
(14, 'TKT-014-001', 'valid', '2024-12-28 19:47:00'),
(15, 'TKT-015-001', 'valid', '2024-12-29 07:32:00'),
(16, 'TKT-016-001', 'valid', '2024-12-30 11:22:00'),
(20, 'TKT-020-001', 'valid', '2025-01-03 13:57:00');

-- Mostrar resumen de datos insertados
SELECT 'Usuarios insertados:' as tipo, COUNT(*) as cantidad FROM users
UNION ALL
SELECT 'Categorías insertadas:', COUNT(*) FROM categories
UNION ALL
SELECT 'Mapas de asientos insertados:', COUNT(*) FROM seat_maps
UNION ALL
SELECT 'Eventos insertados:', COUNT(*) FROM events
UNION ALL
SELECT 'Tipos de boletos insertados:', COUNT(*) FROM ticket_types
UNION ALL
SELECT 'Ventas insertadas:', COUNT(*) FROM sales
UNION ALL
SELECT 'Pagos insertados:', COUNT(*) FROM payments
UNION ALL
SELECT 'Boletos insertados:', COUNT(*) FROM tickets;

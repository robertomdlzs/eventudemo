-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS REALES - EVENTU (PARTE 2)
-- =====================================================
-- Continuación del script principal con secciones, asientos y tickets
-- =====================================================

USE eventu_db;

-- =====================================================
-- INSERCIÓN DE SECCIONES DE MAPA DE ASIENTOS REALES
-- =====================================================

-- Secciones para el Festival de Rock (Autódromo Hermanos Rodríguez)
INSERT INTO seat_map_sections (id, event_id, name, type, x_position, y_position, width, height, capacity, price, color, rows_count, seats_per_row, description, category, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'VIP Premium Front Stage', 'vip', 150, 50, 300, 200, 800, 3500.00, '#FFD700', 20, 40, 'Asientos VIP en primera fila frente al escenario principal con acceso exclusivo a área de descanso, bar premium y meet & greet con artistas', 'vip', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'VIP Gold', 'vip', 150, 300, 400, 250, 1200, 2800.00, '#FFA500', 25, 48, 'Asientos VIP con vista privilegiada del escenario, acceso a zona VIP con food & beverage incluido', 'vip', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'General A - Zona Central', 'seats', 200, 600, 500, 300, 2000, 1200.00, '#4CAF50', 40, 50, 'Asientos generales en zona central con excelente vista del escenario', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'General B - Zona Lateral', 'seats', 100, 600, 300, 300, 1500, 900.00, '#2196F3', 30, 50, 'Asientos generales en zona lateral con buena vista del escenario', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'General C - Zona Alta', 'seats', 200, 950, 500, 200, 1800, 600.00, '#9C27B0', 20, 90, 'Asientos generales en zona alta con vista panorámica del evento', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'Accesible - Zona Adaptada', 'accessible', 50, 400, 200, 150, 300, 800.00, '#795548', 15, 20, 'Asientos adaptados para usuarios con discapacidades con acceso directo y acompañante incluido', 'accessible', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'Standing Room - Pista', 'general', 300, 50, 400, 100, 1000, 400.00, '#607D8B', 1, 1000, 'Área de pie en pista para disfrutar del concierto de cerca', 'economy', NOW(), NOW());

-- Secciones para la Conferencia de Tecnología (Cintermex)
INSERT INTO seat_map_sections (id, event_id, name, type, x_position, y_position, width, height, capacity, price, color, rows_count, seats_per_row, description, category, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Auditorio Principal - Planta Baja', 'seats', 100, 100, 600, 400, 800, 1800.00, '#FF5722', 32, 25, 'Auditorio principal con equipamiento audiovisual de última generación y traducción simultánea', 'business', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Auditorio Principal - Balcón', 'seats', 100, 550, 600, 200, 400, 1500.00, '#E91E63', 20, 20, 'Balcón del auditorio principal con vista privilegiada', 'business', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Sala VIP - Networking', 'vip', 50, 50, 200, 150, 150, 2500.00, '#FFD700', 15, 10, 'Sala VIP exclusiva con networking premium, coffee breaks gourmet y acceso a speakers', 'vip', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Workshop A - Inteligencia Artificial', 'seats', 800, 100, 250, 200, 200, 1200.00, '#4CAF50', 20, 10, 'Sala de workshop especializada en Inteligencia Artificial y Machine Learning', 'business', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Workshop B - Blockchain', 'seats', 800, 350, 250, 200, 200, 1200.00, '#2196F3', 20, 10, 'Sala de workshop especializada en Blockchain y Criptomonedas', 'business', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Workshop C - Cloud Computing', 'seats', 800, 600, 250, 200, 200, 1200.00, '#9C27B0', 20, 10, 'Sala de workshop especializada en Cloud Computing y DevOps', 'business', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Área de Exposición - Stands', 'general', 100, 800, 600, 150, 300, 600.00, '#795548', 1, 300, 'Área de exposición con stands de empresas tecnológicas y startups', 'economy', NOW(), NOW());

-- Secciones para el Partido de Fútbol (Estadio Azteca)
INSERT INTO seat_map_sections (id, event_id, name, type, x_position, y_position, width, height, capacity, price, color, rows_count, seats_per_row, description, category, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'Palco VIP - Tribuna Norte', 'vip', 100, 50, 200, 150, 200, 5000.00, '#FFD700', 10, 20, 'Palco VIP con servicio de catering, bar premium y vista privilegiada del campo', 'vip', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'Palco VIP - Tribuna Sur', 'vip', 100, 200, 200, 150, 200, 5000.00, '#FFD700', 10, 20, 'Palco VIP con servicio de catering, bar premium y vista privilegiada del campo', 'vip', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'Preferente - Tribuna Norte', 'seats', 100, 400, 300, 200, 1500, 1800.00, '#4CAF50', 30, 50, 'Asientos preferentes en tribuna norte con excelente vista del campo', 'premium', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'Preferente - Tribuna Sur', 'seats', 100, 650, 300, 200, 1500, 1800.00, '#4CAF50', 30, 50, 'Asientos preferentes en tribuna sur con excelente vista del campo', 'premium', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'General - Tribuna Norte', 'seats', 100, 700, 400, 300, 2000, 1200.00, '#2196F3', 40, 50, 'Asientos generales en tribuna norte con buena vista del campo', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'General - Tribuna Sur', 'seats', 100, 1050, 400, 300, 2000, 1200.00, '#2196F3', 40, 50, 'Asientos generales en tribuna sur con buena vista del campo', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'General - Tribuna Este', 'seats', 600, 100, 200, 400, 800, 800.00, '#9C27B0', 50, 16, 'Asientos generales en tribuna este con vista lateral del campo', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'General - Tribuna Oeste', 'seats', 50, 100, 200, 400, 800, 800.00, '#9C27B0', 50, 16, 'Asientos generales en tribuna oeste con vista lateral del campo', 'economy', NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 'Accesible - Zona Adaptada', 'accessible', 50, 500, 150, 100, 100, 600.00, '#795548', 10, 10, 'Asientos adaptados para usuarios con discapacidades con acceso directo', 'accessible', NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE ASIENTOS INDIVIDUALES REALES
-- =====================================================

-- Asientos VIP para el Festival de Rock (primeras 3 filas)
INSERT INTO seats (id, section_id, row_letter, seat_number, x_position, y_position, status, price, type, is_wheelchair_accessible, has_extra_legroom, is_aisle_seat, is_window_seat, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'A', 1, 160, 60, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'A', 2, 165, 60, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'A', 3, 170, 60, 'available', 3500.00, 'vip', FALSE, TRUE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'A', 4, 175, 60, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'A', 5, 180, 60, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, TRUE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'B', 1, 160, 80, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'B', 2, 165, 80, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'B', 3, 170, 80, 'available', 3500.00, 'vip', FALSE, TRUE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'B', 4, 175, 80, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1), 'B', 5, 180, 80, 'available', 3500.00, 'vip', FALSE, TRUE, FALSE, TRUE, NOW(), NOW());

-- Asientos generales para el Festival de Rock (primeras 2 filas)
INSERT INTO seats (id, section_id, row_letter, seat_number, x_position, y_position, status, price, type, is_wheelchair_accessible, has_extra_legroom, is_aisle_seat, is_window_seat, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'A', 1, 210, 610, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'A', 2, 215, 610, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'A', 3, 220, 610, 'available', 1200.00, 'regular', FALSE, FALSE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'A', 4, 225, 610, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'A', 5, 230, 610, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, TRUE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'B', 1, 210, 630, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'B', 2, 215, 630, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'B', 3, 220, 630, 'available', 1200.00, 'regular', FALSE, FALSE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'B', 4, 225, 630, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1), 'B', 5, 230, 630, 'available', 1200.00, 'regular', FALSE, FALSE, FALSE, TRUE, NOW(), NOW());

-- Asientos accesibles para el Festival de Rock
INSERT INTO seats (id, section_id, row_letter, seat_number, x_position, y_position, status, price, type, is_wheelchair_accessible, has_extra_legroom, is_aisle_seat, is_window_seat, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'A', 1, 60, 410, 'available', 800.00, 'accessible', TRUE, TRUE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'A', 2, 65, 410, 'available', 800.00, 'accessible', TRUE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'A', 3, 70, 410, 'available', 800.00, 'accessible', TRUE, TRUE, FALSE, TRUE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'B', 1, 60, 430, 'available', 800.00, 'accessible', TRUE, TRUE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'B', 2, 65, 430, 'available', 800.00, 'accessible', TRUE, TRUE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Accesible - Zona Adaptada' LIMIT 1), 'B', 3, 70, 430, 'available', 800.00, 'accessible', TRUE, TRUE, FALSE, TRUE, NOW(), NOW());

-- Asientos para la Conferencia de Tecnología
INSERT INTO seats (id, section_id, row_letter, seat_number, x_position, y_position, status, price, type, is_wheelchair_accessible, has_extra_legroom, is_aisle_seat, is_window_seat, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'A', 1, 110, 110, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'A', 2, 115, 110, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'A', 3, 120, 110, 'available', 1800.00, 'regular', FALSE, FALSE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'A', 4, 125, 110, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'A', 5, 130, 110, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, TRUE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'B', 1, 110, 130, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'B', 2, 115, 130, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'B', 3, 120, 130, 'available', 1800.00, 'regular', FALSE, FALSE, TRUE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'B', 4, 125, 130, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, FALSE, NOW(), NOW()),
(UUID(), (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1), 'B', 5, 130, 130, 'available', 1800.00, 'regular', FALSE, FALSE, FALSE, TRUE, NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE TICKETS REALES
-- =====================================================

-- Ticket VIP vendido para el Festival de Rock
INSERT INTO physical_tickets (id, event_id, user_id, seat_id, ticket_number, qr_code, status, price, discount_amount, final_price, currency, issue_date, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), (SELECT id FROM users WHERE email = 'luis.hernandez@gmail.com' LIMIT 1), (SELECT id FROM seats WHERE section_id = (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1) AND row_letter = 'A' AND seat_number = 1 LIMIT 1), 'TKT-ROCK-2025-001', 'eyJ0eXBlIjoiUVJDb2RlIiwidGlja2V0SWQiOiJyb2NrLTIwMjUtMDAxIiwidXNlcklkIjoibHVpcy1oZXJuYW5kZXoiLCJldmVudElkIjoicm9jay1lbi1sYS1ub2NoZS0yMDI1IiwiaXNzdWVkQXQiOiIyMDI1LTAxLTE1VDEwOjAwOjAwWiJ9', 'issued', 3500.00, 0.00, 3500.00, 'MXN', '2025-01-15 10:00:00', NOW(), NOW());

-- Ticket general vendido para el Festival de Rock
INSERT INTO physical_tickets (id, event_id, user_id, seat_id, ticket_number, qr_code, status, price, discount_amount, final_price, currency, issue_date, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), (SELECT id FROM users WHERE email = 'sofia.lopez@hotmail.com' LIMIT 1), (SELECT id FROM seats WHERE section_id = (SELECT id FROM seat_map_sections WHERE name = 'General A - Zona Central' LIMIT 1) AND row_letter = 'A' AND seat_number = 1 LIMIT 1), 'TKT-ROCK-2025-002', 'eyJ0eXBlIjoiUVJDb2RlIiwidGlja2V0SWQiOiJyb2NrLTIwMjUtMDAyIiwidXNlcklkIjoic29maWEtbG9wZXoiLCJldmVudElkIjoicm9jay1lbi1sYS1ub2NoZS0yMDI1IiwiaXNzdWVkQXQiOiIyMDI1LTAxLTE2VDE0OjMwOjAwWiJ9', 'issued', 1200.00, 150.00, 1050.00, 'MXN', '2025-01-16 14:30:00', NOW(), NOW());

-- Ticket para la Conferencia de Tecnología
INSERT INTO physical_tickets (id, event_id, user_id, seat_id, ticket_number, qr_code, status, price, discount_amount, final_price, currency, issue_date, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), (SELECT id FROM users WHERE email = 'juan.perez@yahoo.com' LIMIT 1), (SELECT id FROM seats WHERE section_id = (SELECT id FROM seat_map_sections WHERE name = 'Auditorio Principal - Planta Baja' LIMIT 1) AND row_letter = 'A' AND seat_number = 1 LIMIT 1), 'TKT-TECH-2025-001', 'eyJ0eXBlIjoiUVJDb2RlIiwidGlja2V0SWQiOiJ0ZWNoLTIwMjUtMDAxIiwidXNlcklkIjoianVhbi1wZXJleiIsImV2ZW50SWQiOiJ0ZWNoLXN1bW1pdC1tZXhpY28tMjAyNSIsImlzc3VlZEF0IjoiMjAyNS0wMS0xN1QwOToxNTowMFoifQ==', 'issued', 1800.00, 0.00, 1800.00, 'MXN', '2025-01-17 09:15:00', NOW(), NOW());

-- =====================================================
-- FIN DE LA SEGUNDA PARTE - SECCIONES, ASIENTOS Y TICKETS
-- =====================================================

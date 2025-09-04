-- Insert sample users
INSERT INTO users (first_name, last_name, email, password_hash, role, status) VALUES
('Admin', 'Sistema', 'admin@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 'active'),
('Carlos', 'Rodríguez', 'carlos@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active'),
('María', 'González', 'maria@eventu.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'organizer', 'active'),
('Juan', 'Pérez', 'juan@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active'),
('Ana', 'López', 'ana@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', 'active');

-- Insert categories
INSERT INTO categories (name, slug, description, icon, color) VALUES
('Conciertos', 'conciertos', 'Eventos musicales y conciertos en vivo', 'Music', '#FF6B6B'),
('Teatro', 'teatro', 'Obras de teatro y espectáculos dramáticos', 'Drama', '#4ECDC4'),
('Deportes', 'deportes', 'Eventos deportivos y competencias', 'Trophy', '#45B7D1'),
('Conferencias', 'conferencias', 'Conferencias, seminarios y eventos corporativos', 'Users', '#96CEB4'),
('Festivales', 'festivales', 'Festivales culturales y gastronómicos', 'Star', '#FFEAA7'),
('Familiar', 'familiar', 'Eventos para toda la familia', 'Heart', '#DDA0DD'),
('Educación', 'educacion', 'Talleres, cursos y eventos educativos', 'BookOpen', '#98D8C8');

-- Insert sample seat map templates
INSERT INTO seat_map_templates (name, description, template_data, is_public, created_by) VALUES
('Teatro Clásico', 'Plantilla para teatro con palcos y platea', '{"sections": [{"id": "platea", "name": "Platea", "type": "seating", "rows": 20, "seatsPerRow": 30, "price": 1.0}, {"id": "palcos", "name": "Palcos", "type": "vip", "capacity": 40, "price": 1.5}]}', TRUE, 1),
('Estadio Deportivo', 'Plantilla para eventos deportivos', '{"sections": [{"id": "tribuna-norte", "name": "Tribuna Norte", "type": "seating", "capacity": 500}, {"id": "tribuna-sur", "name": "Tribuna Sur", "type": "seating", "capacity": 500}, {"id": "vip", "name": "Palco VIP", "type": "vip", "capacity": 100}]}', TRUE, 1),
('Salón de Eventos', 'Plantilla para salones y conferencias', '{"sections": [{"id": "general", "name": "Admisión General", "type": "seating", "capacity": 200}]}', TRUE, 1);

-- Insert sample seat maps
INSERT INTO seat_maps (name, venue_name, total_capacity, map_data, template_id, created_by) VALUES
('Teatro Nacional - Sala Principal', 'Teatro Nacional', 800, '{"sections": [{"id": "platea", "name": "Platea", "capacity": 600, "price": 50000}, {"id": "palcos", "name": "Palcos", "capacity": 200, "price": 75000}]}', 1, 2),
('Coliseo El Campín', 'Coliseo El Campín', 1200, '{"sections": [{"id": "tribuna-norte", "name": "Tribuna Norte", "capacity": 500, "price": 30000}, {"id": "tribuna-sur", "name": "Tribuna Sur", "capacity": 500, "price": 30000}, {"id": "vip", "name": "Palco VIP", "capacity": 200, "price": 80000}]}', 2, 2);

-- Insert sample events
INSERT INTO events (title, slug, description, long_description, date, time, venue, location, category_id, organizer_id, total_capacity, price, status, sales_start_date, youtube_url, image_url, featured, seat_map_id) VALUES
('Concierto Sinfónico de Año Nuevo', 'concierto-sinfonico-ano-nuevo', 'Gran concierto sinfónico para celebrar el año nuevo', 'La Orquesta Sinfónica Nacional presenta un espectacular concierto para recibir el año nuevo con las mejores melodías clásicas y contemporáneas. Una noche mágica llena de música y emociones.', '2024-12-31', '20:00:00', 'Teatro Nacional', 'BOGOTÁ', 1, 2, 800, 50000.00, 'published', '2024-01-01 00:00:00', 'https://youtube.com/watch?v=example1', '/images/concierto-sinfonico.jpg', TRUE, 1),
('Festival Gastronómico Internacional', 'festival-gastronomico-internacional', 'Festival con los mejores chefs internacionales', 'Disfruta de una experiencia culinaria única con chefs reconocidos mundialmente. Degustaciones, talleres y espectáculos gastronómicos en un solo lugar.', '2024-03-15', '18:00:00', 'Centro de Convenciones', 'MEDELLÍN', 5, 2, 500, 80000.00, 'published', '2024-01-15 00:00:00', 'https://youtube.com/watch?v=example2', '/images/festival-gastronomico.jpg', TRUE, NULL),
('Obra: Romeo y Julieta', 'obra-romeo-julieta', 'Clásica obra de Shakespeare', 'La compañía de teatro más prestigiosa del país presenta esta obra maestra de William Shakespeare con una puesta en escena moderna y emotiva.', '2024-02-20', '19:30:00', 'Teatro Colón', 'BOGOTÁ', 2, 3, 400, 35000.00, 'published', '2024-01-10 00:00:00', NULL, '/images/romeo-julieta.jpg', FALSE, NULL),
('Conferencia Tech Summit 2024', 'tech-summit-2024', 'La conferencia de tecnología más importante del año', 'Líderes de la industria tecnológica se reúnen para compartir las últimas tendencias en IA, blockchain, desarrollo web y más. Networking y oportunidades de negocio.', '2024-04-10', '09:00:00', 'Centro Empresarial', 'BOGOTÁ', 4, 2, 300, 120000.00, 'published', '2024-02-01 00:00:00', 'https://youtube.com/watch?v=example3', '/images/tech-summit.jpg', TRUE, NULL),
('Partido Clásico: Millonarios vs Nacional', 'partido-millonarios-nacional', 'El clásico más esperado del fútbol colombiano', 'El encuentro más emocionante del fútbol profesional colombiano. Dos equipos históricos se enfrentan en un partido que promete emociones fuertes.', '2024-03-25', '16:00:00', 'Estadio El Campín', 'BOGOTÁ', 3, 3, 1200, 25000.00, 'published', '2024-02-25 00:00:00', NULL, '/images/clasico-futbol.jpg', TRUE, 2);

-- Insert ticket types
INSERT INTO ticket_types (event_id, name, description, price, quantity, max_per_order) VALUES
(1, 'Platea', 'Asientos en platea principal', 50000.00, 600, 6),
(1, 'Palcos', 'Asientos en palcos VIP', 75000.00, 200, 4),
(2, 'Entrada General', 'Acceso completo al festival', 80000.00, 500, 8),
(3, 'Entrada General', 'Asiento numerado', 35000.00, 400, 6),
(4, 'Early Bird', 'Precio especial por compra anticipada', 100000.00, 100, 2),
(4, 'Entrada Regular', 'Entrada estándar', 120000.00, 200, 4),
(5, 'Tribuna Norte', 'Tribuna Norte del estadio', 25000.00, 500, 10),
(5, 'Tribuna Sur', 'Tribuna Sur del estadio', 25000.00, 500, 10),
(5, 'Palco VIP', 'Palco VIP con servicios premium', 80000.00, 200, 4);

-- Insert sample sales
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone) VALUES
(4, 1, 1, 2, 50000.00, 100000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567'),
(5, 1, 2, 1, 75000.00, 75000.00, 'completed', 'debit_card', 'Ana López', 'ana@example.com', '3007654321'),
(4, 2, 3, 3, 80000.00, 240000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567'),
(5, 4, 5, 1, 100000.00, 100000.00, 'completed', 'bank_transfer', 'Ana López', 'ana@example.com', '3007654321'),
(4, 5, 7, 4, 25000.00, 100000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567');

-- Update sold tickets count
UPDATE ticket_types SET sold = 2 WHERE id = 1;
UPDATE ticket_types SET sold = 1 WHERE id = 2;
UPDATE ticket_types SET sold = 3 WHERE id = 3;
UPDATE ticket_types SET sold = 1 WHERE id = 5;
UPDATE ticket_types SET sold = 4 WHERE id = 7;

-- Insert sample tickets
INSERT INTO tickets (sale_id, ticket_code, status) VALUES
(1, 'TKT-001-001', 'valid'),
(1, 'TKT-001-002', 'valid'),
(2, 'TKT-002-001', 'valid'),
(3, 'TKT-003-001', 'valid'),
(3, 'TKT-003-002', 'valid'),
(3, 'TKT-003-003', 'valid'),
(4, 'TKT-004-001', 'valid'),
(5, 'TKT-005-001', 'valid'),
(5, 'TKT-005-002', 'valid'),
(5, 'TKT-005-003', 'valid'),
(5, 'TKT-005-004', 'valid');

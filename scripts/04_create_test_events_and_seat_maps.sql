USE eventu_db;

-- Insert more test events with different configurations
INSERT INTO events (title, slug, description, long_description, date, time, venue, location, category_id, organizer_id, total_capacity, price, status, sales_start_date, youtube_url, image_url, featured, seat_map_id) VALUES
('Concierto Rock Nacional', 'concierto-rock-nacional', 'Los mejores exponentes del rock colombiano', 'Una noche épica con las bandas más representativas del rock nacional. Desde los clásicos hasta las nuevas propuestas que están revolucionando la escena musical colombiana.', '2024-05-15', '21:00:00', 'Coliseo Live', 'BOGOTÁ', 1, 2, 2000, 45000.00, 'published', '2024-03-01 00:00:00', 'https://youtube.com/watch?v=rock-nacional', '/images/rock-nacional.jpg', TRUE, 2),
('Feria de Emprendimiento Digital', 'feria-emprendimiento-digital', 'Conecta con startups y emprendedores', 'El evento más importante para emprendedores digitales en Colombia. Networking, conferencias magistrales, pitch competitions y oportunidades de inversión.', '2024-04-20', '08:00:00', 'Centro de Convenciones Ágora', 'MEDELLÍN', 4, 3, 800, 75000.00, 'published', '2024-02-15 00:00:00', NULL, '/images/emprendimiento-digital.jpg', TRUE, NULL),
('Festival de Jazz Latinoamericano', 'festival-jazz-latinoamericano', 'Tres días de jazz de clase mundial', 'Los mejores exponentes del jazz latinoamericano se dan cita en este festival único. Artistas de Colombia, Argentina, Brasil, Cuba y México en un solo escenario.', '2024-06-10', '19:00:00', 'Teatro Mayor Julio Mario Santo Domingo', 'BOGOTÁ', 1, 2, 1200, 85000.00, 'published', '2024-04-01 00:00:00', 'https://youtube.com/watch?v=jazz-latino', '/images/jazz-festival.jpg', TRUE, 1),
('Obra: La Casa de Bernarda Alba', 'obra-casa-bernarda-alba', 'Clásico de Federico García Lorca', 'Una magistral puesta en escena de una de las obras más importantes del teatro español. Dirigida por María Elena Sarmiento con un elenco de lujo.', '2024-03-30', '20:00:00', 'Teatro Nacional La Castellana', 'BOGOTÁ', 2, 3, 350, 42000.00, 'published', '2024-02-01 00:00:00', NULL, '/images/bernarda-alba.jpg', FALSE, NULL),
('Torneo de Esports Championship', 'torneo-esports-championship', 'La competencia gamer más grande del país', 'Los mejores equipos de Colombia compiten en League of Legends, Dota 2, Counter-Strike y FIFA. Premios por más de $200 millones de pesos.', '2024-05-25', '10:00:00', 'Movistar Arena', 'BOGOTÁ', 3, 2, 8000, 35000.00, 'published', '2024-03-15 00:00:00', 'https://youtube.com/watch?v=esports-championship', '/images/esports-tournament.jpg', TRUE, 2),
('Seminario de Inteligencia Artificial', 'seminario-inteligencia-artificial', 'El futuro de la IA en América Latina', 'Expertos internacionales comparten las últimas tendencias en IA, Machine Learning y Deep Learning. Incluye talleres prácticos y certificación.', '2024-04-15', '09:00:00', 'Universidad de los Andes', 'BOGOTÁ', 7, 3, 200, 150000.00, 'published', '2024-02-20 00:00:00', NULL, '/images/ai-seminar.jpg', FALSE, NULL);

-- Insert more ticket types for the new events
INSERT INTO ticket_types (event_id, name, description, price, quantity, max_per_order) VALUES
-- Concierto Rock Nacional (event_id = 6)
(6, 'General', 'Acceso general al concierto', 45000.00, 1500, 8),
(6, 'VIP', 'Zona VIP con bar incluido', 85000.00, 300, 4),
(6, 'Palco Premium', 'Palcos con servicio completo', 150000.00, 200, 6),

-- Feria de Emprendimiento Digital (event_id = 7)
(7, 'Emprendedor', 'Acceso completo al evento', 75000.00, 600, 3),
(7, 'Startup', 'Incluye stand de exhibición', 200000.00, 100, 2),
(7, 'Inversor', 'Acceso VIP y networking exclusivo', 350000.00, 100, 2),

-- Festival de Jazz (event_id = 8)
(8, 'Platea', 'Asientos en platea principal', 85000.00, 800, 6),
(8, 'Palcos', 'Palcos con vista privilegiada', 120000.00, 300, 4),
(8, 'Premium', 'Experiencia completa con cena', 200000.00, 100, 2),

-- Obra Bernarda Alba (event_id = 9)
(9, 'General', 'Asientos numerados', 42000.00, 300, 6),
(9, 'Preferencial', 'Mejores ubicaciones', 65000.00, 50, 4),

-- Torneo Esports (event_id = 10)
(10, 'General', 'Acceso general al torneo', 35000.00, 6000, 10),
(10, 'Premium', 'Zona premium con merchandising', 55000.00, 1500, 6),
(10, 'VIP Gamer', 'Meet & greet con jugadores', 95000.00, 500, 4),

-- Seminario IA (event_id = 11)
(11, 'Estudiante', 'Precio especial estudiantes', 100000.00, 100, 2),
(11, 'Profesional', 'Acceso completo y certificado', 150000.00, 80, 3),
(11, 'Empresarial', 'Incluye consultoría personalizada', 250000.00, 20, 1);

-- Insert some sample sales for the new events
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone) VALUES
(4, 6, 13, 2, 45000.00, 90000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567'),
(5, 7, 16, 1, 75000.00, 75000.00, 'completed', 'bank_transfer', 'Ana López', 'ana@example.com', '3007654321'),
(4, 8, 19, 2, 85000.00, 170000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567'),
(5, 10, 25, 4, 35000.00, 140000.00, 'completed', 'debit_card', 'Ana López', 'ana@example.com', '3007654321');

-- Update sold tickets count for new events
UPDATE ticket_types SET sold = 2 WHERE id = 13;
UPDATE ticket_types SET sold = 1 WHERE id = 16;
UPDATE ticket_types SET sold = 2 WHERE id = 19;
UPDATE ticket_types SET sold = 4 WHERE id = 25;

-- Create additional seat map for larger venues
INSERT INTO seat_maps (name, venue_name, total_capacity, map_data, template_id, created_by) VALUES
('Movistar Arena - Configuración Esports', 'Movistar Arena', 8000, '{"sections": [{"id": "general", "name": "General", "capacity": 6000, "price": 35000}, {"id": "premium", "name": "Premium", "capacity": 1500, "price": 55000}, {"id": "vip", "name": "VIP Gamer", "capacity": 500, "price": 95000}]}', 2, 2);

-- Update events to use the new seat map
UPDATE events SET seat_map_id = 3 WHERE id = 10;

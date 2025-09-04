-- Insertar tipos de boletas de prueba
INSERT INTO ticket_types (name, description, is_default, created_at, updated_at) VALUES
('General', 'Boleto de acceso general al evento', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('VIP', 'Boleto VIP con beneficios especiales', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Premium', 'Boleto premium con acceso exclusivo', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Estudiante', 'Boleto con descuento para estudiantes', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Senior', 'Boleto con descuento para adultos mayores', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Niño', 'Boleto para niños menores de 12 años', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Early Bird', 'Boleto con descuento por compra anticipada', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Last Minute', 'Boleto de última hora', false, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Verificar la inserción
SELECT * FROM ticket_types ORDER BY name;

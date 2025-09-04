-- Insert sample ticket types for existing events
INSERT INTO ticket_types (event_id, name, description, price, quantity, max_per_order, status) VALUES
(1, 'General', 'Acceso general al evento', 75000.00, 100, 5, 'active'),
(1, 'VIP', 'Acceso VIP con beneficios especiales', 150000.00, 50, 3, 'active'),
(2, 'Platea', 'Asiento en platea', 85000.00, 80, 4, 'active'),
(2, 'Balcón', 'Asiento en balcón', 65000.00, 120, 6, 'active');

-- Insert sample sales for user 1
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone) VALUES
(1, 1, 1, 2, 75000.00, 150000.00, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567'),
(1, 2, 3, 1, 85000.00, 85000.00, 'completed', 'debit_card', 'Juan Pérez', 'juan@example.com', '3001234567');

-- Insert individual tickets for the sales
INSERT INTO tickets (sale_id, ticket_code, status) VALUES
-- Tickets for sale 1 (Concierto de Rock - 2 tickets)
(1, 'TKT-001-001', 'valid'),
(1, 'TKT-001-002', 'valid'),
-- Tickets for sale 2 (Festival de Jazz - 1 ticket)
(2, 'TKT-002-001', 'valid');

-- Insert sample sales for user 2 (if exists)
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone) VALUES
(2, 1, 2, 1, 150000.00, 150000.00, 'completed', 'credit_card', 'María García', 'maria@example.com', '3009876543');

-- Insert individual tickets for user 2
INSERT INTO tickets (sale_id, ticket_code, status) VALUES
(3, 'TKT-003-001', 'valid');

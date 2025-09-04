-- Insert sample sales for testing purchase history
INSERT INTO sales (user_id, event_id, ticket_type_id, quantity, unit_price, total_amount, status, payment_method, buyer_name, buyer_email, buyer_phone, created_at) VALUES
(1, 1, 1, 2, 75000, 150000, 'completed', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567', CURRENT_TIMESTAMP - INTERVAL '2 days'),
(1, 2, 2, 1, 75000, 75000, 'completed', 'debit_card', 'Juan Pérez', 'juan@example.com', '3001234567', CURRENT_TIMESTAMP - INTERVAL '1 day'),
(1, 3, 1, 1, 200000, 200000, 'pending', 'credit_card', 'Juan Pérez', 'juan@example.com', '3001234567', CURRENT_TIMESTAMP - INTERVAL '6 hours'),
(1, 4, 2, 1, 120000, 120000, 'cancelled', 'bank_transfer', 'Juan Pérez', 'juan@example.com', '3001234567', CURRENT_TIMESTAMP - INTERVAL '12 hours'),
(2, 1, 1, 2, 75000, 150000, 'completed', 'credit_card', 'María García', 'maria@example.com', '3009876543', CURRENT_TIMESTAMP - INTERVAL '3 days'),
(2, 5, 1, 2, 90000, 180000, 'completed', 'debit_card', 'María García', 'maria@example.com', '3009876543', CURRENT_TIMESTAMP - INTERVAL '1 week'),
(3, 2, 2, 1, 75000, 75000, 'cancelled', 'credit_card', 'Carlos López', 'carlos@example.com', '3005555555', CURRENT_TIMESTAMP - INTERVAL '4 days');

-- Insert corresponding payments
INSERT INTO payments (sale_id, payment_method, payment_gateway, gateway_transaction_id, amount, currency, status, processed_at, created_at) VALUES
(1, 'credit_card', 'stripe', 'txn_123456789', 150000, 'COP', 'completed', CURRENT_TIMESTAMP - INTERVAL '2 days' + INTERVAL '5 minutes', CURRENT_TIMESTAMP - INTERVAL '2 days'),
(2, 'debit_card', 'stripe', 'txn_987654321', 75000, 'COP', 'completed', CURRENT_TIMESTAMP - INTERVAL '1 day' + INTERVAL '3 minutes', CURRENT_TIMESTAMP - INTERVAL '1 day'),
(3, 'credit_card', 'stripe', 'txn_555666777', 200000, 'COP', 'pending', NULL, CURRENT_TIMESTAMP - INTERVAL '6 hours'),
(4, 'bank_transfer', 'manual', 'ref_888999000', 120000, 'COP', 'failed', NULL, CURRENT_TIMESTAMP - INTERVAL '12 hours'),
(5, 'credit_card', 'stripe', 'txn_111222333', 150000, 'COP', 'completed', CURRENT_TIMESTAMP - INTERVAL '3 days' + INTERVAL '2 minutes', CURRENT_TIMESTAMP - INTERVAL '3 days'),
(6, 'debit_card', 'stripe', 'txn_444555666', 180000, 'COP', 'completed', CURRENT_TIMESTAMP - INTERVAL '1 week' + INTERVAL '10 minutes', CURRENT_TIMESTAMP - INTERVAL '1 week'),
(7, 'credit_card', 'stripe', 'txn_777888999', 75000, 'COP', 'cancelled', NULL, CURRENT_TIMESTAMP - INTERVAL '4 days');

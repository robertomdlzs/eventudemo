-- Insert sample payments for testing purchase history
INSERT INTO payments (user_id, event_id, amount, currency, payment_method, status, created_at, processed_at) VALUES
(1, 1, 150000, 'COP', 'credit_card', 'completed', CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days' + INTERVAL '5 minutes'),
(1, 2, 75000, 'COP', 'debit_card', 'completed', CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP - INTERVAL '1 day' + INTERVAL '3 minutes'),
(1, 3, 200000, 'COP', 'credit_card', 'pending', CURRENT_TIMESTAMP - INTERVAL '6 hours', NULL),
(1, 4, 120000, 'COP', 'bank_transfer', 'failed', CURRENT_TIMESTAMP - INTERVAL '12 hours', NULL),
(2, 1, 150000, 'COP', 'credit_card', 'completed', CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days' + INTERVAL '2 minutes'),
(2, 5, 180000, 'COP', 'debit_card', 'completed', CURRENT_TIMESTAMP - INTERVAL '1 week', CURRENT_TIMESTAMP - INTERVAL '1 week' + INTERVAL '10 minutes'),
(3, 2, 75000, 'COP', 'credit_card', 'cancelled', CURRENT_TIMESTAMP - INTERVAL '4 days', NULL);

-- Update payments to include event titles (for better display)
UPDATE payments SET 
  event_title = CASE 
    WHEN event_id = 1 THEN 'Concierto Rock Nacional'
    WHEN event_id = 2 THEN 'Torneo de Esports Championship'
    WHEN event_id = 3 THEN 'Festival de Jazz Latinoamericano'
    WHEN event_id = 4 THEN 'Concierto Sinfónico de Año Nuevo'
    WHEN event_id = 5 THEN 'Conferencia de Tecnología 2024'
    ELSE 'Evento #' || event_id
  END
WHERE event_title IS NULL;

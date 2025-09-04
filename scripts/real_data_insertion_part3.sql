-- =====================================================
-- SCRIPT DE INSERCIÓN DE DATOS REALES - EVENTU (PARTE 3)
-- =====================================================
-- Parte final del script con transacciones, descuentos, notificaciones y configuraciones
-- =====================================================

USE eventu_db;

-- =====================================================
-- INSERCIÓN DE RESERVAS DE ASIENTOS REALES
-- =====================================================

-- Reserva activa para el Festival de Rock
INSERT INTO seat_reservations (id, seat_id, user_id, event_id, status, expires_at, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM seats WHERE section_id = (SELECT id FROM seat_map_sections WHERE name = 'VIP Premium Front Stage' LIMIT 1) AND row_letter = 'A' AND seat_number = 2 LIMIT 1), (SELECT id FROM users WHERE email = 'carmen.garcia@outlook.com' LIMIT 1), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'active', DATE_ADD(NOW(), INTERVAL 15 MINUTE), NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE REGLAS DE PRECIOS DINÁMICOS REALES
-- =====================================================

-- Regla de descuento por tiempo para el Festival de Rock
INSERT INTO pricing_rules (id, event_id, name, type, is_active, conditions, price_adjustment, applies_to, priority, confidence, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'Descuento por Compra Anticipada - Early Bird', 'time-based', TRUE, '{"daysBeforeEvent": 90, "minDemand": 0.2, "maxDiscount": 25}', '{"type": "percentage", "value": 25, "maxIncrease": 0, "minPrice": 300}', '{"sectionIds": ["General A - Zona Central", "General B - Zona Lateral", "General C - Zona Alta"], "userTypes": ["new", "returning"]}', 1, 0.95, NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 'Descuento por Demanda - Flash Sale', 'demand-based', TRUE, '{"demandThreshold": 0.3, "salesPercentage": 0.4, "timeWindow": "48h"}', '{"type": "percentage", "value": 15, "maxIncrease": 0, "minPrice": 400}', '{"sectionIds": ["General A - Zona Central", "General B - Zona Lateral"], "userTypes": ["all"]}', 2, 0.90, NOW(), NOW());

-- Regla de descuento por demanda para la Conferencia de Tecnología
INSERT INTO pricing_rules (id, event_id, name, type, is_active, conditions, price_adjustment, applies_to, priority, confidence, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Descuento por Baja Demanda - Workshops', 'demand-based', TRUE, '{"demandThreshold": 0.4, "salesPercentage": 0.3, "minSeats": 50}', '{"type": "percentage", "value": 20, "maxIncrease": 0, "minPrice": 600}', '{"sectionIds": ["Workshop A - Inteligencia Artificial", "Workshop B - Blockchain", "Workshop C - Cloud Computing"], "userTypes": ["student", "startup"]}', 2, 0.88, NOW(), NOW()),
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 'Descuento por Tiempo - Última Hora', 'time-based', TRUE, '{"daysBeforeEvent": 7, "maxDiscount": 30}', '{"type": "percentage", "value": 30, "maxIncrease": 0, "minPrice": 800}', '{"sectionIds": ["Auditorio Principal - Planta Baja", "Auditorio Principal - Balcón"], "userTypes": ["all"]}', 3, 0.85, NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE CONDICIONES DE MERCADO REALES
-- =====================================================

-- Condiciones de mercado para el Festival de Rock
INSERT INTO market_conditions (id, event_id, current_demand, time_to_event, sales_velocity, competitor_prices, seasonality, event_popularity, market_trends, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), 0.78, 156, 38.50, '[2800, 3200, 3000, 3500, 2900]', 0.85, 0.92, '{"trend": "increasing", "factor": "summer_season", "confidence": 0.88}', NOW(), NOW());

-- Condiciones de mercado para la Conferencia de Tecnología
INSERT INTO market_conditions (id, event_id, current_demand, time_to_event, sales_velocity, competitor_prices, seasonality, event_popularity, market_trends, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), 0.52, 182, 18.75, '[1500, 1800, 1600, 2000, 1700]', 0.75, 0.78, '{"trend": "stable", "factor": "tech_industry_growth", "confidence": 0.82}', NOW(), NOW());

-- Condiciones de mercado para el Partido de Fútbol
INSERT INTO market_conditions (id, event_id, current_demand, time_to_event, sales_velocity, competitor_prices, seasonality, event_popularity, market_trends, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM events WHERE slug = 'clasico-nacional-america-vs-chivas-2025' LIMIT 1), 0.95, 214, 67.80, '[1200, 1500, 1800, 2000, 1600]', 0.95, 0.98, '{"trend": "very_high", "factor": "classic_match", "confidence": 0.95}', NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE ARCHIVOS MULTIMEDIA REALES
-- =====================================================

-- Imágenes para el Festival de Rock
INSERT INTO media_files (id, name, original_name, type, size, url, alt_text, description, tags, usage_count, file_hash, mime_type, created_at, updated_at) VALUES
(UUID(), 'rock-festival-2025-banner-main.jpg', 'rock-festival-2025-banner-main.jpg', 'image', 3145728, 'https://cdn.eventu.com/media/events/rock-festival-2025/banner-main.jpg', 'Banner principal del Festival Rock en la Noche 2025', 'Banner oficial del festival con la alineación completa de artistas y fechas', '["rock", "festival", "música", "concierto", "2025", "banner"]', 45, 'sha256:abc123def456ghi789jkl012mno345pqr678stu901vwx234yz', 'image/jpeg', NOW(), NOW()),
(UUID(), 'rock-festival-2025-stage-setup.jpg', 'rock-festival-2025-stage-setup.jpg', 'image', 2097152, 'https://cdn.eventu.com/media/events/rock-festival-2025/stage-setup.jpg', 'Configuración del escenario principal del festival', 'Vista del escenario principal con equipamiento de sonido e iluminación', '["escenario", "festival", "rock", "equipamiento", "sonido", "iluminación"]', 23, 'sha256:def456ghi789jkl012mno345pqr678stu901vwx234yza', 'image/jpeg', NOW(), NOW()),
(UUID(), 'rock-festival-2025-camping-area.jpg', 'rock-festival-2025-camping-area.jpg', 'image', 1835008, 'https://cdn.eventu.com/media/events/rock-festival-2025/camping-area.jpg', 'Área de camping del festival', 'Zona de camping con instalaciones y servicios para los asistentes', '["camping", "festival", "área", "instalaciones", "servicios"]', 18, 'sha256:ghi789jkl012mno345pqr678stu901vwx234yzab', 'image/jpeg', NOW(), NOW());

-- Imágenes para la Conferencia de Tecnología
INSERT INTO media_files (id, name, original_name, type, size, url, alt_text, description, tags, usage_count, file_hash, mime_type, created_at, updated_at) VALUES
(UUID(), 'tech-summit-2025-logo-official.png', 'tech-summit-2025-logo-official.png', 'image', 512000, 'https://cdn.eventu.com/media/events/tech-summit-2025/logo-official.png', 'Logo oficial Tech Summit México 2025', 'Logo corporativo de la conferencia con elementos de innovación y tecnología', '["logo", "tecnología", "conferencia", "innovación", "mexico", "2025"]', 67, 'sha256:jkl012mno345pqr678stu901vwx234yzabc', 'image/png', NOW(), NOW()),
(UUID(), 'tech-summit-2025-venue-cintermex.jpg', 'tech-summit-2025-venue-cintermex.jpg', 'image', 2359296, 'https://cdn.eventu.com/media/events/tech-summit-2025/venue-cintermex.jpg', 'Centro de Convenciones Cintermex', 'Vista exterior del centro de convenciones sede del Tech Summit', '["centro", "convenciones", "cintermex", "monterrey", "tecnología"]', 34, 'sha256:mno345pqr678stu901vwx234yzabcd', 'image/jpeg', NOW(), NOW()),
(UUID(), 'tech-summit-2025-auditorium-main.jpg', 'tech-summit-2025-auditorium-main.jpg', 'image', 2097152, 'https://cdn.eventu.com/media/events/tech-summit-2025/auditorium-main.jpg', 'Auditorio principal del Tech Summit', 'Auditorio principal con capacidad para 800 personas y equipamiento audiovisual', '["auditorio", "conferencia", "tecnología", "equipamiento", "audiovisual"]', 28, 'sha256:pqr678stu901vwx234yzabcde', 'image/jpeg', NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE TRANSACCIONES DE PAGO REALES
-- =====================================================

-- Transacción para el ticket VIP del Festival de Rock
INSERT INTO payment_transactions (id, user_id, event_id, ticket_ids, amount, currency, payment_method, gateway_transaction_id, status, gateway_response, billing_address, completed_at, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'luis.hernandez@gmail.com' LIMIT 1), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), '["' || (SELECT id FROM physical_tickets WHERE ticket_number = 'TKT-ROCK-2025-001' LIMIT 1) || '"]', 3500.00, 'MXN', 'stripe', 'txn_1OaBcDeFgHiJkLmNoPqRsTuVwXyZ', 'completed', '{"status": "succeeded", "amount": 3500, "currency": "mxn", "payment_intent": "pi_1OaBcDeFgHiJkLmNoPqRsTuVwXyZ", "charge_id": "ch_1OaBcDeFgHiJkLmNoPqRsTuVwXyZ"}', '{"street": "Calle Tamaulipas 89", "city": "Ciudad de México", "state": "CDMX", "country": "México", "postal_code": "06700", "phone": "+52 55 4567 8901"}', '2025-01-15 10:00:00', NOW(), NOW());

-- Transacción para el ticket general del Festival de Rock
INSERT INTO payment_transactions (id, user_id, event_id, ticket_ids, amount, currency, payment_method, gateway_transaction_id, status, gateway_response, billing_address, completed_at, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE users.email = 'sofia.lopez@hotmail.com' LIMIT 1), (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), '["' || (SELECT id FROM physical_tickets WHERE ticket_number = 'TKT-ROCK-2025-002' LIMIT 1) || '"]', 1050.00, 'MXN', 'paypal', 'PAY-1AB23456CD789EFGHIJKLMNOP', 'completed', '{"status": "completed", "amount": 1050, "currency": "mxn", "transaction_id": "PAY-1AB23456CD789EFGHIJKLMNOP", "payer_id": "PAYER123456789"}', '{"street": "Calle Hidalgo 456", "city": "Monterrey", "state": "Nuevo León", "country": "México", "postal_code": "64000", "phone": "+52 81 5678 9012"}', '2025-01-16 14:30:00', NOW(), NOW());

-- Transacción para el ticket de la Conferencia de Tecnología
INSERT INTO payment_transactions (id, user_id, event_id, ticket_ids, amount, currency, payment_method, gateway_transaction_id, status, gateway_response, billing_address, completed_at, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'juan.perez@yahoo.com' LIMIT 1), (SELECT id FROM events WHERE slug = 'tech-summit-mexico-2025-innovacion-futuro' LIMIT 1), '["' || (SELECT id FROM physical_tickets WHERE ticket_number = 'TKT-TECH-2025-001' LIMIT 1) || '"]', 1800.00, 'MXN', 'stripe', 'txn_1OaBcDeFgHiJkLmNoPqRsTuVwXyA', 'completed', '{"status": "succeeded", "amount": 1800, "currency": "mxn", "payment_intent": "pi_1OaBcDeFgHiJkLmNoPqRsTuVwXyA", "charge_id": "ch_1OaBcDeFgHiJkLmNoPqRsTuVwXyA"}', '{"street": "Calle Morelos 789", "city": "Guadalajara", "state": "Jalisco", "country": "México", "postal_code": "44100", "phone": "+52 33 6789 0123"}', '2025-01-17 09:15:00', NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE CÓDIGOS DE DESCUENTO REALES
-- =====================================================

-- Código de descuento para estudiantes
INSERT INTO discount_codes (id, code, description, discount_type, discount_value, minimum_purchase, maximum_discount, usage_limit, valid_from, valid_until, applicable_events, applicable_users, is_active, created_at, updated_at) VALUES
(UUID(), 'ESTUDIANTE2025', 'Descuento especial para estudiantes con credencial vigente', 'percentage', 30.00, 500.00, 1500.00, 200, '2025-01-01 00:00:00', '2025-12-31 23:59:59', '["rock-en-la-noche-2025-festival-internacional", "tech-summit-mexico-2025-innovacion-futuro", "romeo-y-julieta-produccion-contemporanea-2025"]', '["student", "university", "college"]', TRUE, NOW(), NOW());

-- Código de descuento para compra anticipada
INSERT INTO discount_codes (id, code, description, discount_type, discount_value, minimum_purchase, maximum_discount, usage_limit, valid_from, valid_until, applicable_events, is_active, created_at, updated_at) VALUES
(UUID(), 'EARLYBIRD2025', 'Descuento por compra anticipada - Early Bird', 'percentage', 20.00, 0.00, 1000.00, 500, '2025-01-01 00:00:00', '2025-03-31 23:59:59', '["rock-en-la-noche-2025-festival-internacional", "tech-summit-mexico-2025-innovacion-futuro"]', TRUE, NOW(), NOW());

-- Código de descuento para startups
INSERT INTO discount_codes (id, code, description, discount_type, discount_value, minimum_purchase, maximum_discount, usage_limit, valid_from, valid_until, applicable_events, applicable_users, is_active, created_at, updated_at) VALUES
(UUID(), 'STARTUP2025', 'Descuento especial para startups y emprendedores', 'percentage', 25.00, 800.00, 1200.00, 100, '2025-01-01 00:00:00', '2025-12-31 23:59:59', '["tech-summit-mexico-2025-innovacion-futuro", "festival-cine-independiente-monterrey-2025"]', '["startup", "entrepreneur", "founder"]', TRUE, NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE NOTIFICACIONES REALES
-- =====================================================

-- Notificación de bienvenida para usuario nuevo
INSERT INTO notifications (id, user_id, title, message, type, action_url, metadata, is_read, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'luis.hernandez@gmail.com' LIMIT 1), '¡Bienvenido a Eventu! 🎉', 'Gracias por registrarte en nuestra plataforma. Descubre eventos increíbles, compra tickets de forma segura y vive experiencias únicas. ¡Tu próxima aventura comienza aquí!', 'info', '/eventos', '{"category": "welcome", "priority": "low", "template": "welcome_new_user"}', FALSE, NOW(), NOW());

-- Notificación de confirmación de compra
INSERT INTO notifications (id, user_id, title, message, type, action_url, metadata, is_read, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'luis.hernandez@gmail.com' LIMIT 1), '🎫 Compra Confirmada - Festival Rock en la Noche 2025', 'Tu ticket VIP para "Rock en la Noche 2025: Festival Internacional" ha sido confirmado exitosamente. Revisa tu email para más detalles del evento, horarios y recomendaciones.', 'success', '/mi-cuenta/boletos', '{"category": "purchase", "priority": "high", "event_id": "rock-en-la-noche-2025-festival-internacional", "ticket_type": "vip"}', FALSE, NOW(), NOW());

-- Notificación de recordatorio de evento
INSERT INTO notifications (id, user_id, title, message, type, action_url, metadata, is_read, created_at, updated_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'sofia.lopez@hotmail.com' LIMIT 1), '⏰ Recordatorio: Festival Rock en la Noche 2025', 'Tu evento está programado para el 20 de junio de 2025. Recuerda revisar la información del evento, horarios de entrada y recomendaciones para disfrutar al máximo.', 'reminder', '/eventos/rock-en-la-noche-2025-festival-internacional', '{"category": "reminder", "priority": "medium", "event_id": "rock-en-la-noche-2025-festival-internacional", "days_before": 30}', FALSE, NOW(), NOW());

-- =====================================================
-- INSERCIÓN DE LOGS DE AUDITORÍA REALES
-- =====================================================

-- Log de creación de evento
INSERT INTO audit_logs (id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'maria.gonzalez@eventospro.com' LIMIT 1), 'create', 'event', (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), NULL, '{"title": "Rock en la Noche 2025: Festival Internacional", "status": "draft", "start_date": "2025-06-20 18:00:00", "venue_name": "Autódromo Hermanos Rodríguez"}', '201.168.45.123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NOW());

-- Log de publicación de evento
INSERT INTO audit_logs (id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'maria.gonzalez@eventospro.com' LIMIT 1), 'update', 'event', (SELECT id FROM events WHERE slug = 'rock-en-la-noche-2025-festival-internacional' LIMIT 1), '{"status": "draft"}', '{"status": "published", "published_at": "2025-01-10 15:30:00", "featured": true}', '201.168.45.123', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NOW());

-- Log de compra de ticket
INSERT INTO audit_logs (id, user_id, action, entity_type, entity_id, old_values, new_values, ip_address, user_agent, created_at) VALUES
(UUID(), (SELECT id FROM users WHERE email = 'luis.hernandez@gmail.com' LIMIT 1), 'purchase', 'ticket', (SELECT id FROM physical_tickets WHERE ticket_number = 'TKT-ROCK-2025-001' LIMIT 1), NULL, '{"status": "issued", "price": 3500.00, "payment_method": "stripe", "transaction_id": "txn_1OaBcDeFgHiJkLmNoPqRsTuVwXyZ"}', '189.234.67.89', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', NOW());

-- =====================================================
-- INSERCIÓN DE CONFIGURACIONES DEL SISTEMA REALES
-- =====================================================

-- Configuración de la aplicación
INSERT INTO system_configurations (id, config_key, config_value, description, is_encrypted, created_at, updated_at) VALUES
(UUID(), 'app.name', 'Eventu', 'Nombre oficial de la aplicación', FALSE, NOW(), NOW()),
(UUID(), 'app.version', '2.1.0', 'Versión actual de la aplicación', FALSE, NOW(), NOW()),
(UUID(), 'app.timezone', 'America/Mexico_City', 'Zona horaria por defecto del sistema', FALSE, NOW(), NOW()),
(UUID(), 'app.language', 'es', 'Idioma por defecto del sistema', FALSE, NOW(), NOW()),
(UUID(), 'ticket.reservation_timeout', '15', 'Tiempo de reserva de asientos en minutos', FALSE, NOW(), NOW()),
(UUID(), 'ticket.max_per_user', '10', 'Máximo número de tickets por usuario por evento', FALSE, NOW(), NOW()),
(UUID(), 'payment.currency_default', 'MXN', 'Moneda por defecto del sistema', FALSE, NOW(), NOW()),
(UUID(), 'payment.gateways', '["stripe", "paypal", "oxxo", "spei"]', 'Pasarelas de pago disponibles', FALSE, NOW(), NOW()),
(UUID(), 'email.smtp_host', 'smtp.gmail.com', 'Servidor SMTP para envío de emails', FALSE, NOW(), NOW()),
(UUID(), 'email.smtp_port', '587', 'Puerto SMTP para envío de emails', FALSE, NOW(), NOW()),
(UUID(), 'email.from_address', 'noreply@eventu.com', 'Dirección de email del remitente', FALSE, NOW(), NOW()),
(UUID(), 'email.from_name', 'Eventu - Plataforma de Eventos', 'Nombre del remitente de emails', FALSE, NOW(), NOW()),
(UUID(), 'security.jwt_expiration', '24h', 'Tiempo de expiración del token JWT', FALSE, NOW(), NOW()),
(UUID(), 'security.password_min_length', '8', 'Longitud mínima de contraseñas', FALSE, NOW(), NOW()),
(UUID(), 'security.max_login_attempts', '5', 'Máximo número de intentos de login', FALSE, NOW(), NOW()),
(UUID(), 'security.lockout_duration', '30m', 'Duración del bloqueo por intentos fallidos', FALSE, NOW(), NOW()),
(UUID(), 'file_upload.max_size', '10485760', 'Tamaño máximo de archivos en bytes (10MB)', FALSE, NOW(), NOW()),
(UUID(), 'file_upload.allowed_types', '["image/jpeg", "image/png", "image/gif", "image/webp"]', 'Tipos de archivo permitidos', FALSE, NOW(), NOW()),
(UUID(), 'notifications.email_enabled', 'true', 'Habilitar notificaciones por email', FALSE, NOW(), NOW()),
(UUID(), 'notifications.sms_enabled', 'false', 'Habilitar notificaciones por SMS', FALSE, NOW(), NOW()),
(UUID(), 'notifications.push_enabled', 'true', 'Habilitar notificaciones push', FALSE, NOW(), NOW()),
(UUID(), 'analytics.google_analytics_id', 'G-XXXXXXXXXX', 'ID de Google Analytics', FALSE, NOW(), NOW()),
(UUID(), 'analytics.facebook_pixel_id', '123456789012345', 'ID del Pixel de Facebook', FALSE, NOW(), NOW()),
(UUID(), 'maintenance.mode', 'false', 'Modo mantenimiento del sistema', FALSE, NOW(), NOW()),
(UUID(), 'maintenance.message', 'Sistema en mantenimiento. Volveremos pronto.', 'Mensaje de mantenimiento', FALSE, NOW(), NOW());

-- =====================================================
-- ACTUALIZACIÓN DE ESTADOS DE ASIENTOS
-- =====================================================

-- Marcar asientos vendidos como ocupados
UPDATE seats SET status = 'occupied', updated_at = NOW() WHERE id IN (
    SELECT seat_id FROM physical_tickets WHERE ticket_number IN ('TKT-ROCK-2025-001', 'TKT-ROCK-2025-002', 'TKT-TECH-2025-001')
);

-- =====================================================
-- VERIFICACIÓN DE DATOS INSERTADOS
-- =====================================================

-- Mostrar resumen de datos insertados
SELECT 'Usuarios' as tabla, COUNT(*) as total FROM users
UNION ALL
SELECT 'Eventos', COUNT(*) FROM events
UNION ALL
SELECT 'Secciones', COUNT(*) FROM seat_map_sections
UNION ALL
SELECT 'Asientos', COUNT(*) FROM seats
UNION ALL
SELECT 'Tickets', COUNT(*) FROM physical_tickets
UNION ALL
SELECT 'Reservas', COUNT(*) FROM seat_reservations
UNION ALL
SELECT 'Reglas de Precios', COUNT(*) FROM pricing_rules
UNION ALL
SELECT 'Condiciones de Mercado', COUNT(*) FROM market_conditions
UNION ALL
SELECT 'Archivos Multimedia', COUNT(*) FROM media_files
UNION ALL
SELECT 'Transacciones', COUNT(*) FROM payment_transactions
UNION ALL
SELECT 'Códigos de Descuento', COUNT(*) FROM discount_codes
UNION ALL
SELECT 'Notificaciones', COUNT(*) FROM notifications
UNION ALL
SELECT 'Logs de Auditoría', COUNT(*) FROM audit_logs
UNION ALL
SELECT 'Configuraciones', COUNT(*) FROM system_configurations;

-- =====================================================
-- FIN DEL SCRIPT COMPLETO DE INSERCIÓN DE DATOS REALES
-- =====================================================

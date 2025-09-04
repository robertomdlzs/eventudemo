-- =====================================================
-- SCRIPT DE VALIDACIÓN DE MAPAS DE ASIENTOS
-- =====================================================
-- Este script valida qué eventos tienen mapa de asientos configurado
-- y muestra información detallada sobre la configuración

-- 1. EVENTOS CON MAPA DE ASIENTOS CONFIGURADO
-- =====================================================
SELECT 
    e.id as event_id,
    e.title as event_title,
    e.status as event_status,
    e.start_date,
    e.venue_name,
    e.venue_city,
    e.venue_capacity,
    CASE 
        WHEN sms.id IS NOT NULL THEN 'SÍ'
        ELSE 'NO'
    END as has_seat_map,
    COUNT(sms.id) as sections_count,
    COALESCE(SUM(sms.capacity), 0) as total_seats_configured,
    e.created_at
FROM events e
LEFT JOIN seat_map_sections sms ON e.id = sms.event_id
GROUP BY e.id, e.title, e.status, e.start_date, e.venue_name, e.venue_city, e.venue_capacity, e.created_at
ORDER BY e.start_date DESC;

-- 2. DETALLE DE SECCIONES POR EVENTO
-- =====================================================
SELECT 
    e.id as event_id,
    e.title as event_title,
    e.status as event_status,
    sms.name as section_name,
    sms.type as section_type,
    sms.capacity as section_capacity,
    sms.price as section_price,
    sms.category as section_category,
    sms.has_wheelchair_access,
    sms.is_premium,
    sms.rows_count,
    sms.seats_per_row
FROM events e
INNER JOIN seat_map_sections sms ON e.id = sms.event_id
ORDER BY e.title, sms.name;

-- 3. CONTEO DE ASIENTOS POR ESTADO
-- =====================================================
SELECT 
    e.id as event_id,
    e.title as event_title,
    s.status as seat_status,
    COUNT(*) as seats_count
FROM events e
INNER JOIN seat_map_sections sms ON e.id = sms.event_id
INNER JOIN seats s ON sms.id = s.section_id
GROUP BY e.id, e.title, s.status
ORDER BY e.title, s.status;

-- 4. RESUMEN ESTADÍSTICO
-- =====================================================
SELECT 
    COUNT(DISTINCT e.id) as total_events,
    COUNT(DISTINCT CASE WHEN sms.id IS NOT NULL THEN e.id END) as events_with_seat_maps,
    COUNT(DISTINCT CASE WHEN sms.id IS NULL THEN e.id END) as events_without_seat_maps,
    ROUND(
        (COUNT(DISTINCT CASE WHEN sms.id IS NOT NULL THEN e.id END) * 100.0) / 
        COUNT(DISTINCT e.id), 2
    ) as percentage_with_seat_maps
FROM events e
LEFT JOIN seat_map_sections sms ON e.id = sms.event_id;

-- 5. EVENTOS SIN MAPA DE ASIENTOS (OPORTUNIDADES)
-- =====================================================
SELECT 
    e.id as event_id,
    e.title as event_title,
    e.status as event_status,
    e.start_date,
    e.venue_name,
    e.venue_capacity,
    e.created_at
FROM events e
LEFT JOIN seat_map_sections sms ON e.id = sms.event_id
WHERE sms.id IS NULL
    AND e.status IN ('published', 'draft')
    AND e.start_date > NOW()
ORDER BY e.start_date;

-- 6. VALIDACIÓN DE INTEGRIDAD DE DATOS
-- =====================================================
-- Verificar eventos con secciones pero sin asientos
SELECT 
    e.id as event_id,
    e.title as event_title,
    COUNT(sms.id) as sections_count,
    COUNT(s.id) as seats_count,
    CASE 
        WHEN COUNT(sms.id) > 0 AND COUNT(s.id) = 0 THEN '⚠️ SECCIONES SIN ASIENTOS'
        WHEN COUNT(sms.id) = 0 THEN '❌ SIN MAPA'
        ELSE '✅ CONFIGURADO CORRECTAMENTE'
    END as status
FROM events e
LEFT JOIN seat_map_sections sms ON e.id = sms.event_id
LEFT JOIN seats s ON sms.id = s.section_id
GROUP BY e.id, e.title
ORDER BY status, e.title;

-- 7. CAPACIDAD VS ASIENTOS CONFIGURADOS
-- =====================================================
SELECT 
    e.id as event_id,
    e.title as event_title,
    e.venue_capacity as venue_capacity,
    COALESCE(SUM(sms.capacity), 0) as configured_seats,
    CASE 
        WHEN e.venue_capacity = COALESCE(SUM(sms.capacity), 0) THEN '✅ COINCIDEN'
        WHEN COALESCE(SUM(sms.capacity), 0) = 0 THEN '❌ SIN CONFIGURAR'
        WHEN e.venue_capacity > COALESCE(SUM(sms.capacity), 0) THEN '⚠️ CAPACIDAD MAYOR'
        ELSE '⚠️ ASIENTOS EXCEDEN CAPACIDAD'
    END as capacity_status,
    ABS(e.venue_capacity - COALESCE(SUM(sms.capacity), 0)) as difference
FROM events e
LEFT JOIN seat_map_sections sms ON e.id = sms.event_id
GROUP BY e.id, e.title, e.venue_capacity
ORDER BY capacity_status, e.title;

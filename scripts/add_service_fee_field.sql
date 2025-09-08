-- Script para agregar el campo service_fee a la tabla events
-- Este campo permitirá a los administradores configurar el valor del servicio por evento

-- Agregar el campo service_fee a la tabla events
ALTER TABLE events 
ADD COLUMN service_fee_type ENUM('percentage', 'fixed') DEFAULT 'percentage',
ADD COLUMN service_fee_value DECIMAL(10,2) DEFAULT 5.00,
ADD COLUMN service_fee_description VARCHAR(255) DEFAULT 'Tarifa de servicio';

-- Agregar comentarios para documentar los campos
ALTER TABLE events 
MODIFY COLUMN service_fee_type ENUM('percentage', 'fixed') DEFAULT 'percentage' COMMENT 'Tipo de tarifa: porcentaje o valor fijo',
MODIFY COLUMN service_fee_value DECIMAL(10,2) DEFAULT 5.00 COMMENT 'Valor de la tarifa (porcentaje o valor fijo)',
MODIFY COLUMN service_fee_description VARCHAR(255) DEFAULT 'Tarifa de servicio' COMMENT 'Descripción de la tarifa de servicio';

-- Crear índice para optimizar consultas por tipo de tarifa
CREATE INDEX idx_events_service_fee_type ON events(service_fee_type);

-- Actualizar eventos existentes con valores por defecto
UPDATE events 
SET 
    service_fee_type = 'percentage',
    service_fee_value = 5.00,
    service_fee_description = 'Tarifa de servicio'
WHERE service_fee_type IS NULL OR service_fee_value IS NULL;


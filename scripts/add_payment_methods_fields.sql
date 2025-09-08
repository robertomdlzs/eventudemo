-- Script para agregar campos de métodos de pago a la tabla events
-- Este campo permitirá a los administradores configurar qué métodos de pago están disponibles para cada evento

-- Agregar el campo payment_methods a la tabla events
ALTER TABLE events 
ADD COLUMN payment_methods JSON DEFAULT '{
  "pse": true,
  "credit_card": true,
  "debit_card": true,
  "daviplata": true,
  "tc_serfinanza": true
}',
ADD COLUMN payment_methods_config JSON DEFAULT '{
  "pse": {
    "enabled": true,
    "description": "Transferencia bancaria directa desde tu cuenta",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "credit_card": {
    "enabled": true,
    "description": "Visa, Mastercard, Diners Club",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "debit_card": {
    "enabled": true,
    "description": "Visa, Mastercard, Diners Club",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "daviplata": {
    "enabled": true,
    "description": "Billetera digital de Davivienda",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "tc_serfinanza": {
    "enabled": true,
    "description": "Tarjeta de crédito Serfinanza",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  }
}';

-- Agregar comentarios para documentar los campos
ALTER TABLE events 
MODIFY COLUMN payment_methods JSON DEFAULT '{
  "pse": true,
  "credit_card": true,
  "debit_card": true,
  "daviplata": true,
  "tc_serfinanza": true
}' COMMENT 'Configuración de métodos de pago habilitados para el evento',
MODIFY COLUMN payment_methods_config JSON DEFAULT '{
  "pse": {
    "enabled": true,
    "description": "Transferencia bancaria directa desde tu cuenta",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "credit_card": {
    "enabled": true,
    "description": "Visa, Mastercard, Diners Club",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "debit_card": {
    "enabled": true,
    "description": "Visa, Mastercard, Diners Club",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "daviplata": {
    "enabled": true,
    "description": "Billetera digital de Davivienda",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  },
  "tc_serfinanza": {
    "enabled": true,
    "description": "Tarjeta de crédito Serfinanza",
    "processing_time": "Inmediato",
    "fees": "Sin comisión adicional"
  }
}' COMMENT 'Configuración detallada de cada método de pago';

-- Crear índice para optimizar consultas por métodos de pago
CREATE INDEX idx_events_payment_methods ON events((CAST(payment_methods AS CHAR(255))));

-- Actualizar eventos existentes con configuración por defecto
UPDATE events 
SET 
    payment_methods = '{
      "pse": true,
      "credit_card": true,
      "debit_card": true,
      "daviplata": true,
      "tc_serfinanza": true
    }',
    payment_methods_config = '{
      "pse": {
        "enabled": true,
        "description": "Transferencia bancaria directa desde tu cuenta",
        "processing_time": "Inmediato",
        "fees": "Sin comisión adicional"
      },
      "credit_card": {
        "enabled": true,
        "description": "Visa, Mastercard, Diners Club",
        "processing_time": "Inmediato",
        "fees": "Sin comisión adicional"
      },
      "debit_card": {
        "enabled": true,
        "description": "Visa, Mastercard, Diners Club",
        "processing_time": "Inmediato",
        "fees": "Sin comisión adicional"
      },
      "daviplata": {
        "enabled": true,
        "description": "Billetera digital de Davivienda",
        "processing_time": "Inmediato",
        "fees": "Sin comisión adicional"
      },
      "tc_serfinanza": {
        "enabled": true,
        "description": "Tarjeta de crédito Serfinanza",
        "processing_time": "Inmediato",
        "fees": "Sin comisión adicional"
      }
    }'
WHERE payment_methods IS NULL OR payment_methods_config IS NULL;


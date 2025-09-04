-- Migración para actualizar la tabla sales con campos de tracking completo
-- Ejecutar: psql -d eventu_db -f backend/migrations/update_sales_table.sql

-- Agregar nuevos campos a la tabla sales
ALTER TABLE sales 
ADD COLUMN IF NOT EXISTS transaction_type VARCHAR(50) DEFAULT 'direct_sale',
ADD COLUMN IF NOT EXISTS failure_reason TEXT,
ADD COLUMN IF NOT EXISTS abandonment_reason TEXT,
ADD COLUMN IF NOT EXISTS gateway_response TEXT,
ADD COLUMN IF NOT EXISTS session_id VARCHAR(255),
ADD COLUMN IF NOT EXISTS ip_address INET,
ADD COLUMN IF NOT EXISTS user_agent TEXT,
ADD COLUMN IF NOT EXISTS payment_gateway VARCHAR(100),
ADD COLUMN IF NOT EXISTS gateway_transaction_id VARCHAR(255),
ADD COLUMN IF NOT EXISTS abandoned_at TIMESTAMP,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

-- Crear índices para mejorar el rendimiento de consultas
CREATE INDEX IF NOT EXISTS idx_sales_transaction_type ON sales(transaction_type);
CREATE INDEX IF NOT EXISTS idx_sales_status ON sales(status);
CREATE INDEX IF NOT EXISTS idx_sales_session_id ON sales(session_id);
CREATE INDEX IF NOT EXISTS idx_sales_created_at ON sales(created_at);
CREATE INDEX IF NOT EXISTS idx_sales_user_id ON sales(user_id);
CREATE INDEX IF NOT EXISTS idx_sales_event_id ON sales(event_id);

-- Actualizar registros existentes para tener valores por defecto
UPDATE sales 
SET 
  transaction_type = 'direct_sale',
  status = COALESCE(status, 'completed')
WHERE transaction_type IS NULL;

-- Crear tabla de auditoría de transacciones (opcional)
CREATE TABLE IF NOT EXISTS transaction_audit_log (
  id SERIAL PRIMARY KEY,
  sale_id INTEGER REFERENCES sales(id),
  action VARCHAR(50) NOT NULL,
  old_status VARCHAR(50),
  new_status VARCHAR(50),
  reason TEXT,
  performed_by INTEGER REFERENCES users(id),
  performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear índices para la tabla de auditoría
CREATE INDEX IF NOT EXISTS idx_transaction_audit_sale_id ON transaction_audit_log(sale_id);
CREATE INDEX IF NOT EXISTS idx_transaction_audit_performed_at ON transaction_audit_log(performed_at);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_sales_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at
DROP TRIGGER IF EXISTS trigger_update_sales_updated_at ON sales;
CREATE TRIGGER trigger_update_sales_updated_at
  BEFORE UPDATE ON sales
  FOR EACH ROW
  EXECUTE FUNCTION update_sales_updated_at();

-- Función para registrar auditoría de transacciones
CREATE OR REPLACE FUNCTION log_transaction_change()
RETURNS TRIGGER AS $$
BEGIN
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO transaction_audit_log (sale_id, action, old_status, new_status, performed_by)
    VALUES (NEW.id, 'status_change', OLD.status, NEW.status, NEW.user_id);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para auditoría automática
DROP TRIGGER IF EXISTS trigger_log_transaction_change ON sales;
CREATE TRIGGER trigger_log_transaction_change
  AFTER UPDATE ON sales
  FOR EACH ROW
  EXECUTE FUNCTION log_transaction_change();

-- Comentarios para documentar la estructura
COMMENT ON TABLE sales IS 'Tabla principal de transacciones de ventas y intentos de compra';
COMMENT ON COLUMN sales.transaction_type IS 'Tipo de transacción: direct_sale, payment_attempt, cart_abandonment';
COMMENT ON COLUMN sales.status IS 'Estado de la transacción: pending, completed, failed, abandoned, cancelled';
COMMENT ON COLUMN sales.failure_reason IS 'Razón del fallo en el pago';
COMMENT ON COLUMN sales.abandonment_reason IS 'Razón del abandono del carrito';
COMMENT ON COLUMN sales.session_id IS 'ID de sesión del usuario';
COMMENT ON COLUMN sales.ip_address IS 'Dirección IP del usuario';
COMMENT ON COLUMN sales.user_agent IS 'User agent del navegador';
COMMENT ON COLUMN sales.payment_gateway IS 'Pasarela de pago utilizada';
COMMENT ON COLUMN sales.gateway_transaction_id IS 'ID de transacción de la pasarela';

-- Verificar que la migración se completó correctamente
SELECT 
  'Migration completed successfully' as status,
  COUNT(*) as total_sales_records,
  COUNT(CASE WHEN transaction_type IS NOT NULL THEN 1 END) as records_with_transaction_type,
  COUNT(CASE WHEN status IS NOT NULL THEN 1 END) as records_with_status
FROM sales;

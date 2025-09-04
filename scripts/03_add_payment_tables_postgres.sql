-- Payments table
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    sale_id INTEGER NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_gateway VARCHAR(50) NOT NULL,
    gateway_transaction_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'COP',
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded')),
    gateway_response JSONB,
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE
);

-- Create indexes for payments table
CREATE INDEX idx_payments_sale ON payments(sale_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_gateway_transaction ON payments(gateway_transaction_id);

-- Payment methods configuration
CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gateway VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    configuration JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert default payment methods
INSERT INTO payment_methods (name, gateway, is_active, configuration) VALUES
('Tarjeta de Crédito', 'stripe', TRUE, '{"currencies": ["COP", "USD"], "fees": {"percentage": 2.9, "fixed": 300}}'),
('PayPal', 'paypal', TRUE, '{"currencies": ["USD", "COP"], "fees": {"percentage": 3.4, "fixed": 0}}'),
('MercadoPago', 'mercadopago', TRUE, '{"currencies": ["COP", "USD"], "fees": {"percentage": 3.5, "fixed": 0}}'),
('Wompi', 'wompi', TRUE, '{"currencies": ["COP"], "fees": {"percentage": 2.8, "fixed": 200}}'),
('Transferencia Bancaria', 'bank_transfer', TRUE, '{"currencies": ["COP"], "fees": {"percentage": 0, "fixed": 0}}');

-- Refunds table
CREATE TABLE refunds (
    id SERIAL PRIMARY KEY,
    payment_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    gateway_refund_id VARCHAR(255),
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE
);

-- Create indexes for refunds table
CREATE INDEX idx_refunds_payment ON refunds(payment_id);
CREATE INDEX idx_refunds_status ON refunds(status);

-- Create trigger function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_refunds_updated_at BEFORE UPDATE ON refunds FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();








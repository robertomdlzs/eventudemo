USE eventu_db;

-- Payments table
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sale_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_gateway VARCHAR(50) NOT NULL,
    gateway_transaction_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'COP',
    status ENUM('pending', 'processing', 'completed', 'failed', 'cancelled', 'refunded') DEFAULT 'pending',
    gateway_response JSON,
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales(id) ON DELETE CASCADE,
    INDEX idx_sale (sale_id),
    INDEX idx_status (status),
    INDEX idx_gateway_transaction (gateway_transaction_id)
);

-- Payment methods configuration
CREATE TABLE payment_methods (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    gateway VARCHAR(50) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    configuration JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
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
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    reason TEXT,
    status ENUM('pending', 'processing', 'completed', 'failed') DEFAULT 'pending',
    gateway_refund_id VARCHAR(255),
    processed_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE CASCADE,
    INDEX idx_payment (payment_id),
    INDEX idx_status (status)
);

const { Pool } = require('pg');
require('dotenv').config();

const db = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
});

async function runMigration() {
  try {
    console.log('Ejecutando migración de boletas físicas...');
    
    // Physical tickets table
    await db.query(`
      CREATE TABLE IF NOT EXISTS physical_tickets (
        id SERIAL PRIMARY KEY,
        batch_number VARCHAR(50) UNIQUE NOT NULL,
        event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
        ticket_type_id INTEGER NOT NULL REFERENCES ticket_types(id) ON DELETE CASCADE,
        quantity INTEGER NOT NULL,
        printed INTEGER DEFAULT 0,
        sold INTEGER DEFAULT 0,
        price DECIMAL(10,2) NOT NULL,
        sales_point VARCHAR(255) NOT NULL,
        notes TEXT,
        status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'printed', 'distributed', 'completed')),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        printed_at TIMESTAMP,
        distributed_at TIMESTAMP
      );
    `);

    // Create indexes
    await db.query(`
      CREATE INDEX IF NOT EXISTS idx_physical_tickets_batch_number ON physical_tickets(batch_number);
      CREATE INDEX IF NOT EXISTS idx_physical_tickets_event ON physical_tickets(event_id);
      CREATE INDEX IF NOT EXISTS idx_physical_tickets_status ON physical_tickets(status);
      CREATE INDEX IF NOT EXISTS idx_physical_tickets_created ON physical_tickets(created_at);
    `);

    // Sales points table
    await db.query(`
      CREATE TABLE IF NOT EXISTS sales_points (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        location VARCHAR(255),
        address TEXT,
        contact_person VARCHAR(255),
        contact_phone VARCHAR(20),
        contact_email VARCHAR(255),
        status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    await db.query(`
      CREATE INDEX IF NOT EXISTS idx_sales_points_name ON sales_points(name);
      CREATE INDEX IF NOT EXISTS idx_sales_points_status ON sales_points(status);
    `);

    // Create triggers
    await db.query(`
      CREATE TRIGGER update_physical_tickets_updated_at BEFORE UPDATE ON physical_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
      CREATE TRIGGER update_sales_points_updated_at BEFORE UPDATE ON sales_points FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    `);

    // Insert sample sales points
    await db.query(`
      INSERT INTO sales_points (name, location, address, contact_person, contact_phone, contact_email) VALUES
      ('Punto de Venta Centro', 'Centro Comercial Plaza Central', 'Calle 123 #45-67, Centro', 'María González', '3001234567', 'centro@eventu.co'),
      ('Punto de Venta Norte', 'Centro Comercial Norte', 'Avenida Norte #89-12, Norte', 'Carlos Rodríguez', '3002345678', 'norte@eventu.co'),
      ('Punto de Venta Sur', 'Centro Comercial Sur', 'Carrera 78 #34-56, Sur', 'Ana Martínez', '3003456789', 'sur@eventu.co')
      ON CONFLICT DO NOTHING;
    `);

    console.log('Migración completada exitosamente');
  } catch (error) {
    console.error('Error ejecutando migración:', error);
  } finally {
    await db.end();
  }
}

runMigration();

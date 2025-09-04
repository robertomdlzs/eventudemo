const { Pool } = require('pg');
require('dotenv').config();

const db = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
});

async function runVirtualTicketsMigration() {
  try {
    console.log('Ejecutando migración de boletas virtuales...');
    
    // Virtual tickets table
    await db.query(`
      CREATE TABLE IF NOT EXISTS virtual_tickets (
        id SERIAL PRIMARY KEY,
        ticket_number VARCHAR(50) UNIQUE NOT NULL,
        event_id INTEGER NOT NULL REFERENCES events(id) ON DELETE CASCADE,
        ticket_type_id INTEGER NOT NULL REFERENCES ticket_types(id) ON DELETE CASCADE,
        customer_name VARCHAR(255) NOT NULL,
        customer_email VARCHAR(255) NOT NULL,
        customer_phone VARCHAR(20),
        price DECIMAL(10,2) NOT NULL,
        qr_code TEXT NOT NULL,
        status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'used', 'cancelled', 'expired')),
        purchase_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        event_date DATE NOT NULL,
        used_at TIMESTAMP,
        sent_at TIMESTAMP,
        notes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Create indexes
    await db.query(`
      CREATE INDEX IF NOT EXISTS idx_virtual_tickets_number ON virtual_tickets(ticket_number);
      CREATE INDEX IF NOT EXISTS idx_virtual_tickets_event ON virtual_tickets(event_id);
      CREATE INDEX IF NOT EXISTS idx_virtual_tickets_status ON virtual_tickets(status);
      CREATE INDEX IF NOT EXISTS idx_virtual_tickets_customer_email ON virtual_tickets(customer_email);
      CREATE INDEX IF NOT EXISTS idx_virtual_tickets_created ON virtual_tickets(created_at);
    `);

    // Create trigger
    await db.query(`
      CREATE TRIGGER update_virtual_tickets_updated_at BEFORE UPDATE ON virtual_tickets FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    `);

    console.log('Migración de boletas virtuales completada exitosamente');
  } catch (error) {
    console.error('Error ejecutando migración de boletas virtuales:', error);
  } finally {
    await db.end();
  }
}

runVirtualTicketsMigration();

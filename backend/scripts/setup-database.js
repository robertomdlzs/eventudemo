const db = require('../config/database-postgres')

async function setupDatabase() {
  try {
    console.log('🔧 Configurando base de datos...')

    // Verificar conexión
    const connectionTest = await db.query('SELECT NOW()')
    console.log('✅ Conexión a PostgreSQL establecida')

    // Crear tablas si no existen
    const createTables = `
      -- Tabla de usuarios
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role VARCHAR(50) DEFAULT 'user',
        is_verified BOOLEAN DEFAULT false,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de eventos
      CREATE TABLE IF NOT EXISTS events (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        date TIMESTAMP NOT NULL,
        location VARCHAR(255),
        organizer_id INTEGER REFERENCES users(id),
        status VARCHAR(50) DEFAULT 'draft',
        total_capacity INTEGER DEFAULT 0,
        available_seats INTEGER DEFAULT 0,
        price DECIMAL(10,2) DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de ventas
      CREATE TABLE IF NOT EXISTS sales (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        event_id INTEGER REFERENCES events(id),
        total_amount DECIMAL(10,2) NOT NULL,
        status VARCHAR(50) DEFAULT 'pending',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de pagos
      CREATE TABLE IF NOT EXISTS payments (
        id SERIAL PRIMARY KEY,
        user_id INTEGER REFERENCES users(id),
        event_id INTEGER REFERENCES events(id),
        sale_id INTEGER REFERENCES sales(id),
        amount DECIMAL(10,2) NOT NULL,
        currency VARCHAR(10) DEFAULT 'USD',
        payment_method VARCHAR(50),
        status VARCHAR(50) DEFAULT 'pending',
        processed_at TIMESTAMP,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de check-in
      CREATE TABLE IF NOT EXISTS check_ins (
        id SERIAL PRIMARY KEY,
        ticket_number VARCHAR(100) UNIQUE NOT NULL,
        event_name VARCHAR(255) NOT NULL,
        customer_name VARCHAR(255),
        ticket_type VARCHAR(100),
        check_in_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        gate VARCHAR(100),
        status VARCHAR(50) DEFAULT 'checked-in',
        operator VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de reportes guardados
      CREATE TABLE IF NOT EXISTS saved_reports (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        type VARCHAR(100) NOT NULL,
        filters JSONB,
        schedule JSONB,
        created_by INTEGER REFERENCES users(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de reportes programados
      CREATE TABLE IF NOT EXISTS scheduled_reports (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        description TEXT,
        type VARCHAR(100) NOT NULL,
        schedule JSONB NOT NULL,
        recipients JSONB,
        status VARCHAR(50) DEFAULT 'active',
        created_by INTEGER REFERENCES users(id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de logs de auditoría
      CREATE TABLE IF NOT EXISTS audit_logs (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(100),
        user_name VARCHAR(255),
        user_email VARCHAR(255),
        action VARCHAR(100) NOT NULL,
        resource VARCHAR(100),
        resource_id VARCHAR(100),
        details JSONB,
        ip_address VARCHAR(45),
        user_agent TEXT,
        severity VARCHAR(20) DEFAULT 'low',
        status VARCHAR(20) DEFAULT 'success',
        timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de notificaciones
      CREATE TABLE IF NOT EXISTS notifications (
        id SERIAL PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        message TEXT NOT NULL,
        type VARCHAR(50) DEFAULT 'info',
        target VARCHAR(50) DEFAULT 'all',
        recipients JSONB,
        sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        read_by JSONB DEFAULT '[]',
        status VARCHAR(50) DEFAULT 'sent'
      );

      -- Tabla de medios
      CREATE TABLE IF NOT EXISTS media (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        original_name VARCHAR(255),
        type VARCHAR(50) NOT NULL,
        size INTEGER,
        url VARCHAR(500),
        folder_id INTEGER,
        alt VARCHAR(255),
        description TEXT,
        tags JSONB DEFAULT '[]',
        upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_used TIMESTAMP,
        usage_count INTEGER DEFAULT 0
      );

      -- Tabla de carpetas de medios
      CREATE TABLE IF NOT EXISTS media_folders (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        parent_id INTEGER REFERENCES media_folders(id),
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de mapas de asientos
      CREATE TABLE IF NOT EXISTS seat_maps (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        venue_name VARCHAR(255),
        total_capacity INTEGER DEFAULT 0,
        map_data JSONB,
        total_seats INTEGER DEFAULT 0,
        available_seats INTEGER DEFAULT 0,
        reserved_seats INTEGER DEFAULT 0,
        occupied_seats INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      -- Tabla de asientos
      CREATE TABLE IF NOT EXISTS seats (
        id SERIAL PRIMARY KEY,
        seat_map_id INTEGER REFERENCES seat_maps(id),
        row_number INTEGER,
        seat_number INTEGER,
        status VARCHAR(50) DEFAULT 'available',
        price DECIMAL(10,2) DEFAULT 0,
        reserved_by INTEGER REFERENCES users(id),
        reserved_at TIMESTAMP,
        occupied_by INTEGER REFERENCES users(id),
        occupied_at TIMESTAMP
      );
    `

    await db.query(createTables)
    console.log('✅ Tablas creadas/verificadas exitosamente')

    // Crear usuario admin si no existe
    const adminCheck = await db.query('SELECT id FROM users WHERE email = $1', ['admin@eventu.co'])
    
    if (adminCheck.rows.length === 0) {
      const bcrypt = require('bcryptjs')
      const hashedPassword = await bcrypt.hash('Eventu321', 10)
      
      await db.query(`
        INSERT INTO users (first_name, last_name, email, password_hash, role, is_verified)
        VALUES ($1, $2, $3, $4, $5, $6)
      `, ['Admin', 'Principal', 'admin@eventu.co', hashedPassword, 'admin', true])
      
      console.log('✅ Usuario admin creado: admin@eventu.co / Eventu321')
    } else {
      console.log('ℹ️  Usuario admin ya existe')
    }

    // Insertar datos de ejemplo
    await insertSampleData()
    
    console.log('🎉 Base de datos configurada exitosamente!')
    process.exit(0)

  } catch (error) {
    console.error('❌ Error configurando base de datos:', error)
    process.exit(1)
  }
}

async function insertSampleData() {
  try {
    console.log('📊 Insertando datos de ejemplo...')

    // Insertar eventos de ejemplo
    const eventCheck = await db.query('SELECT id FROM events LIMIT 1')
    if (eventCheck.rows.length === 0) {
      await db.query(`
        INSERT INTO events (title, description, date, location, organizer_id, status, total_capacity, available_seats, price)
        VALUES 
        ('Conferencia Tech 2024', 'La conferencia más importante de tecnología del año', '2024-12-15 18:00:00', 'Centro de Convenciones', 1, 'published', 500, 450, 150.00),
        ('Festival de Música', 'Festival de música electrónica', '2024-11-20 20:00:00', 'Parque Central', 1, 'published', 1000, 800, 75.00),
        ('Workshop de Marketing', 'Taller intensivo de marketing digital', '2024-10-10 14:00:00', 'Hotel Plaza', 1, 'draft', 50, 50, 200.00)
      `)
      console.log('✅ Eventos de ejemplo insertados')
    }

    // Insertar notificaciones de ejemplo
    const notificationCheck = await db.query('SELECT id FROM notifications LIMIT 1')
    if (notificationCheck.rows.length === 0) {
      await db.query(`
        INSERT INTO notifications (title, message, type, target, status)
        VALUES 
        ('Bienvenido a Eventu', 'Gracias por unirte a nuestra plataforma de eventos', 'info', 'all', 'sent'),
        ('Nuevo evento disponible', 'El evento "Conferencia Tech 2024" ya está disponible para reservas', 'success', 'all', 'sent'),
        ('Mantenimiento programado', 'El sistema estará en mantenimiento el próximo domingo', 'warning', 'admins', 'sent')
      `)
      console.log('✅ Notificaciones de ejemplo insertadas')
    }

    // Insertar logs de auditoría de ejemplo
    const logCheck = await db.query('SELECT id FROM audit_logs LIMIT 1')
    if (logCheck.rows.length === 0) {
      await db.query(`
        INSERT INTO audit_logs (user_id, user_name, user_email, action, resource, details, ip_address, severity, status)
        VALUES 
        ('admin1', 'Admin Principal', 'admin@eventu.co', 'LOGIN', 'auth', '{"method": "email", "success": true}', '192.168.1.100', 'low', 'success'),
        ('admin1', 'Admin Principal', 'admin@eventu.co', 'CREATE_EVENT', 'events', '{"eventTitle": "Conferencia Tech 2024"}', '192.168.1.100', 'medium', 'success'),
        ('user1', 'Usuario Test', 'user@test.com', 'FAILED_LOGIN', 'auth', '{"method": "email", "reason": "Invalid password"}', '192.168.1.101', 'high', 'failure')
      `)
      console.log('✅ Logs de auditoría de ejemplo insertados')
    }

  } catch (error) {
    console.error('❌ Error insertando datos de ejemplo:', error)
  }
}

setupDatabase()

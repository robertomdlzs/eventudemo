const { Pool } = require('pg')
const bcrypt = require('bcryptjs')
require('dotenv').config()

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
})

async function createOrganizerTest() {
  try {
    console.log('🎭 Creando organizador de prueba...')
    
    // Datos del organizador de prueba
    const organizerData = {
      first_name: 'Organizador',
      last_name: 'Test',
      email: 'organizador@test.com',
      password: 'test123',
      role: 'organizer',
      status: 'active'
    }
    
    // Verificar si el usuario ya existe
    const existingUser = await pool.query(
      'SELECT id FROM users WHERE email = $1',
      [organizerData.email]
    )
    
    if (existingUser.rows.length > 0) {
      console.log('⚠️  El usuario ya existe, actualizando contraseña...')
      
      // Actualizar contraseña
      const hashedPassword = await bcrypt.hash(organizerData.password, 12)
      await pool.query(
        'UPDATE users SET password_hash = $1 WHERE email = $2',
        [hashedPassword, organizerData.email]
      )
      
      console.log('✅ Contraseña actualizada exitosamente')
    } else {
      // Crear nuevo usuario
      const hashedPassword = await bcrypt.hash(organizerData.password, 12)
      
      const result = await pool.query(
        `INSERT INTO users (first_name, last_name, email, password_hash, role, status, created_at, updated_at)
         VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
         RETURNING id, first_name, last_name, email, role`,
        [
          organizerData.first_name,
          organizerData.last_name,
          organizerData.email,
          hashedPassword,
          organizerData.role,
          organizerData.status
        ]
      )
      
      console.log('✅ Organizador creado exitosamente:')
      console.log(`   ID: ${result.rows[0].id}`)
      console.log(`   Nombre: ${result.rows[0].first_name} ${result.rows[0].last_name}`)
      console.log(`   Email: ${result.rows[0].email}`)
      console.log(`   Rol: ${result.rows[0].role}`)
    }
    
    // Crear un evento de prueba para el organizador
    const userResult = await pool.query(
      'SELECT id FROM users WHERE email = $1',
      [organizerData.email]
    )
    
    if (userResult.rows.length > 0) {
      const organizerId = userResult.rows[0].id
      
      // Verificar si ya tiene eventos
      const existingEvent = await pool.query(
        'SELECT id FROM events WHERE organizer_id = $1 LIMIT 1',
        [organizerId]
      )
      
      if (existingEvent.rows.length === 0) {
        console.log('📅 Creando evento de prueba...')
        
        const eventResult = await pool.query(
          `INSERT INTO events (title, slug, description, date, time, venue, location, organizer_id, total_capacity, price, status, created_at, updated_at)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, NOW(), NOW())
           RETURNING id, title`,
          [
            'Evento de Prueba del Organizador',
            'evento-prueba-organizador',
            'Este es un evento de prueba para verificar las métricas del organizador',
            '2025-12-25',
            '19:00:00',
            'Auditorio Principal',
            'Bogotá, Colombia',
            organizerId,
            100,
            50000,
            'published'
          ]
        )
        
        console.log('✅ Evento creado exitosamente:')
        console.log(`   ID: ${eventResult.rows[0].id}`)
        console.log(`   Título: ${eventResult.rows[0].title}`)
        
        // Crear tipos de boletos
        console.log('🎫 Creando tipos de boletos...')
        
        const ticketTypes = [
          { name: 'General', price: 50000, description: 'Acceso general' },
          { name: 'VIP', price: 100000, description: 'Acceso VIP con beneficios especiales' },
          { name: 'Premium', price: 150000, description: 'Acceso premium con asiento reservado' }
        ]
        
        for (const ticketType of ticketTypes) {
          await pool.query(
            `INSERT INTO ticket_types (name, description, price, quantity, event_id, created_at, updated_at)
             VALUES ($1, $2, $3, $4, $5, NOW(), NOW())`,
            [ticketType.name, ticketType.description, ticketType.price, 50, eventResult.rows[0].id]
          )
        }
        
        console.log('✅ Tipos de boletos creados')
        
        // Crear algunas ventas de prueba
        console.log('💰 Creando ventas de prueba...')
        
        const sales = [
          { buyer_name: 'Juan Pérez', buyer_email: 'juan@test.com', quantity: 2, amount: 100000, payment_method: 'credit_card', status: 'completed' },
          { buyer_name: 'Ana García', buyer_email: 'ana@test.com', quantity: 1, amount: 150000, payment_method: 'debit_card', status: 'completed' },
          { buyer_name: 'Carlos López', buyer_email: 'carlos@test.com', quantity: 3, amount: 150000, payment_method: 'transfer', status: 'pending' }
        ]
        
        for (const sale of sales) {
          await pool.query(
            `INSERT INTO sales (buyer_name, buyer_email, quantity, amount, payment_method, status, event_id, created_at, updated_at)
             VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())`,
            [sale.buyer_name, sale.buyer_email, sale.quantity, sale.amount, sale.payment_method, sale.status, eventResult.rows[0].id]
          )
        }
        
        console.log('✅ Ventas de prueba creadas')
      } else {
        console.log('📅 El organizador ya tiene eventos')
      }
    }
    
    console.log('\n🎉 Organizador de prueba configurado exitosamente!')
    console.log('\n📋 Credenciales de acceso:')
    console.log(`   Email: ${organizerData.email}`)
    console.log(`   Contraseña: ${organizerData.password}`)
    console.log(`   Rol: ${organizerData.role}`)
    
  } catch (error) {
    console.error('❌ Error creando organizador de prueba:', error)
  } finally {
    await pool.end()
  }
}

createOrganizerTest()

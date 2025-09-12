const { Pool } = require('pg')
require('dotenv').config({ path: './config.env' })

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
})

async function populateAuditLogs() {
  const client = await pool.connect()
  
  try {
    console.log('🔧 Poblando logs de auditoría...')

    // Verificar si ya existen logs
    const existingLogs = await client.query('SELECT COUNT(*) as count FROM audit_logs')
    if (parseInt(existingLogs.rows[0].count) > 0) {
      console.log('✅ Ya existen logs de auditoría, saltando población')
      return
    }

    // Logs de ejemplo
    const sampleLogs = [
      {
        user_id: '1',
        user_name: 'Administrador',
        user_email: 'admin@eventu.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { method: 'POST', path: '/api/auth/login' },
        ip_address: '192.168.1.100',
        user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        user_id: '2',
        user_name: 'Organizador Test',
        user_email: 'organizer@eventu.com',
        action: 'CREATE',
        resource: 'EVENT',
        resource_id: '1',
        details: { method: 'POST', path: '/api/events', eventName: 'Concierto de Rock' },
        ip_address: '192.168.1.101',
        user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        severity: 'high',
        status: 'success'
      },
      {
        user_id: '3',
        user_name: 'Usuario Test',
        user_email: 'user@eventu.com',
        action: 'CREATE',
        resource: 'PAYMENT',
        resource_id: '1',
        details: { method: 'POST', path: '/api/payments', amount: 50000 },
        ip_address: '192.168.1.102',
        user_agent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15',
        severity: 'high',
        status: 'success'
      },
      {
        user_id: '1',
        user_name: 'Administrador',
        user_email: 'admin@eventu.com',
        action: 'UPDATE',
        resource: 'SETTINGS',
        details: { method: 'PUT', path: '/api/admin/settings', setting: 'session_timeout' },
        ip_address: '192.168.1.100',
        user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'high',
        status: 'success'
      },
      {
        user_id: 'unknown',
        user_name: 'Usuario Desconocido',
        user_email: 'hacker@example.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { method: 'POST', path: '/api/auth/login', reason: 'Invalid credentials' },
        ip_address: '203.0.113.45',
        user_agent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
        severity: 'high',
        status: 'failure'
      }
    ]

    // Insertar logs con timestamps escalonados
    for (let i = 0; i < sampleLogs.length; i++) {
      const log = sampleLogs[i]
      const timestamp = new Date(Date.now() - (i * 30 * 60 * 1000)) // Cada 30 minutos hacia atrás
      
      await client.query(`
        INSERT INTO audit_logs (
          user_id, user_name, user_email, action, resource, resource_id,
          details, ip_address, user_agent, severity, status, timestamp
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      `, [
        log.user_id,
        log.user_name,
        log.user_email,
        log.action,
        log.resource,
        log.resource_id || null,
        JSON.stringify(log.details),
        log.ip_address,
        log.user_agent,
        log.severity,
        log.status,
        timestamp
      ])
    }

    console.log(`✅ Se insertaron ${sampleLogs.length} logs de auditoría de ejemplo`)
    
    // Verificar inserción
    const count = await client.query('SELECT COUNT(*) as count FROM audit_logs')
    console.log(`📊 Total de logs en la base de datos: ${count.rows[0].count}`)

  } catch (error) {
    console.error('❌ Error poblando logs de auditoría:', error)
  } finally {
    client.release()
    await pool.end()
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  populateAuditLogs()
}

module.exports = populateAuditLogs

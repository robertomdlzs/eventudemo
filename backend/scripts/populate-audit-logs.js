const db = require('../config/database-postgres')
const AuditService = require('../services/auditService')

async function populateAuditLogs() {
  try {
    console.log('🔧 Poblando logs de auditoría...')

    // Verificar si ya existen logs
    const existingLogs = await db.query('SELECT COUNT(*) as count FROM audit_logs')
    if (parseInt(existingLogs.rows[0].count) > 0) {
      console.log('✅ Ya existen logs de auditoría, saltando población')
      return
    }

    // Logs de ejemplo
    const sampleLogs = [
      {
        userId: '1',
        userName: 'Administrador',
        userEmail: 'admin@eventu.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { method: 'POST', path: '/api/auth/login' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '2',
        userName: 'Organizador Test',
        userEmail: 'organizer@eventu.com',
        action: 'CREATE',
        resource: 'EVENT',
        resourceId: '1',
        details: { method: 'POST', path: '/api/events', eventName: 'Concierto de Rock' },
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        severity: 'high',
        status: 'success'
      },
      {
        userId: '3',
        userName: 'Usuario Test',
        userEmail: 'user@eventu.com',
        action: 'CREATE',
        resource: 'PAYMENT',
        resourceId: '1',
        details: { method: 'POST', path: '/api/payments', amount: 50000 },
        ipAddress: '192.168.1.102',
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15',
        severity: 'high',
        status: 'success'
      },
      {
        userId: '1',
        userName: 'Administrador',
        userEmail: 'admin@eventu.com',
        action: 'UPDATE',
        resource: 'SETTINGS',
        details: { method: 'PUT', path: '/api/admin/settings', setting: 'session_timeout' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'high',
        status: 'success'
      },
      {
        userId: 'unknown',
        userName: 'Usuario Desconocido',
        userEmail: 'hacker@example.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { method: 'POST', path: '/api/auth/login', reason: 'Invalid credentials' },
        ipAddress: '203.0.113.45',
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
        severity: 'high',
        status: 'failure'
      },
      {
        userId: '2',
        userName: 'Organizador Test',
        userEmail: 'organizer@eventu.com',
        action: 'UPDATE',
        resource: 'EVENT',
        resourceId: '1',
        details: { method: 'PUT', path: '/api/events/1', changes: ['price', 'capacity'] },
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '3',
        userName: 'Usuario Test',
        userEmail: 'user@eventu.com',
        action: 'READ',
        resource: 'EVENT',
        resourceId: '1',
        details: { method: 'GET', path: '/api/events/1' },
        ipAddress: '192.168.1.102',
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15',
        severity: 'low',
        status: 'success'
      },
      {
        userId: '1',
        userName: 'Administrador',
        userEmail: 'admin@eventu.com',
        action: 'DELETE',
        resource: 'USER',
        resourceId: '5',
        details: { method: 'DELETE', path: '/api/admin/users/5', reason: 'Account violation' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'critical',
        status: 'success'
      }
    ]

    // Insertar logs con timestamps escalonados
    for (let i = 0; i < sampleLogs.length; i++) {
      const log = sampleLogs[i]
      const timestamp = new Date(Date.now() - (i * 30 * 60 * 1000)) // Cada 30 minutos hacia atrás
      
      await db.query(`
        INSERT INTO audit_logs (
          user_id, user_name, user_email, action, resource, resource_id,
          details, ip_address, user_agent, severity, status, timestamp
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      `, [
        log.userId,
        log.userName,
        log.userEmail,
        log.action,
        log.resource,
        log.resourceId || null,
        JSON.stringify(log.details),
        log.ipAddress,
        log.userAgent,
        log.severity,
        log.status,
        timestamp
      ])
    }

    console.log(`✅ Se insertaron ${sampleLogs.length} logs de auditoría de ejemplo`)
    
    // Verificar inserción
    const count = await db.query('SELECT COUNT(*) as count FROM audit_logs')
    console.log(`📊 Total de logs en la base de datos: ${count.rows[0].count}`)

  } catch (error) {
    console.error('❌ Error poblando logs de auditoría:', error)
  } finally {
    await db.end()
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  populateAuditLogs()
}

module.exports = populateAuditLogs

require('dotenv').config({ path: '../config.env' })
const AuditService = require('../services/auditService')

async function testAuditSystem() {
  console.log('🧪 Probando sistema de auditoría...')

  try {
    // Simular diferentes tipos de actividades
    const testActivities = [
      {
        userId: '1',
        userName: 'Admin Test',
        userEmail: 'admin@test.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { method: 'POST', endpoint: '/api/auth/login' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '2',
        userName: 'Usuario Test',
        userEmail: 'user@test.com',
        action: 'CREATE',
        resource: 'EVENT',
        resourceId: '123',
        details: { 
          eventName: 'Concierto de Prueba',
          eventDate: '2024-12-25',
          venue: 'Teatro Principal'
        },
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'high',
        status: 'success'
      },
      {
        userId: '3',
        userName: 'Organizador Test',
        userEmail: 'organizer@test.com',
        action: 'UPDATE',
        resource: 'USER',
        resourceId: '456',
        details: { 
          field: 'status',
          oldValue: 'active',
          newValue: 'inactive'
        },
        ipAddress: '192.168.1.102',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'high',
        status: 'success'
      },
      {
        userId: '4',
        userName: 'Cliente Test',
        userEmail: 'client@test.com',
        action: 'TRANSACTION',
        resource: 'PAYMENT',
        resourceId: '789',
        details: { 
          amount: 50000,
          currency: 'COP',
          paymentMethod: 'credit_card',
          transactionId: 'TXN_123456'
        },
        ipAddress: '192.168.1.103',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'critical',
        status: 'success'
      },
      {
        userId: '5',
        userName: 'Usuario Fallido',
        userEmail: 'failed@test.com',
        action: 'LOGIN',
        resource: 'AUTH',
        details: { 
          method: 'POST',
          endpoint: '/api/auth/login',
          reason: 'Invalid credentials'
        },
        ipAddress: '192.168.1.104',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'medium',
        status: 'failure'
      },
      {
        userId: '1',
        userName: 'Admin Test',
        userEmail: 'admin@test.com',
        action: 'DELETE',
        resource: 'EVENT',
        resourceId: '999',
        details: { 
          eventName: 'Evento Eliminado',
          reason: 'Event cancelled'
        },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Test Browser)',
        severity: 'critical',
        status: 'success'
      }
    ]

    console.log('📝 Creando logs de prueba...')
    
    for (const activity of testActivities) {
      const logId = await AuditService.logActivity(activity)
      console.log(`✅ Log creado con ID: ${logId}`)
    }

    console.log('📊 Obteniendo estadísticas...')
    const stats = await AuditService.getAuditStats()
    console.log('Estadísticas:', JSON.stringify(stats, null, 2))

    console.log('📋 Obteniendo logs recientes...')
    const logs = await AuditService.getAuditLogs({}, 10, 0)
    console.log(`Total de logs: ${logs.total}`)
    console.log('Últimos 5 logs:')
    logs.logs.slice(0, 5).forEach(log => {
      console.log(`- ${log.action} ${log.resource} por ${log.user_name} (${log.severity})`)
    })

    console.log('🎉 Sistema de auditoría probado exitosamente!')

  } catch (error) {
    console.error('❌ Error probando sistema de auditoría:', error)
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  testAuditSystem().then(() => {
    console.log('✅ Prueba completada')
    process.exit(0)
  }).catch(error => {
    console.error('❌ Error en la prueba:', error)
    process.exit(1)
  })
}

module.exports = testAuditSystem

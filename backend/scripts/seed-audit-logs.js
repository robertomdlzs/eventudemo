// Cargar variables de entorno
require('dotenv').config({ path: './config.env' })

const db = require('../config/database-postgres')
const AuditService = require('../services/auditService')

async function seedAuditLogs() {
  try {
    console.log('🌱 Generando datos de prueba para audit_logs...')

    // Verificar si ya hay datos
    const existingCount = await db.query('SELECT COUNT(*) as count FROM audit_logs')
    console.log(`📊 Logs existentes: ${existingCount.rows[0].count}`)

    if (parseInt(existingCount.rows[0].count) > 0) {
      console.log('✅ Ya hay datos en audit_logs, no se generarán más')
      return
    }

    // Generar logs de prueba
    const sampleLogs = [
      {
        userId: '1',
        userName: 'Admin Usuario',
        userEmail: 'admin@eventu.com',
        action: 'LOGIN',
        resource: 'AUTH',
        resourceId: null,
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
        action: 'CREATE_EVENT',
        resource: 'EVENT',
        resourceId: '123',
        details: { method: 'POST', path: '/api/events', eventTitle: 'Concierto de Rock' },
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '3',
        userName: 'Usuario Regular',
        userEmail: 'user@eventu.com',
        action: 'CREATE_PAYMENT',
        resource: 'PAYMENT',
        resourceId: '456',
        details: { method: 'POST', path: '/api/payments', amount: 50000 },
        ipAddress: '192.168.1.102',
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
        severity: 'high',
        status: 'success'
      },
      {
        userId: '1',
        userName: 'Admin Usuario',
        userEmail: 'admin@eventu.com',
        action: 'DELETE_USER',
        resource: 'USER',
        resourceId: '789',
        details: { method: 'DELETE', path: '/api/users/789' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'critical',
        status: 'success'
      },
      {
        userId: '4',
        userName: 'Usuario Test',
        userEmail: 'test@eventu.com',
        action: 'LOGIN',
        resource: 'AUTH',
        resourceId: null,
        details: { method: 'POST', path: '/api/auth/login' },
        ipAddress: '192.168.1.103',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'medium',
        status: 'failure'
      },
      {
        userId: '2',
        userName: 'Organizador Test',
        userEmail: 'organizer@eventu.com',
        action: 'UPDATE_EVENT',
        resource: 'EVENT',
        resourceId: '123',
        details: { method: 'PUT', path: '/api/events/123', changes: ['title', 'date'] },
        ipAddress: '192.168.1.101',
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '1',
        userName: 'Admin Usuario',
        userEmail: 'admin@eventu.com',
        action: 'ADMIN_ACCESS',
        resource: 'ADMIN',
        resourceId: null,
        details: { method: 'GET', path: '/api/admin/dashboard' },
        ipAddress: '192.168.1.100',
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity: 'medium',
        status: 'success'
      },
      {
        userId: '5',
        userName: 'Usuario Nuevo',
        userEmail: 'newuser@eventu.com',
        action: 'REGISTER',
        resource: 'USER',
        resourceId: '999',
        details: { method: 'POST', path: '/api/auth/register' },
        ipAddress: '192.168.1.104',
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15',
        severity: 'medium',
        status: 'success'
      }
    ]

    // Insertar logs con diferentes fechas para simular actividad a lo largo del tiempo
    for (let i = 0; i < sampleLogs.length; i++) {
      const log = sampleLogs[i]
      const hoursAgo = Math.floor(Math.random() * 48) // Últimas 48 horas
      const timestamp = new Date(Date.now() - (hoursAgo * 60 * 60 * 1000))
      
      await AuditService.logActivity({
        ...log,
        timestamp: timestamp.toISOString()
      })
    }

    // Generar algunos logs adicionales para tener más datos
    const additionalActions = ['CREATE_TICKET', 'UPDATE_TICKET', 'DELETE_TICKET', 'CREATE_CATEGORY', 'UPDATE_CATEGORY']
    const additionalResources = ['TICKET', 'CATEGORY', 'VENUE', 'MEDIA']
    
    for (let i = 0; i < 20; i++) {
      const action = additionalActions[Math.floor(Math.random() * additionalActions.length)]
      const resource = additionalResources[Math.floor(Math.random() * additionalResources.length)]
      const severity = ['low', 'medium', 'high'][Math.floor(Math.random() * 3)]
      const status = ['success', 'failure', 'warning'][Math.floor(Math.random() * 3)]
      const hoursAgo = Math.floor(Math.random() * 72) // Últimos 3 días
      const timestamp = new Date(Date.now() - (hoursAgo * 60 * 60 * 1000))
      
      await AuditService.logActivity({
        userId: (Math.floor(Math.random() * 5) + 1).toString(),
        userName: `Usuario ${Math.floor(Math.random() * 5) + 1}`,
        userEmail: `user${Math.floor(Math.random() * 5) + 1}@eventu.com`,
        action,
        resource,
        resourceId: Math.floor(Math.random() * 1000).toString(),
        details: { method: 'POST', path: `/api/${resource.toLowerCase()}` },
        ipAddress: `192.168.1.${Math.floor(Math.random() * 255)}`,
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        severity,
        status,
        timestamp: timestamp.toISOString()
      })
    }

    console.log('✅ Datos de prueba generados exitosamente!')
    
    // Mostrar estadísticas finales
    const finalCount = await db.query('SELECT COUNT(*) as count FROM audit_logs')
    console.log(`📊 Total de logs después de la generación: ${finalCount.rows[0].count}`)
    
    const severityStats = await db.query('SELECT severity, COUNT(*) as count FROM audit_logs GROUP BY severity')
    console.log('📊 Logs por severidad:')
    severityStats.rows.forEach(stat => {
      console.log(`  ${stat.severity}: ${stat.count}`)
    })
    
    const statusStats = await db.query('SELECT status, COUNT(*) as count FROM audit_logs GROUP BY status')
    console.log('📊 Logs por estado:')
    statusStats.rows.forEach(stat => {
      console.log(`  ${stat.status}: ${stat.count}`)
    })

  } catch (error) {
    console.error('❌ Error generando datos de prueba:', error)
  } finally {
    process.exit(0)
  }
}

seedAuditLogs()

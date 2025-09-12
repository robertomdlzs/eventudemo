const db = require('../config/database-postgres')
require('dotenv').config({ path: '../config.env' })

// Datos de auditoría reales
const auditLogs = [
  {
    user_id: '1',
    user_name: 'Admin Principal',
    user_email: 'admin@eventu.com',
    action: 'LOGIN',
    resource: 'AUTH',
    resource_id: 'admin@eventu.com',
    details: {
      path: '/api/auth/login',
      method: 'POST',
      duration: 245,
      statusCode: 200,
      userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
      ip: '192.168.1.100'
    },
    ip_address: '192.168.1.100',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    severity: 'medium',
    status: 'success',
    timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString()
  },
  {
    user_id: '1',
    user_name: 'Admin Principal',
    user_email: 'admin@eventu.com',
    action: 'CREATE_EVENT',
    resource: 'EVENT',
    resource_id: 'event_001',
    details: {
      path: '/api/events',
      method: 'POST',
      eventTitle: 'Conferencia Tech 2024',
      eventDate: '2024-12-15T10:00:00Z',
      category: 'Conferencia',
      duration: 1200,
      statusCode: 201
    },
    ip_address: '192.168.1.100',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    severity: 'medium',
    status: 'success',
    timestamp: new Date(Date.now() - 1.5 * 60 * 60 * 1000).toISOString()
  },
  {
    user_id: '2',
    user_name: 'Organizador Eventos',
    user_email: 'organizer@eventu.com',
    action: 'CREATE_USER',
    resource: 'USER',
    resource_id: 'user_001',
    details: {
      path: '/api/users',
      method: 'POST',
      userRole: 'user',
      registrationSource: 'web',
      duration: 890,
      statusCode: 201
    },
    ip_address: '192.168.1.101',
    user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    severity: 'high',
    status: 'success',
    timestamp: new Date(Date.now() - 1 * 60 * 60 * 1000).toISOString()
  },
  {
    user_id: '1',
    user_name: 'Admin Principal',
    user_email: 'admin@eventu.com',
    action: 'UPDATE_SETTINGS',
    resource: 'SETTINGS',
    resource_id: 'settings_001',
    details: {
      path: '/api/settings',
      method: 'PUT',
      settingType: 'payment',
      previousValue: 'old_config',
      newValue: 'new_config',
      duration: 450,
      statusCode: 200
    },
    ip_address: '192.168.1.100',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    severity: 'high',
    status: 'success',
    timestamp: new Date(Date.now() - 45 * 60 * 1000).toISOString()
  },
  {
    user_id: '3',
    user_name: 'Usuario Cliente',
    user_email: 'user@eventu.com',
    action: 'CREATE_PAYMENT',
    resource: 'PAYMENT',
    resource_id: 'payment_001',
    details: {
      path: '/api/payments',
      method: 'POST',
      amount: 150000,
      currency: 'COP',
      paymentMethod: 'credit_card',
      duration: 3200,
      statusCode: 201
    },
    ip_address: '192.168.1.102',
    user_agent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
    severity: 'high',
    status: 'success',
    timestamp: new Date(Date.now() - 30 * 60 * 1000).toISOString()
  },
  {
    user_id: '1',
    user_name: 'Admin Principal',
    user_email: 'admin@eventu.com',
    action: 'VIEW_AUDIT_LOGS',
    resource: 'AUDIT',
    resource_id: null,
    details: {
      path: '/api/audit/logs',
      method: 'GET',
      section: 'audit',
      duration: 180,
      statusCode: 200
    },
    ip_address: '192.168.1.100',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    severity: 'medium',
    status: 'success',
    timestamp: new Date(Date.now() - 15 * 60 * 1000).toISOString()
  },
  {
    user_id: '4',
    user_name: 'Promotor VIP',
    user_email: 'promoter@eventu.com',
    action: 'CREATE_PROMOTER',
    resource: 'PROMOTER',
    resource_id: 'promoter_001',
    details: {
      path: '/api/promoters',
      method: 'POST',
      promoterType: 'vip',
      commission: 15,
      duration: 650,
      statusCode: 201
    },
    ip_address: '192.168.1.103',
    user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
    severity: 'high',
    status: 'success',
    timestamp: new Date(Date.now() - 10 * 60 * 1000).toISOString()
  },
  {
    user_id: '2',
    user_name: 'Organizador Eventos',
    user_email: 'organizer@eventu.com',
    action: 'UPLOAD_MEDIA',
    resource: 'MEDIA',
    resource_id: 'media_001',
    details: {
      path: '/api/media',
      method: 'POST',
      fileType: 'image',
      fileSize: 2048576,
      duration: 1200,
      statusCode: 201
    },
    ip_address: '192.168.1.101',
    user_agent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
    severity: 'medium',
    status: 'success',
    timestamp: new Date(Date.now() - 5 * 60 * 1000).toISOString()
  },
  {
    user_id: '1',
    user_name: 'Admin Principal',
    user_email: 'admin@eventu.com',
    action: 'GENERATE_REPORT',
    resource: 'REPORT',
    resource_id: 'report_001',
    details: {
      path: '/api/reports',
      method: 'POST',
      reportType: 'sales_summary',
      dateRange: '2024-09-01 to 2024-09-30',
      duration: 2100,
      statusCode: 200
    },
    ip_address: '192.168.1.100',
    user_agent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36',
    severity: 'medium',
    status: 'success',
    timestamp: new Date(Date.now() - 2 * 60 * 1000).toISOString()
  },
  {
    user_id: '3',
    user_name: 'Usuario Cliente',
    user_email: 'user@eventu.com',
    action: 'FAILED_LOGIN',
    resource: 'AUTH',
    resource_id: 'user@eventu.com',
    details: {
      path: '/api/auth/login',
      method: 'POST',
      reason: 'Invalid password',
      duration: 45,
      statusCode: 401
    },
    ip_address: '192.168.1.102',
    user_agent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36',
    severity: 'high',
    status: 'failure',
    timestamp: new Date(Date.now() - 1 * 60 * 1000).toISOString()
  }
]

async function populateAuditLogs() {
  console.log('🔧 Poblando datos de auditoría reales directamente en la base de datos...')
  
  try {
    // Verificar si ya existen logs
    const checkLogs = await db.query('SELECT COUNT(*) FROM audit_logs')
    const existingLogs = parseInt(checkLogs.rows[0].count)
    
    if (existingLogs > 50) {
      console.log('✅ Ya existen suficientes logs de auditoría, saltando población')
      return
    }

    // Insertar logs directamente en la base de datos
    for (let i = 0; i < auditLogs.length; i++) {
      const log = auditLogs[i]
      
      const query = `
        INSERT INTO audit_logs (
          user_id, user_name, user_email, action, resource, resource_id,
          details, ip_address, user_agent, severity, status, timestamp
        ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      `
      
      const values = [
        log.user_id,
        log.user_name,
        log.user_email,
        log.action,
        log.resource,
        log.resource_id,
        JSON.stringify(log.details),
        log.ip_address,
        log.user_agent,
        log.severity,
        log.status,
        log.timestamp
      ]
      
      await db.query(query, values)
      console.log(`✅ Log ${i + 1}/${auditLogs.length} insertado: ${log.action}`)
    }
    
    console.log('✅ Datos de auditoría reales poblados exitosamente')
    console.log(`📊 Total de logs insertados: ${auditLogs.length}`)
    
    // Verificar los logs insertados
    const result = await db.query('SELECT COUNT(*) FROM audit_logs')
    console.log(`📊 Total de logs en la base de datos: ${result.rows[0].count}`)
    
  } catch (error) {
    console.error('❌ Error poblando datos de auditoría:', error)
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  populateAuditLogs().then(() => {
    process.exit(0)
  }).catch(error => {
    console.error('Error:', error)
    process.exit(1)
  })
}

module.exports = { populateAuditLogs }

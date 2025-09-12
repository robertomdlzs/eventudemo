const db = require('../config/database-postgres')
const AuditService = require('../services/auditService')
require('dotenv').config({ path: '../config.env' })

// Datos de usuarios de ejemplo
const users = [
  { id: '1', name: 'Admin Principal', email: 'admin@eventu.com', role: 'admin' },
  { id: '2', name: 'Organizador Eventos', email: 'organizer@eventu.com', role: 'organizer' },
  { id: '3', name: 'Usuario Cliente', email: 'user@eventu.com', role: 'user' },
  { id: '4', name: 'Promotor VIP', email: 'promoter@eventu.com', role: 'promoter' }
]

// Acciones de ejemplo que simulan uso real del sistema
const actions = [
  // Acciones de autenticación
  { action: 'LOGIN', resource: 'AUTH', severity: 'medium', status: 'success' },
  { action: 'LOGOUT', resource: 'AUTH', severity: 'low', status: 'success' },
  { action: 'FAILED_LOGIN', resource: 'AUTH', severity: 'high', status: 'failure' },
  
  // Acciones de eventos
  { action: 'CREATE_EVENT', resource: 'EVENT', severity: 'medium', status: 'success' },
  { action: 'UPDATE_EVENT', resource: 'EVENT', severity: 'medium', status: 'success' },
  { action: 'DELETE_EVENT', resource: 'EVENT', severity: 'high', status: 'success' },
  { action: 'PUBLISH_EVENT', resource: 'EVENT', severity: 'medium', status: 'success' },
  
  // Acciones de usuarios
  { action: 'CREATE_USER', resource: 'USER', severity: 'high', status: 'success' },
  { action: 'UPDATE_USER', resource: 'USER', severity: 'high', status: 'success' },
  { action: 'DELETE_USER', resource: 'USER', severity: 'critical', status: 'success' },
  { action: 'CHANGE_USER_ROLE', resource: 'USER', severity: 'critical', status: 'success' },
  
  // Acciones de tickets
  { action: 'CREATE_TICKET', resource: 'TICKET', severity: 'medium', status: 'success' },
  { action: 'UPDATE_TICKET', resource: 'TICKET', severity: 'medium', status: 'success' },
  { action: 'DELETE_TICKET', resource: 'TICKET', severity: 'high', status: 'success' },
  { action: 'VALIDATE_TICKET', resource: 'TICKET', severity: 'medium', status: 'success' },
  
  // Acciones de pagos
  { action: 'CREATE_PAYMENT', resource: 'PAYMENT', severity: 'high', status: 'success' },
  { action: 'PROCESS_PAYMENT', resource: 'PAYMENT', severity: 'high', status: 'success' },
  { action: 'REFUND_PAYMENT', resource: 'PAYMENT', severity: 'high', status: 'success' },
  { action: 'FAILED_PAYMENT', resource: 'PAYMENT', severity: 'high', status: 'failure' },
  
  // Acciones de administración
  { action: 'ADMIN_ACCESS', resource: 'ADMIN', severity: 'medium', status: 'success' },
  { action: 'ADMIN_UPDATE', resource: 'ADMIN', severity: 'high', status: 'success' },
  { action: 'ADMIN_DELETE', resource: 'ADMIN', severity: 'critical', status: 'success' },
  { action: 'VIEW_AUDIT_LOGS', resource: 'AUDIT', severity: 'medium', status: 'success' },
  
  // Acciones de configuración
  { action: 'UPDATE_SETTINGS', resource: 'SETTINGS', severity: 'high', status: 'success' },
  { action: 'CHANGE_SYSTEM_CONFIG', resource: 'SETTINGS', severity: 'critical', status: 'success' },
  
  // Acciones de medios
  { action: 'UPLOAD_MEDIA', resource: 'MEDIA', severity: 'medium', status: 'success' },
  { action: 'DELETE_MEDIA', resource: 'MEDIA', severity: 'medium', status: 'success' },
  
  // Acciones de reportes
  { action: 'GENERATE_REPORT', resource: 'REPORT', severity: 'medium', status: 'success' },
  { action: 'EXPORT_DATA', resource: 'REPORT', severity: 'medium', status: 'success' },
  
  // Acciones de ventas
  { action: 'CREATE_SALE', resource: 'SALE', severity: 'high', status: 'success' },
  { action: 'CANCEL_SALE', resource: 'SALE', severity: 'high', status: 'success' },
  
  // Acciones de promotores
  { action: 'CREATE_PROMOTER', resource: 'PROMOTER', severity: 'high', status: 'success' },
  { action: 'UPDATE_PROMOTER', resource: 'PROMOTER', severity: 'high', status: 'success' },
  { action: 'DELETE_PROMOTER', resource: 'PROMOTER', severity: 'critical', status: 'success' },
  
  // Acciones de categorías
  { action: 'CREATE_CATEGORY', resource: 'CATEGORY', severity: 'medium', status: 'success' },
  { action: 'UPDATE_CATEGORY', resource: 'CATEGORY', severity: 'medium', status: 'success' },
  { action: 'DELETE_CATEGORY', resource: 'CATEGORY', severity: 'high', status: 'success' },
  
  // Acciones de venues
  { action: 'CREATE_VENUE', resource: 'VENUE', severity: 'medium', status: 'success' },
  { action: 'UPDATE_VENUE', resource: 'VENUE', severity: 'medium', status: 'success' },
  { action: 'DELETE_VENUE', resource: 'VENUE', severity: 'high', status: 'success' }
]

// Recursos con IDs de ejemplo
const resources = [
  { type: 'EVENT', ids: ['event_001', 'event_002', 'event_003', 'event_004', 'event_005'] },
  { type: 'USER', ids: ['user_001', 'user_002', 'user_003', 'user_004', 'user_005'] },
  { type: 'TICKET', ids: ['ticket_001', 'ticket_002', 'ticket_003', 'ticket_004', 'ticket_005'] },
  { type: 'PAYMENT', ids: ['payment_001', 'payment_002', 'payment_003', 'payment_004', 'payment_005'] },
  { type: 'SALE', ids: ['sale_001', 'sale_002', 'sale_003', 'sale_004', 'sale_005'] },
  { type: 'PROMOTER', ids: ['promoter_001', 'promoter_002', 'promoter_003'] },
  { type: 'CATEGORY', ids: ['cat_001', 'cat_002', 'cat_003', 'cat_004'] },
  { type: 'VENUE', ids: ['venue_001', 'venue_002', 'venue_003'] },
  { type: 'MEDIA', ids: ['media_001', 'media_002', 'media_003'] },
  { type: 'REPORT', ids: ['report_001', 'report_002', 'report_003'] }
]

// IPs de ejemplo
const ipAddresses = [
  '192.168.1.100',
  '192.168.1.101', 
  '192.168.1.102',
  '10.0.0.50',
  '172.16.0.25',
  '203.0.113.1',
  '198.51.100.1'
]

// User agents de ejemplo
const userAgents = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
]

function getRandomElement(array) {
  return array[Math.floor(Math.random() * array.length)]
}

function getRandomResourceId(resourceType) {
  const resource = resources.find(r => r.type === resourceType)
  return resource ? getRandomElement(resource.ids) : null
}

function generateDetails(action, resource, resourceId) {
  const baseDetails = {
    timestamp: new Date().toISOString(),
    userAgent: getRandomElement(userAgents),
    ip: getRandomElement(ipAddresses)
  }

  // Agregar detalles específicos según el tipo de acción
  switch (action) {
    case 'CREATE_EVENT':
      return {
        ...baseDetails,
        eventTitle: `Evento ${resourceId}`,
        eventDate: new Date(Date.now() + Math.random() * 30 * 24 * 60 * 60 * 1000).toISOString(),
        category: getRandomElement(['Concierto', 'Conferencia', 'Deportes', 'Teatro'])
      }
    
    case 'CREATE_USER':
      return {
        ...baseDetails,
        userRole: getRandomElement(['user', 'organizer', 'promoter']),
        registrationSource: 'web'
      }
    
    case 'CREATE_PAYMENT':
      return {
        ...baseDetails,
        amount: Math.floor(Math.random() * 1000) + 50,
        currency: 'COP',
        paymentMethod: getRandomElement(['credit_card', 'debit_card', 'bank_transfer'])
      }
    
    case 'ADMIN_ACCESS':
      return {
        ...baseDetails,
        section: getRandomElement(['dashboard', 'users', 'events', 'reports', 'settings']),
        duration: Math.floor(Math.random() * 300) + 30
      }
    
    case 'UPDATE_SETTINGS':
      return {
        ...baseDetails,
        settingType: getRandomElement(['email', 'payment', 'security', 'general']),
        previousValue: 'old_value',
        newValue: 'new_value'
      }
    
    default:
      return baseDetails
  }
}

async function generateRealAuditData() {
  console.log('🔧 Generando datos de auditoría reales...')
  
  try {
    // Verificar si ya existen logs
    const checkLogs = await db.query('SELECT COUNT(*) FROM audit_logs')
    const existingLogs = parseInt(checkLogs.rows[0].count)
    
    if (existingLogs > 100) {
      console.log('✅ Ya existen suficientes logs de auditoría, saltando generación')
      return
    }

    const logsToGenerate = 200 // Generar 200 logs de ejemplo
    const logs = []

    for (let i = 0; i < logsToGenerate; i++) {
      const user = getRandomElement(users)
      const actionData = getRandomElement(actions)
      const resourceId = getRandomResourceId(actionData.resource)
      
      // Generar timestamp en los últimos 30 días
      const daysAgo = Math.floor(Math.random() * 30)
      const hoursAgo = Math.floor(Math.random() * 24)
      const minutesAgo = Math.floor(Math.random() * 60)
      const timestamp = new Date(Date.now() - (daysAgo * 24 * 60 * 60 * 1000) - (hoursAgo * 60 * 60 * 1000) - (minutesAgo * 60 * 1000))

      const log = {
        user_id: user.id,
        user_name: user.name,
        user_email: user.email,
        action: actionData.action,
        resource: actionData.resource,
        resource_id: resourceId,
        details: generateDetails(actionData.action, actionData.resource, resourceId),
        ip_address: getRandomElement(ipAddresses),
        user_agent: getRandomElement(userAgents),
        severity: actionData.severity,
        status: actionData.status,
        timestamp: timestamp.toISOString()
      }

      logs.push(log)
    }

    // Insertar logs en lotes
    const batchSize = 50
    for (let i = 0; i < logs.length; i += batchSize) {
      const batch = logs.slice(i, i + batchSize)
      
      for (const log of batch) {
        await AuditService.logActivity(log)
      }
      
      console.log(`📝 Insertados ${Math.min(i + batchSize, logs.length)} de ${logs.length} logs`)
    }

    console.log('✅ Datos de auditoría reales generados exitosamente')
    console.log(`📊 Total de logs generados: ${logs.length}`)
    
  } catch (error) {
    console.error('❌ Error generando datos de auditoría:', error)
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  generateRealAuditData().then(() => {
    process.exit(0)
  }).catch(error => {
    console.error('Error:', error)
    process.exit(1)
  })
}

module.exports = { generateRealAuditData }
const AuditService = require('../services/auditService')

/**
 * Middleware para registrar actividades de auditoría
 * @param {Object} options - Opciones de configuración
 * @param {string} options.action - Acción a registrar
 * @param {string} options.resource - Tipo de recurso
 * @param {string} options.severity - Nivel de severidad (low, medium, high, critical)
 * @param {boolean} options.logRequest - Si registrar el request completo
 * @param {boolean} options.logResponse - Si registrar la respuesta
 * @param {Function} options.getResourceId - Función para extraer el ID del recurso
 * @param {Function} options.getResourceName - Función para extraer el nombre del recurso
 */
const auditMiddleware = (options = {}) => {
  return async (req, res, next) => {
    const startTime = Date.now()
    const originalSend = res.send

    // Configuración por defecto
    const config = {
      action: options.action || getActionFromMethod(req.method),
      resource: options.resource || getResourceFromPath(req.path),
      severity: options.severity || 'low',
      logRequest: options.logRequest || false,
      logResponse: options.logResponse || false,
      getResourceId: options.getResourceId || ((req) => req.params.id || req.body.id),
      getResourceName: options.getResourceName || ((req) => req.body.name || req.body.title || req.body.email)
    }

    // Capturar respuesta
    let responseBody = null
    res.send = function(body) {
      responseBody = body
      return originalSend.call(this, body)
    }

    // Función para registrar la actividad
    const logActivity = async (status = 'success', errorMessage = null) => {
      try {
        const duration = Date.now() - startTime
        const resourceId = config.getResourceId(req)
        const resourceName = config.getResourceName(req)

        const details = {
          method: req.method,
          path: req.path,
          query: req.query,
          duration: `${duration}ms`,
          statusCode: res.statusCode
        }

        // Agregar request body si está configurado
        if (config.logRequest && req.body) {
          details.requestBody = sanitizeRequestBody(req.body)
        }

        // Agregar response body si está configurado
        if (config.logResponse && responseBody) {
          details.responseBody = sanitizeResponseBody(responseBody)
        }

        // Agregar mensaje de error si existe
        if (errorMessage) {
          details.errorMessage = errorMessage
        }

        await AuditService.logActivity({
          userId: req.user?.userId || 'anonymous',
          userName: req.user?.name || 'Usuario Anónimo',
          userEmail: req.user?.email || 'anonymous@eventu.com',
          action: config.action,
          resource: config.resource,
          resourceId: resourceId,
          details: details,
          ipAddress: getClientIP(req),
          userAgent: req.get('User-Agent'),
          severity: config.severity,
          status: status
        })

        // Notificar a administradores sobre cambios importantes
        if (config.severity === 'high' || config.severity === 'critical' || 
            ['CREATE', 'UPDATE', 'DELETE'].includes(config.action)) {
          try {
            const wsServer = global.wsServer
            if (wsServer) {
              await wsServer.notifyAdminsOfChange('important_change', {
                action: config.action,
                resource: config.resource,
                resourceId: resourceId,
                resourceName: resourceName,
                user: req.user?.email || 'Usuario Anónimo',
                timestamp: new Date().toISOString(),
                severity: config.severity
              })
            }
          } catch (wsError) {
            console.error('Error notifying admins:', wsError)
          }
        }
      } catch (error) {
        console.error('Error in audit middleware:', error)
      }
    }

    // Registrar inicio de la actividad
    if (config.action === 'LOGIN' || config.action === 'REGISTER') {
      await logActivity('success')
    }

    // Interceptar errores
    const originalNext = next
    next = function(error) {
      if (error) {
        logActivity('failure', error.message)
      }
      return originalNext.call(this, error)
    }

    // Interceptar finalización exitosa
    res.on('finish', () => {
      const status = res.statusCode >= 400 ? 'failure' : 'success'
      logActivity(status)
    })

    next()
  }
}

/**
 * Middleware específico para autenticación
 */
const auditAuth = () => {
  return auditMiddleware({
    action: 'LOGIN',
    resource: 'AUTH',
    severity: 'medium',
    logRequest: false,
    getResourceId: (req) => req.body?.email,
    getResourceName: (req) => req.body?.email
  })
}

/**
 * Middleware específico para logout
 */
const auditLogout = () => {
  return auditMiddleware({
    action: 'LOGOUT',
    resource: 'AUTH',
    severity: 'low',
    logRequest: false
  })
}

/**
 * Middleware específico para operaciones CRUD
 */
const auditCRUD = (resource, options = {}) => {
  return auditMiddleware({
    action: getActionFromMethod,
    resource: resource,
    severity: options.severity || 'medium',
    logRequest: options.logRequest || true,
    logResponse: options.logResponse || false,
    ...options
  })
}

/**
 * Middleware específico para transacciones financieras
 */
const auditTransaction = () => {
  return auditMiddleware({
    action: 'TRANSACTION',
    resource: 'PAYMENT',
    severity: 'high',
    logRequest: true,
    logResponse: false,
    getResourceId: (req) => req.body?.saleId || req.body?.paymentId,
    getResourceName: (req) => `Transacción ${req.body?.amount || 'N/A'}`
  })
}

/**
 * Middleware específico para administración
 */
const auditAdmin = (resource, options = {}) => {
  return auditMiddleware({
    action: getActionFromMethod,
    resource: resource,
    severity: 'high',
    logRequest: true,
    logResponse: false,
    ...options
  })
}

// Funciones auxiliares
function getActionFromMethod(method) {
  const actions = {
    'GET': 'READ',
    'POST': 'CREATE',
    'PUT': 'UPDATE',
    'PATCH': 'UPDATE',
    'DELETE': 'DELETE'
  }
  return actions[method] || method
}

function getResourceFromPath(path) {
  const segments = path.split('/').filter(Boolean)
  if (segments.length >= 2) {
    return segments[1].toUpperCase()
  }
  return 'UNKNOWN'
}

function getClientIP(req) {
  return req.ip || 
         req.connection.remoteAddress || 
         req.socket.remoteAddress ||
         (req.connection.socket ? req.connection.socket.remoteAddress : null) ||
         req.headers['x-forwarded-for']?.split(',')[0] ||
         '127.0.0.1'
}

function sanitizeRequestBody(body) {
  if (!body) return null
  
  const sanitized = { ...body }
  
  // Remover campos sensibles
  const sensitiveFields = ['password', 'token', 'secret', 'key', 'creditCard', 'cvv']
  sensitiveFields.forEach(field => {
    if (sanitized[field]) {
      sanitized[field] = '[REDACTED]'
    }
  })
  
  return sanitized
}

function sanitizeResponseBody(body) {
  if (!body) return null
  
  try {
    const parsed = typeof body === 'string' ? JSON.parse(body) : body
    const sanitized = { ...parsed }
    
    // Remover campos sensibles de la respuesta
    const sensitiveFields = ['password', 'token', 'secret', 'key']
    sensitiveFields.forEach(field => {
      if (sanitized[field]) {
        sanitized[field] = '[REDACTED]'
      }
    })
    
    return sanitized
  } catch (error) {
    return '[NON_JSON_RESPONSE]'
  }
}

module.exports = {
  auditMiddleware,
  auditAuth,
  auditLogout,
  auditCRUD,
  auditTransaction,
  auditAdmin
}

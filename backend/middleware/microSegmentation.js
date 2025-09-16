const { microSegmentationService } = require('../services/microSegmentationService');

/**
 * Middleware de Micro-segmentación de Red
 */
const microSegmentationMiddleware = (req, res, next) => {
  const endpoint = req.path;
  const method = req.method;
  const userRole = req.user?.role || 'anonymous';
  const sourceIP = req.ip;

  // Determinar segmento de destino
  const targetSegment = microSegmentationService.determineSegment(endpoint);
  
  if (targetSegment === 'unknown') {
    // Si no se puede determinar el segmento, permitir acceso
    req.microSegmentation = {
      targetSegment: 'unknown',
      allowed: true,
      reason: 'Segmento no identificado'
    };
    return next();
  }

  // Determinar segmento de origen basado en el usuario y contexto
  const sourceSegment = determineSourceSegment(req, userRole);

  // Crear contexto para la evaluación
  const context = {
    ip: sourceIP,
    userAgent: req.headers['user-agent'],
    method: method,
    timestamp: new Date().toISOString(),
    deviceTrust: req.zeroTrust?.trustScore || 0.5,
    userRole: userRole
  };

  // Evaluar acceso entre segmentos
  const accessResult = microSegmentationService.evaluateSegmentAccess(
    sourceSegment,
    targetSegment,
    userRole,
    context
  );

  // Agregar resultado a la petición
  req.microSegmentation = {
    sourceSegment,
    targetSegment,
    ...accessResult
  };

  // Verificar si se permite el acceso
  if (!accessResult.allowed) {
    return res.status(403).json({
      success: false,
      message: 'Acceso denegado por micro-segmentación de red',
      reason: accessResult.reason,
      sourceSegment,
      targetSegment,
      policy: accessResult.policy
    });
  }

  // Verificar si requiere aprobación
  if (accessResult.requiresApproval) {
    return res.status(403).json({
      success: false,
      message: 'Acceso requiere aprobación administrativa',
      reason: accessResult.reason,
      sourceSegment,
      targetSegment,
      policy: accessResult.policy
    });
  }

  next();
};

/**
 * Determinar segmento de origen
 */
function determineSourceSegment(req, userRole) {
  // Basado en el rol del usuario
  switch (userRole) {
    case 'admin':
      return 'admin';
    case 'organizer':
      return 'organizer';
    case 'user':
      return 'users';
    default:
      // Para usuarios no autenticados, determinar basado en el endpoint
      if (req.path.startsWith('/api/auth/')) {
        return 'auth';
      }
      return 'public';
  }
}

/**
 * Middleware para rutas que requieren micro-segmentación específica
 */
const requireMicroSegmentation = (options = {}) => {
  return (req, res, next) => {
    // Aplicar middleware de micro-segmentación
    microSegmentationMiddleware(req, res, (err) => {
      if (err) return next(err);
      
      // Verificar nivel de aislamiento mínimo
      const minIsolationLevel = options.minIsolationLevel || 'low';
      const targetSegment = req.microSegmentation.targetSegment;
      
      if (targetSegment !== 'unknown') {
        const segmentInfo = microSegmentationService.getSegmentInfo(targetSegment);
        if (segmentInfo && !isIsolationLevelSufficient(segmentInfo.isolationLevel, minIsolationLevel)) {
          return res.status(403).json({
            success: false,
            message: 'Nivel de aislamiento insuficiente',
            currentLevel: segmentInfo.isolationLevel,
            requiredLevel: minIsolationLevel,
            segment: targetSegment
          });
        }
      }
      
      next();
    });
  };
};

/**
 * Verificar si el nivel de aislamiento es suficiente
 */
function isIsolationLevelSufficient(currentLevel, requiredLevel) {
  const levels = {
    'low': 1,
    'medium': 2,
    'high': 3,
    'maximum': 4
  };
  
  return levels[currentLevel] >= levels[requiredLevel];
}

/**
 * Middleware para aplicar aislamiento a un grupo de endpoints
 */
const applyIsolation = (groupId, segments) => {
  return (req, res, next) => {
    // Crear grupo de aislamiento si no existe
    if (!microSegmentationService.isolationGroups.has(groupId)) {
      microSegmentationService.createIsolationGroup(
        groupId,
        `Grupo ${groupId}`,
        `Aislamiento para ${groupId}`,
        segments
      );
      microSegmentationService.applyIsolation(groupId);
    }
    
    // Continuar con el middleware normal
    microSegmentationMiddleware(req, res, next);
  };
};

/**
 * Middleware para logging de micro-segmentación
 */
const microSegmentationLogging = (req, res, next) => {
  const originalSend = res.send;
  const originalJson = res.json;

  // Interceptar respuestas para logging
  res.send = function(data) {
    logMicroSegmentationEvent(req, res, data);
    return originalSend.call(this, data);
  };

  res.json = function(data) {
    logMicroSegmentationEvent(req, res, data);
    return originalJson.call(this, data);
  };

  next();
};

/**
 * Log de evento de micro-segmentación
 */
function logMicroSegmentationEvent(req, res, data) {
  if (req.microSegmentation) {
    const logData = {
      timestamp: new Date().toISOString(),
      method: req.method,
      endpoint: req.path,
      sourceSegment: req.microSegmentation.sourceSegment,
      targetSegment: req.microSegmentation.targetSegment,
      allowed: req.microSegmentation.allowed,
      statusCode: res.statusCode,
      userRole: req.user?.role || 'anonymous',
      ip: req.ip,
      policy: req.microSegmentation.policy
    };

    // Log solo si hay información relevante
    if (req.microSegmentation.sourceSegment !== req.microSegmentation.targetSegment) {
      console.log('🔒 Micro-segmentación:', logData);
    }
  }
}

module.exports = {
  microSegmentationMiddleware,
  requireMicroSegmentation,
  applyIsolation,
  microSegmentationLogging
};

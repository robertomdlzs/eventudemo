const { zeroTrustService } = require('../services/zeroTrustService');

/**
 * Middleware de Zero Trust Architecture
 */
const zeroTrustMiddleware = (req, res, next) => {
  // Obtener información del dispositivo
  const deviceInfo = extractDeviceInfo(req);
  const userId = req.user?.userId;
  
  if (!userId) {
    return next(); // Saltar si no hay usuario autenticado
  }

  // Obtener o crear ID de dispositivo
  let deviceId = req.headers['x-device-id'];
  if (!deviceId) {
    deviceId = zeroTrustService.registerDevice(deviceInfo, userId);
    res.setHeader('X-Device-ID', deviceId);
  }

  // Crear contexto de la petición
  const context = {
    endpoint: req.path,
    method: req.method,
    ip: req.ip,
    userAgent: req.headers['user-agent'],
    location: req.headers['x-location'] || 'unknown',
    timestamp: new Date().toISOString(),
    requestedRole: req.body?.role || req.query?.role,
    currentRole: req.user?.role
  };

  // Evaluar acceso basado en Zero Trust
  const accessResult = zeroTrustService.evaluateAccess({
    userId,
    deviceId,
    endpoint: req.path,
    context
  });

  // Agregar resultado a la petición
  req.zeroTrust = accessResult;
  req.deviceId = deviceId;

  // Verificar si se permite el acceso
  if (!accessResult.allowed) {
    return res.status(403).json({
      success: false,
      message: 'Acceso denegado por políticas de Zero Trust',
      reason: accessResult.reason,
      trustScore: accessResult.trustScore,
      requiredActions: accessResult.requiredActions
    });
  }

  // Verificar acciones requeridas
  if (accessResult.requiredActions.includes('mfa')) {
    return res.status(403).json({
      success: false,
      message: 'Se requiere autenticación de dos factores',
      requiredActions: ['mfa'],
      trustScore: accessResult.trustScore
    });
  }

  // Actualizar sesión de usuario
  zeroTrustService.updateUserSession(userId, {
    lastEndpoint: req.path,
    lastMethod: req.method,
    lastIP: req.ip
  });

  next();
};

/**
 * Extraer información del dispositivo
 */
function extractDeviceInfo(req) {
  return {
    userAgent: req.headers['user-agent'] || '',
    acceptLanguage: req.headers['accept-language'] || '',
    acceptEncoding: req.headers['accept-encoding'] || '',
    connection: req.headers['connection'] || '',
    upgradeInsecureRequests: req.headers['upgrade-insecure-requests'] || '',
    secFetchSite: req.headers['sec-fetch-site'] || '',
    secFetchMode: req.headers['sec-fetch-mode'] || '',
    secFetchDest: req.headers['sec-fetch-dest'] || '',
    referer: req.headers['referer'] || '',
    origin: req.headers['origin'] || '',
    host: req.headers['host'] || '',
    ip: req.ip || req.connection.remoteAddress || 'unknown'
  };
}

/**
 * Middleware para rutas que requieren Zero Trust
 */
const requireZeroTrust = (options = {}) => {
  return (req, res, next) => {
    // Aplicar middleware de Zero Trust
    zeroTrustMiddleware(req, res, (err) => {
      if (err) return next(err);
      
      // Verificar nivel de confianza mínimo
      const minTrustScore = options.minTrustScore || 0.7;
      if (req.zeroTrust.trustScore < minTrustScore) {
        return res.status(403).json({
          success: false,
          message: 'Nivel de confianza insuficiente',
          trustScore: req.zeroTrust.trustScore,
          requiredTrustScore: minTrustScore
        });
      }
      
      next();
    });
  };
};

/**
 * Middleware para registrar dispositivo
 */
const registerDeviceMiddleware = (req, res, next) => {
  if (req.user && req.method === 'POST' && req.path === '/api/auth/login') {
    const deviceInfo = extractDeviceInfo(req);
    const deviceId = zeroTrustService.registerDevice(deviceInfo, req.user.userId);
    
    // Crear sesión de usuario
    const sessionId = zeroTrustService.createUserSession(req.user.userId, deviceId, {
      loginTime: new Date().toISOString(),
      ip: req.ip
    });
    
    res.setHeader('X-Device-ID', deviceId);
    res.setHeader('X-Session-ID', sessionId);
  }
  
  next();
};

module.exports = {
  zeroTrustMiddleware,
  requireZeroTrust,
  registerDeviceMiddleware
};

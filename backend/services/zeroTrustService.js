const winston = require('winston');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const fs = require('fs');
const path = require('path');

/**
 * Zero Trust Architecture Service
 */
class ZeroTrustService {
  constructor() {
    this.deviceRegistry = new Map();
    this.userSessions = new Map();
    this.trustScores = new Map();
    this.policies = [];
    this.riskFactors = new Map();
    
    // Configurar logger
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
      ),
      transports: [
        new winston.transports.File({ 
          filename: path.join(__dirname, '../logs/zerotrust.log'),
          maxsize: 10 * 1024 * 1024, // 10MB
          maxFiles: 5
        }),
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.colorize(),
            winston.format.simple()
          )
        })
      ]
    });

    // Cargar políticas de Zero Trust
    this.loadZeroTrustPolicies();
    
    // Inicializar factores de riesgo
    this.initializeRiskFactors();
    
    this.logger.info('🛡️ Zero Trust Service inicializado');
  }

  /**
   * Cargar políticas de Zero Trust
   */
  loadZeroTrustPolicies() {
    this.policies = [
      {
        id: 'device_verification',
        name: 'Verificación de Dispositivo',
        description: 'Verificar que el dispositivo es conocido y confiable',
        conditions: [
          { field: 'device_fingerprint', operator: 'exists', value: true },
          { field: 'device_trust_score', operator: 'greater_than', value: 0.7 }
        ],
        action: 'allow',
        priority: 1
      },
      {
        id: 'location_verification',
        name: 'Verificación de Ubicación',
        description: 'Verificar que la ubicación es conocida y confiable',
        conditions: [
          { field: 'location_trust_score', operator: 'greater_than', value: 0.6 },
          { field: 'location_anomaly', operator: 'equals', value: false }
        ],
        action: 'allow',
        priority: 2
      },
      {
        id: 'behavior_verification',
        name: 'Verificación de Comportamiento',
        description: 'Verificar que el comportamiento es normal',
        conditions: [
          { field: 'behavior_trust_score', operator: 'greater_than', value: 0.8 },
          { field: 'anomaly_detected', operator: 'equals', value: false }
        ],
        action: 'allow',
        priority: 3
      },
      {
        id: 'time_based_access',
        name: 'Acceso Basado en Tiempo',
        description: 'Restringir acceso fuera de horarios normales',
        conditions: [
          { field: 'access_time', operator: 'between', value: ['09:00', '18:00'] },
          { field: 'weekend_access', operator: 'equals', value: false }
        ],
        action: 'allow',
        priority: 4
      },
      {
        id: 'privilege_escalation',
        name: 'Escalación de Privilegios',
        description: 'Requiere verificación adicional para acceso administrativo',
        conditions: [
          { field: 'requested_role', operator: 'equals', value: 'admin' },
          { field: 'current_role', operator: 'not_equals', value: 'admin' }
        ],
        action: 'require_mfa',
        priority: 5
      }
    ];

    this.logger.info(`📋 ${this.policies.length} políticas de Zero Trust cargadas`);
  }

  /**
   * Inicializar factores de riesgo
   */
  initializeRiskFactors() {
    this.riskFactors.set('new_device', 0.3);
    this.riskFactors.set('new_location', 0.4);
    this.riskFactors.set('unusual_time', 0.2);
    this.riskFactors.set('failed_attempts', 0.5);
    this.riskFactors.set('suspicious_behavior', 0.6);
    this.riskFactors.set('privilege_escalation', 0.8);
    this.riskFactors.set('data_exfiltration', 0.9);
    this.riskFactors.set('malware_detected', 1.0);
  }

  /**
   * Registrar dispositivo
   */
  registerDevice(deviceInfo, userId) {
    const deviceFingerprint = this.generateDeviceFingerprint(deviceInfo);
    const deviceId = crypto.createHash('sha256').update(deviceFingerprint).digest('hex');
    
    const device = {
      id: deviceId,
      userId: userId,
      fingerprint: deviceFingerprint,
      info: deviceInfo,
      firstSeen: new Date().toISOString(),
      lastSeen: new Date().toISOString(),
      trustScore: 0.5, // Score inicial neutral
      isTrusted: false,
      riskFactors: []
    };

    this.deviceRegistry.set(deviceId, device);
    
    this.logger.info('📱 Dispositivo registrado', { 
      deviceId, 
      userId, 
      fingerprint: deviceFingerprint.substring(0, 16) + '...' 
    });

    return deviceId;
  }

  /**
   * Generar huella digital del dispositivo
   */
  generateDeviceFingerprint(deviceInfo) {
    const components = [
      deviceInfo.userAgent || '',
      deviceInfo.screenResolution || '',
      deviceInfo.timezone || '',
      deviceInfo.language || '',
      deviceInfo.platform || '',
      deviceInfo.cookieEnabled || '',
      deviceInfo.doNotTrack || ''
    ];

    return crypto.createHash('sha256').update(components.join('|')).digest('hex');
  }

  /**
   * Evaluar confianza de dispositivo
   */
  evaluateDeviceTrust(deviceId, context) {
    const device = this.deviceRegistry.get(deviceId);
    if (!device) {
      return { trustScore: 0, isTrusted: false, reason: 'Dispositivo no registrado' };
    }

    let trustScore = device.trustScore;
    const riskFactors = [];

    // Evaluar factores de riesgo
    if (this.isNewDevice(device)) {
      trustScore -= this.riskFactors.get('new_device');
      riskFactors.push('new_device');
    }

    if (this.isNewLocation(device, context)) {
      trustScore -= this.riskFactors.get('new_location');
      riskFactors.push('new_location');
    }

    if (this.isUnusualTime(context)) {
      trustScore -= this.riskFactors.get('unusual_time');
      riskFactors.push('unusual_time');
    }

    if (this.hasSuspiciousBehavior(device, context)) {
      trustScore -= this.riskFactors.get('suspicious_behavior');
      riskFactors.push('suspicious_behavior');
    }

    // Normalizar score entre 0 y 1
    trustScore = Math.max(0, Math.min(1, trustScore));

    // Actualizar dispositivo
    device.trustScore = trustScore;
    device.isTrusted = trustScore > 0.7;
    device.lastSeen = new Date().toISOString();
    device.riskFactors = riskFactors;

    return {
      trustScore: trustScore,
      isTrusted: device.isTrusted,
      riskFactors: riskFactors,
      reason: riskFactors.length > 0 ? `Factores de riesgo: ${riskFactors.join(', ')}` : 'Dispositivo confiable'
    };
  }

  /**
   * Verificar si es un dispositivo nuevo
   */
  isNewDevice(device) {
    const daysSinceFirstSeen = (new Date() - new Date(device.firstSeen)) / (1000 * 60 * 60 * 24);
    return daysSinceFirstSeen < 7; // Menos de 7 días
  }

  /**
   * Verificar si es una ubicación nueva
   */
  isNewLocation(device, context) {
    // Implementación simplificada - en producción usar geolocalización
    const knownLocations = device.info.knownLocations || [];
    const currentLocation = context.location || 'unknown';
    
    return !knownLocations.includes(currentLocation);
  }

  /**
   * Verificar si es un horario inusual
   */
  isUnusualTime(context) {
    const hour = new Date().getHours();
    const isWeekend = new Date().getDay() === 0 || new Date().getDay() === 6;
    
    // Horario normal: 9 AM - 6 PM, días laborables
    return hour < 9 || hour > 18 || isWeekend;
  }

  /**
   * Verificar comportamiento sospechoso
   */
  hasSuspiciousBehavior(device, context) {
    // Implementación simplificada - en producción usar ML
    const suspiciousPatterns = [
      'rapid_requests',
      'unusual_endpoints',
      'data_exfiltration',
      'privilege_escalation'
    ];

    return suspiciousPatterns.some(pattern => 
      context.behavior && context.behavior.includes(pattern)
    );
  }

  /**
   * Evaluar acceso basado en Zero Trust
   */
  evaluateAccess(request) {
    const { userId, deviceId, endpoint, context } = request;
    
    // Obtener información del usuario
    const userSession = this.userSessions.get(userId);
    if (!userSession) {
      return {
        allowed: false,
        reason: 'Sesión de usuario no encontrada',
        trustScore: 0,
        requiredActions: ['login']
      };
    }

    // Evaluar confianza del dispositivo
    const deviceTrust = this.evaluateDeviceTrust(deviceId, context);
    
    // Evaluar políticas de Zero Trust
    const policyResult = this.evaluatePolicies(request, deviceTrust);
    
    // Calcular score de confianza general
    const overallTrustScore = this.calculateOverallTrustScore(deviceTrust, policyResult, userSession);
    
    // Determinar si se permite el acceso
    const allowed = overallTrustScore > 0.7 && policyResult.allowed;
    
    // Registrar evaluación
    this.logEvaluation(userId, deviceId, endpoint, {
      allowed,
      trustScore: overallTrustScore,
      deviceTrust,
      policyResult,
      context
    });

    return {
      allowed,
      reason: allowed ? 'Acceso autorizado' : 'Acceso denegado por políticas de Zero Trust',
      trustScore: overallTrustScore,
      requiredActions: policyResult.requiredActions || [],
      deviceTrust,
      policyResult
    };
  }

  /**
   * Evaluar políticas de Zero Trust
   */
  evaluatePolicies(request, deviceTrust) {
    const { endpoint, context } = request;
    let allowed = true;
    const requiredActions = [];
    const violatedPolicies = [];

    // Ordenar políticas por prioridad
    const sortedPolicies = this.policies.sort((a, b) => a.priority - b.priority);

    for (const policy of sortedPolicies) {
      const policyResult = this.evaluatePolicy(policy, request, deviceTrust);
      
      if (!policyResult.passed) {
        allowed = false;
        violatedPolicies.push(policy.id);
        
        if (policy.action === 'require_mfa') {
          requiredActions.push('mfa');
        } else if (policy.action === 'block') {
          requiredActions.push('block');
        }
      }
    }

    return {
      allowed,
      requiredActions,
      violatedPolicies,
      evaluatedPolicies: sortedPolicies.length
    };
  }

  /**
   * Evaluar política individual
   */
  evaluatePolicy(policy, request, deviceTrust) {
    const { endpoint, context } = request;
    
    for (const condition of policy.conditions) {
      if (!this.evaluateCondition(condition, request, deviceTrust)) {
        return { passed: false, reason: `Condición fallida: ${condition.field}` };
      }
    }

    return { passed: true };
  }

  /**
   * Evaluar condición individual
   */
  evaluateCondition(condition, request, deviceTrust) {
    const { field, operator, value } = condition;
    
    switch (field) {
      case 'device_trust_score':
        return this.compareValues(deviceTrust.trustScore, operator, value);
      case 'location_trust_score':
        return this.compareValues(request.context?.locationTrustScore || 0.5, operator, value);
      case 'behavior_trust_score':
        return this.compareValues(request.context?.behaviorTrustScore || 0.5, operator, value);
      case 'access_time':
        const currentHour = new Date().getHours();
        return this.compareValues(currentHour, operator, value);
      case 'requested_role':
        return this.compareValues(request.context?.requestedRole, operator, value);
      case 'current_role':
        return this.compareValues(request.context?.currentRole, operator, value);
      default:
        return true;
    }
  }

  /**
   * Comparar valores
   */
  compareValues(actual, operator, expected) {
    switch (operator) {
      case 'equals':
        return actual === expected;
      case 'not_equals':
        return actual !== expected;
      case 'greater_than':
        return actual > expected;
      case 'less_than':
        return actual < expected;
      case 'between':
        return actual >= expected[0] && actual <= expected[1];
      case 'exists':
        return actual !== undefined && actual !== null;
      default:
        return true;
    }
  }

  /**
   * Calcular score de confianza general
   */
  calculateOverallTrustScore(deviceTrust, policyResult, userSession) {
    let score = 0.5; // Score base

    // Factor de confianza del dispositivo (40%)
    score += deviceTrust.trustScore * 0.4;

    // Factor de políticas (30%)
    if (policyResult.allowed) {
      score += 0.3;
    }

    // Factor de sesión del usuario (30%)
    if (userSession.isActive && userSession.lastActivity > Date.now() - 3600000) { // 1 hora
      score += 0.3;
    }

    return Math.max(0, Math.min(1, score));
  }

  /**
   * Registrar evaluación
   */
  logEvaluation(userId, deviceId, endpoint, result) {
    const evaluation = {
      timestamp: new Date().toISOString(),
      userId,
      deviceId,
      endpoint,
      result
    };

    this.logger.info('🔍 Evaluación Zero Trust', evaluation);
  }

  /**
   * Crear sesión de usuario
   */
  createUserSession(userId, deviceId, context) {
    const sessionId = crypto.randomUUID();
    
    const session = {
      id: sessionId,
      userId,
      deviceId,
      createdAt: new Date().toISOString(),
      lastActivity: Date.now(),
      isActive: true,
      context,
      trustScore: 0.5
    };

    this.userSessions.set(userId, session);
    
    this.logger.info('👤 Sesión de usuario creada', { userId, sessionId, deviceId });
    
    return sessionId;
  }

  /**
   * Actualizar sesión de usuario
   */
  updateUserSession(userId, activity) {
    const session = this.userSessions.get(userId);
    if (session) {
      session.lastActivity = Date.now();
      session.context = { ...session.context, ...activity };
      
      this.logger.debug('👤 Sesión de usuario actualizada', { userId, activity });
    }
  }

  /**
   * Cerrar sesión de usuario
   */
  closeUserSession(userId) {
    const session = this.userSessions.get(userId);
    if (session) {
      session.isActive = false;
      session.closedAt = new Date().toISOString();
      
      this.logger.info('👤 Sesión de usuario cerrada', { userId, sessionId: session.id });
    }
  }

  /**
   * Obtener estadísticas de Zero Trust
   */
  getStats() {
    const activeSessions = Array.from(this.userSessions.values()).filter(s => s.isActive);
    const trustedDevices = Array.from(this.deviceRegistry.values()).filter(d => d.isTrusted);
    
    return {
      totalDevices: this.deviceRegistry.size,
      trustedDevices: trustedDevices.length,
      activeSessions: activeSessions.length,
      totalSessions: this.userSessions.size,
      policies: this.policies.length,
      riskFactors: this.riskFactors.size
    };
  }

  /**
   * Obtener dispositivos de usuario
   */
  getUserDevices(userId) {
    return Array.from(this.deviceRegistry.values())
      .filter(device => device.userId === userId)
      .map(device => ({
        id: device.id,
        fingerprint: device.fingerprint.substring(0, 16) + '...',
        firstSeen: device.firstSeen,
        lastSeen: device.lastSeen,
        trustScore: device.trustScore,
        isTrusted: device.isTrusted,
        riskFactors: device.riskFactors
      }));
  }

  /**
   * Revocar confianza de dispositivo
   */
  revokeDeviceTrust(deviceId) {
    const device = this.deviceRegistry.get(deviceId);
    if (device) {
      device.isTrusted = false;
      device.trustScore = 0;
      device.riskFactors.push('manually_revoked');
      
      this.logger.warn('🚫 Confianza de dispositivo revocada', { deviceId, userId: device.userId });
    }
  }
}

// Instancia singleton
const zeroTrustService = new ZeroTrustService();

module.exports = {
  ZeroTrustService,
  zeroTrustService
};

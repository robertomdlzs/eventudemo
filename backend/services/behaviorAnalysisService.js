const winston = require('winston');
const fs = require('fs');
const path = require('path');

/**
 * Behavior Analysis Service
 */
class BehaviorAnalysisService {
  constructor() {
    this.userProfiles = new Map();
    this.behaviorPatterns = new Map();
    this.anomalies = new Map();
    this.baselines = new Map();
    this.mlModels = new Map();
    
    // Configurar logger
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
      ),
      transports: [
        new winston.transports.File({ 
          filename: path.join(__dirname, '../logs/behavior.log'),
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

    // Inicializar modelos de comportamiento
    this.initializeBehaviorModels();
    
    // Configurar análisis automático
    this.setupAutomaticAnalysis();
    
    this.logger.info('🧠 Behavior Analysis Service inicializado');
  }

  /**
   * Inicializar modelos de comportamiento
   */
  initializeBehaviorModels() {
    // Modelo de comportamiento de usuario
    this.mlModels.set('user_behavior', {
      name: 'Comportamiento de Usuario',
      description: 'Analiza patrones de comportamiento de usuarios individuales',
      features: [
        'login_times',
        'endpoints_accessed',
        'session_duration',
        'request_frequency',
        'geographic_location',
        'device_fingerprint'
      ],
      threshold: 0.7,
      isActive: true
    });

    // Modelo de comportamiento de red
    this.mlModels.set('network_behavior', {
      name: 'Comportamiento de Red',
      description: 'Analiza patrones de tráfico de red',
      features: [
        'request_volume',
        'response_times',
        'error_rates',
        'bandwidth_usage',
        'connection_patterns'
      ],
      threshold: 0.8,
      isActive: true
    });

    // Modelo de comportamiento de aplicación
    this.mlModels.set('application_behavior', {
      name: 'Comportamiento de Aplicación',
      description: 'Analiza patrones de uso de la aplicación',
      features: [
        'feature_usage',
        'navigation_patterns',
        'data_access_patterns',
        'transaction_patterns'
      ],
      threshold: 0.6,
      isActive: true
    });

    this.logger.info(`🧠 ${this.mlModels.size} modelos de comportamiento inicializados`);
  }

  /**
   * Configurar análisis automático
   */
  setupAutomaticAnalysis() {
    // Analizar comportamiento cada 5 minutos
    setInterval(() => {
      this.analyzeUserBehavior();
    }, 5 * 60 * 1000);

    // Analizar anomalías cada 15 minutos
    setInterval(() => {
      this.detectAnomalies();
    }, 15 * 60 * 1000);

    // Actualizar baselines cada hora
    setInterval(() => {
      this.updateBaselines();
    }, 60 * 60 * 1000);
  }

  /**
   * Registrar actividad de usuario
   */
  recordUserActivity(userId, activity) {
    if (!this.userProfiles.has(userId)) {
      this.userProfiles.set(userId, {
        userId: userId,
        activities: [],
        patterns: {},
        baseline: {},
        anomalies: [],
        riskScore: 0.5,
        lastActivity: new Date().toISOString(),
        isActive: true
      });
    }

    const profile = this.userProfiles.get(userId);
    
    // Agregar actividad
    const activityRecord = {
      ...activity,
      timestamp: new Date().toISOString(),
      id: this.generateActivityId()
    };
    
    profile.activities.push(activityRecord);
    profile.lastActivity = activityRecord.timestamp;

    // Mantener solo las últimas 1000 actividades
    if (profile.activities.length > 1000) {
      profile.activities = profile.activities.slice(-1000);
    }

    // Actualizar patrones
    this.updateUserPatterns(userId, activityRecord);

    this.logger.debug('📊 Actividad de usuario registrada', { userId, activity: activity.type });
  }

  /**
   * Actualizar patrones de usuario
   */
  updateUserPatterns(userId, activity) {
    const profile = this.userProfiles.get(userId);
    if (!profile) return;

    const patterns = profile.patterns;

    // Patrón de horarios de acceso
    const hour = new Date(activity.timestamp).getHours();
    if (!patterns.accessHours) patterns.accessHours = {};
    patterns.accessHours[hour] = (patterns.accessHours[hour] || 0) + 1;

    // Patrón de endpoints
    if (activity.endpoint) {
      if (!patterns.endpoints) patterns.endpoints = {};
      patterns.endpoints[activity.endpoint] = (patterns.endpoints[activity.endpoint] || 0) + 1;
    }

    // Patrón de ubicación
    if (activity.location) {
      if (!patterns.locations) patterns.locations = {};
      patterns.locations[activity.location] = (patterns.locations[activity.location] || 0) + 1;
    }

    // Patrón de dispositivos
    if (activity.deviceFingerprint) {
      if (!patterns.devices) patterns.devices = {};
      patterns.devices[activity.deviceFingerprint] = (patterns.devices[activity.deviceFingerprint] || 0) + 1;
    }

    // Patrón de frecuencia de requests
    if (!patterns.requestFrequency) patterns.requestFrequency = [];
    patterns.requestFrequency.push({
      timestamp: activity.timestamp,
      count: 1
    });

    // Mantener solo las últimas 100 entradas de frecuencia
    if (patterns.requestFrequency.length > 100) {
      patterns.requestFrequency = patterns.requestFrequency.slice(-100);
    }
  }

  /**
   * Analizar comportamiento de usuario
   */
  analyzeUserBehavior() {
    for (const [userId, profile] of this.userProfiles) {
      if (!profile.isActive) continue;

      // Calcular score de riesgo
      const riskScore = this.calculateRiskScore(userId, profile);
      profile.riskScore = riskScore;

      // Detectar cambios en el comportamiento
      const behaviorChange = this.detectBehaviorChange(userId, profile);
      
      if (behaviorChange.isSignificant) {
        this.logger.warn('🔄 Cambio significativo de comportamiento detectado', {
          userId,
          changeType: behaviorChange.type,
          confidence: behaviorChange.confidence,
          riskScore
        });

        // Crear anomalía
        this.createAnomaly(userId, 'behavior_change', behaviorChange);
      }
    }
  }

  /**
   * Calcular score de riesgo
   */
  calculateRiskScore(userId, profile) {
    let riskScore = 0.5; // Score base

    // Factor: Horarios inusuales
    const unusualHours = this.calculateUnusualHours(profile);
    riskScore += unusualHours * 0.2;

    // Factor: Ubicaciones inusuales
    const unusualLocations = this.calculateUnusualLocations(profile);
    riskScore += unusualLocations * 0.3;

    // Factor: Dispositivos inusuales
    const unusualDevices = this.calculateUnusualDevices(profile);
    riskScore += unusualDevices * 0.2;

    // Factor: Frecuencia inusual
    const unusualFrequency = this.calculateUnusualFrequency(profile);
    riskScore += unusualFrequency * 0.2;

    // Factor: Endpoints inusuales
    const unusualEndpoints = this.calculateUnusualEndpoints(profile);
    riskScore += unusualEndpoints * 0.1;

    return Math.max(0, Math.min(1, riskScore));
  }

  /**
   * Calcular horarios inusuales
   */
  calculateUnusualHours(profile) {
    const patterns = profile.patterns;
    if (!patterns.accessHours) return 0;

    const currentHour = new Date().getHours();
    const totalAccess = Object.values(patterns.accessHours).reduce((sum, count) => sum + count, 0);
    const currentHourAccess = patterns.accessHours[currentHour] || 0;
    
    const expectedAccess = totalAccess / 24; // Distribución uniforme
    const deviation = Math.abs(currentHourAccess - expectedAccess) / expectedAccess;
    
    return Math.min(1, deviation);
  }

  /**
   * Calcular ubicaciones inusuales
   */
  calculateUnusualLocations(profile) {
    const patterns = profile.patterns;
    if (!patterns.locations) return 0;

    const locations = Object.keys(patterns.locations);
    if (locations.length <= 1) return 0;

    // Si hay más de 3 ubicaciones diferentes, es inusual
    return locations.length > 3 ? 0.5 : 0;
  }

  /**
   * Calcular dispositivos inusuales
   */
  calculateUnusualDevices(profile) {
    const patterns = profile.patterns;
    if (!patterns.devices) return 0;

    const devices = Object.keys(patterns.devices);
    if (devices.length <= 1) return 0;

    // Si hay más de 2 dispositivos diferentes, es inusual
    return devices.length > 2 ? 0.3 : 0;
  }

  /**
   * Calcular frecuencia inusual
   */
  calculateUnusualFrequency(profile) {
    const patterns = profile.patterns;
    if (!patterns.requestFrequency || patterns.requestFrequency.length < 10) return 0;

    const recentFreq = patterns.requestFrequency.slice(-10);
    const avgFreq = recentFreq.reduce((sum, entry) => sum + entry.count, 0) / recentFreq.length;
    
    // Si la frecuencia es 3x mayor que el promedio, es inusual
    return avgFreq > 3 ? 0.4 : 0;
  }

  /**
   * Calcular endpoints inusuales
   */
  calculateUnusualEndpoints(profile) {
    const patterns = profile.patterns;
    if (!patterns.endpoints) return 0;

    const endpoints = Object.keys(patterns.endpoints);
    const suspiciousEndpoints = endpoints.filter(ep => 
      ep.includes('/admin') || 
      ep.includes('/debug') || 
      ep.includes('/test') ||
      ep.includes('/backup')
    );

    return suspiciousEndpoints.length > 0 ? 0.5 : 0;
  }

  /**
   * Detectar cambios en el comportamiento
   */
  detectBehaviorChange(userId, profile) {
    const baseline = this.baselines.get(userId);
    if (!baseline) {
      // Crear baseline inicial
      this.baselines.set(userId, this.createBaseline(profile));
      return { isSignificant: false, type: 'baseline_created' };
    }

    const changes = [];

    // Cambio en horarios de acceso
    const hourChange = this.detectHourChange(profile, baseline);
    if (hourChange.isSignificant) {
      changes.push({ type: 'access_hours', confidence: hourChange.confidence });
    }

    // Cambio en ubicación
    const locationChange = this.detectLocationChange(profile, baseline);
    if (locationChange.isSignificant) {
      changes.push({ type: 'location', confidence: locationChange.confidence });
    }

    // Cambio en frecuencia
    const frequencyChange = this.detectFrequencyChange(profile, baseline);
    if (frequencyChange.isSignificant) {
      changes.push({ type: 'frequency', confidence: frequencyChange.confidence });
    }

    if (changes.length > 0) {
      const maxConfidence = Math.max(...changes.map(c => c.confidence));
      return {
        isSignificant: true,
        type: 'multiple_changes',
        changes: changes,
        confidence: maxConfidence
      };
    }

    return { isSignificant: false, type: 'no_change' };
  }

  /**
   * Detectar cambio en horarios
   */
  detectHourChange(profile, baseline) {
    const currentHours = profile.patterns.accessHours || {};
    const baselineHours = baseline.accessHours || {};

    let deviation = 0;
    let totalDeviation = 0;

    for (const hour in currentHours) {
      const current = currentHours[hour];
      const baseline = baselineHours[hour] || 0;
      const diff = Math.abs(current - baseline);
      totalDeviation += diff;
    }

    const avgDeviation = totalDeviation / Object.keys(currentHours).length;
    const isSignificant = avgDeviation > 2; // Umbral de significancia

    return {
      isSignificant,
      confidence: Math.min(1, avgDeviation / 5)
    };
  }

  /**
   * Detectar cambio en ubicación
   */
  detectLocationChange(profile, baseline) {
    const currentLocations = Object.keys(profile.patterns.locations || {});
    const baselineLocations = Object.keys(baseline.locations || {});

    const newLocations = currentLocations.filter(loc => !baselineLocations.includes(loc));
    const isSignificant = newLocations.length > 0;

    return {
      isSignificant,
      confidence: newLocations.length / Math.max(1, currentLocations.length)
    };
  }

  /**
   * Detectar cambio en frecuencia
   */
  detectFrequencyChange(profile, baseline) {
    const currentFreq = profile.patterns.requestFrequency || [];
    const baselineFreq = baseline.requestFrequency || [];

    if (currentFreq.length < 5 || baselineFreq.length < 5) {
      return { isSignificant: false, confidence: 0 };
    }

    const currentAvg = currentFreq.slice(-5).reduce((sum, entry) => sum + entry.count, 0) / 5;
    const baselineAvg = baselineFreq.slice(-5).reduce((sum, entry) => sum + entry.count, 0) / 5;

    const deviation = Math.abs(currentAvg - baselineAvg) / baselineAvg;
    const isSignificant = deviation > 0.5; // 50% de desviación

    return {
      isSignificant,
      confidence: Math.min(1, deviation)
    };
  }

  /**
   * Crear baseline de comportamiento
   */
  createBaseline(profile) {
    return {
      accessHours: { ...profile.patterns.accessHours },
      locations: { ...profile.patterns.locations },
      devices: { ...profile.patterns.devices },
      requestFrequency: [...(profile.patterns.requestFrequency || [])],
      endpoints: { ...profile.patterns.endpoints },
      createdAt: new Date().toISOString()
    };
  }

  /**
   * Crear anomalía
   */
  createAnomaly(userId, type, details) {
    const anomalyId = this.generateAnomalyId();
    
    const anomaly = {
      id: anomalyId,
      userId: userId,
      type: type,
      details: details,
      timestamp: new Date().toISOString(),
      severity: this.calculateAnomalySeverity(type, details),
      isResolved: false
    };

    this.anomalies.set(anomalyId, anomaly);

    // Agregar a perfil de usuario
    const profile = this.userProfiles.get(userId);
    if (profile) {
      profile.anomalies.push(anomalyId);
    }

    this.logger.warn('🚨 Anomalía de comportamiento detectada', anomaly);
  }

  /**
   * Calcular severidad de anomalía
   */
  calculateAnomalySeverity(type, details) {
    switch (type) {
      case 'behavior_change':
        if (details.confidence > 0.8) return 'high';
        if (details.confidence > 0.5) return 'medium';
        return 'low';
      case 'unusual_access':
        return 'high';
      case 'suspicious_activity':
        return 'critical';
      default:
        return 'low';
    }
  }

  /**
   * Detectar anomalías
   */
  detectAnomalies() {
    for (const [userId, profile] of this.userProfiles) {
      if (!profile.isActive) continue;

      // Detectar acceso inusual
      if (this.isUnusualAccess(profile)) {
        this.createAnomaly(userId, 'unusual_access', {
          reason: 'Acceso en horario inusual',
          confidence: 0.7
        });
      }

      // Detectar actividad sospechosa
      if (this.isSuspiciousActivity(profile)) {
        this.createAnomaly(userId, 'suspicious_activity', {
          reason: 'Actividad sospechosa detectada',
          confidence: 0.9
        });
      }
    }
  }

  /**
   * Verificar acceso inusual
   */
  isUnusualAccess(profile) {
    const hour = new Date().getHours();
    const patterns = profile.patterns;
    
    if (!patterns.accessHours) return false;
    
    const totalAccess = Object.values(patterns.accessHours).reduce((sum, count) => sum + count, 0);
    const currentHourAccess = patterns.accessHours[hour] || 0;
    
    // Si es la primera vez que accede en esta hora, es inusual
    return currentHourAccess === 0 && totalAccess > 10;
  }

  /**
   * Verificar actividad sospechosa
   */
  isSuspiciousActivity(profile) {
    const patterns = profile.patterns;
    
    // Verificar endpoints sospechosos
    if (patterns.endpoints) {
      const suspiciousEndpoints = Object.keys(patterns.endpoints).filter(ep => 
        ep.includes('/admin') || ep.includes('/debug')
      );
      
      if (suspiciousEndpoints.length > 0) {
        return true;
      }
    }

    // Verificar frecuencia muy alta
    if (patterns.requestFrequency) {
      const recentFreq = patterns.requestFrequency.slice(-5);
      const avgFreq = recentFreq.reduce((sum, entry) => sum + entry.count, 0) / recentFreq.length;
      
      if (avgFreq > 10) { // Más de 10 requests por minuto
        return true;
      }
    }

    return false;
  }

  /**
   * Actualizar baselines
   */
  updateBaselines() {
    for (const [userId, profile] of this.userProfiles) {
      if (profile.isActive && profile.activities.length > 100) {
        const newBaseline = this.createBaseline(profile);
        this.baselines.set(userId, newBaseline);
        
        this.logger.info(`📊 Baseline actualizado para usuario: ${userId}`);
      }
    }
  }

  /**
   * Obtener perfil de usuario
   */
  getUserProfile(userId) {
    return this.userProfiles.get(userId);
  }

  /**
   * Obtener anomalías de usuario
   */
  getUserAnomalies(userId) {
    const profile = this.userProfiles.get(userId);
    if (!profile) return [];

    return profile.anomalies.map(anomalyId => this.anomalies.get(anomalyId)).filter(Boolean);
  }

  /**
   * Obtener estadísticas de comportamiento
   */
  getStats() {
    const totalUsers = this.userProfiles.size;
    const activeUsers = Array.from(this.userProfiles.values()).filter(p => p.isActive).length;
    const totalAnomalies = this.anomalies.size;
    const unresolvedAnomalies = Array.from(this.anomalies.values()).filter(a => !a.isResolved).length;

    return {
      totalUsers,
      activeUsers,
      totalAnomalies,
      unresolvedAnomalies,
      models: this.mlModels.size
    };
  }

  /**
   * Generar ID de actividad
   */
  generateActivityId() {
    return 'activity_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }

  /**
   * Generar ID de anomalía
   */
  generateAnomalyId() {
    return 'anomaly_' + Date.now() + '_' + Math.random().toString(36).substr(2, 9);
  }
}

// Instancia singleton
const behaviorAnalysisService = new BehaviorAnalysisService();

module.exports = {
  BehaviorAnalysisService,
  behaviorAnalysisService
};

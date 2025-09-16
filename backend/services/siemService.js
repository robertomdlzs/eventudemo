const winston = require('winston');
const moment = require('moment-timezone');
const fs = require('fs');
const path = require('path');

/**
 * SIEM (Security Information and Event Management) Service
 */
class SIEMService {
  constructor() {
    this.events = [];
    this.correlations = new Map();
    this.threats = new Map();
    this.incidents = [];
    this.rules = [];
    
    // Configurar logger SIEM
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
      ),
      transports: [
        new winston.transports.File({ 
          filename: path.join(__dirname, '../logs/siem.log'),
          maxsize: 50 * 1024 * 1024, // 50MB
          maxFiles: 10
        }),
        new winston.transports.Console({
          format: winston.format.combine(
            winston.format.colorize(),
            winston.format.simple()
          )
        })
      ]
    });

    // Cargar reglas de correlación
    this.loadCorrelationRules();
    
    // Inicializar procesamiento de eventos
    this.startEventProcessing();
    
    this.logger.info('🔍 SIEM Service inicializado');
  }

  /**
   * Cargar reglas de correlación
   */
  loadCorrelationRules() {
    this.rules = [
      {
        id: 'multiple_failed_logins',
        name: 'Múltiples intentos de login fallidos',
        description: 'Detectar múltiples intentos de login fallidos desde la misma IP',
        conditions: [
          { field: 'type', operator: 'equals', value: 'failed_login' },
          { field: 'ip', operator: 'same_ip', value: null },
          { field: 'count', operator: 'greater_than', value: 5 },
          { field: 'time_window', operator: 'within', value: 300 } // 5 minutos
        ],
        severity: 'high',
        action: 'block_ip'
      },
      {
        id: 'sql_injection_attempts',
        name: 'Intentos de SQL Injection',
        description: 'Detectar múltiples intentos de SQL injection',
        conditions: [
          { field: 'type', operator: 'equals', value: 'sql_injection_attempt' },
          { field: 'ip', operator: 'same_ip', value: null },
          { field: 'count', operator: 'greater_than', value: 3 },
          { field: 'time_window', operator: 'within', value: 600 } // 10 minutos
        ],
        severity: 'critical',
        action: 'block_ip'
      },
      {
        id: 'privilege_escalation',
        name: 'Escalación de privilegios',
        description: 'Detectar intentos de escalación de privilegios',
        conditions: [
          { field: 'type', operator: 'equals', value: 'unauthorized_access' },
          { field: 'endpoint', operator: 'contains', value: '/admin' },
          { field: 'user', operator: 'not_equals', value: 'admin' },
          { field: 'count', operator: 'greater_than', value: 2 },
          { field: 'time_window', operator: 'within', value: 1800 } // 30 minutos
        ],
        severity: 'high',
        action: 'alert_admin'
      },
      {
        id: 'data_exfiltration',
        name: 'Exfiltración de datos',
        description: 'Detectar patrones de exfiltración de datos',
        conditions: [
          { field: 'type', operator: 'equals', value: 'data_access' },
          { field: 'data_size', operator: 'greater_than', value: 1000000 }, // 1MB
          { field: 'count', operator: 'greater_than', value: 10 },
          { field: 'time_window', operator: 'within', value: 3600 } // 1 hora
        ],
        severity: 'critical',
        action: 'block_user'
      },
      {
        id: 'malware_upload',
        name: 'Subida de malware',
        description: 'Detectar subida de archivos maliciosos',
        conditions: [
          { field: 'type', operator: 'equals', value: 'malware_detected' },
          { field: 'count', operator: 'greater_than', value: 1 },
          { field: 'time_window', operator: 'within', value: 3600 } // 1 hora
        ],
        severity: 'critical',
        action: 'quarantine_user'
      }
    ];

    this.logger.info(`📋 ${this.rules.length} reglas de correlación cargadas`);
  }

  /**
   * Iniciar procesamiento de eventos
   */
  startEventProcessing() {
    // Procesar eventos cada 30 segundos
    setInterval(() => {
      this.processEvents();
    }, 30000);

    // Correlacionar eventos cada 2 minutos
    setInterval(() => {
      this.correlateEvents();
    }, 120000);

    // Generar reportes cada hora
    setInterval(() => {
      this.generateReports();
    }, 3600000);
  }

  /**
   * Ingresar evento al SIEM
   */
  ingestEvent(event) {
    const siemEvent = {
      id: this.generateEventId(),
      timestamp: moment().toISOString(),
      type: event.type,
      severity: event.severity || 'low',
      source: event.source || 'application',
      ip: event.ip,
      user: event.user,
      endpoint: event.endpoint,
      details: event.details,
      raw: event
    };

    this.events.push(siemEvent);
    
    // Mantener solo los últimos 10000 eventos en memoria
    if (this.events.length > 10000) {
      this.events = this.events.slice(-10000);
    }

    this.logger.info('📥 Evento ingresado al SIEM', { 
      id: siemEvent.id, 
      type: siemEvent.type, 
      severity: siemEvent.severity 
    });

    return siemEvent.id;
  }

  /**
   * Procesar eventos
   */
  processEvents() {
    const now = moment();
    const recentEvents = this.events.filter(event => 
      moment(event.timestamp).isAfter(now.subtract(1, 'hour'))
    );

    // Agrupar eventos por IP
    const eventsByIP = this.groupEventsByIP(recentEvents);
    
    // Agrupar eventos por usuario
    const eventsByUser = this.groupEventsByUser(recentEvents);

    // Procesar cada grupo
    this.processEventGroups(eventsByIP, 'ip');
    this.processEventGroups(eventsByUser, 'user');
  }

  /**
   * Agrupar eventos por IP
   */
  groupEventsByIP(events) {
    const groups = new Map();
    
    events.forEach(event => {
      if (event.ip) {
        if (!groups.has(event.ip)) {
          groups.set(event.ip, []);
        }
        groups.get(event.ip).push(event);
      }
    });

    return groups;
  }

  /**
   * Agrupar eventos por usuario
   */
  groupEventsByUser(events) {
    const groups = new Map();
    
    events.forEach(event => {
      if (event.user && event.user !== 'anonymous') {
        if (!groups.has(event.user)) {
          groups.set(event.user, []);
        }
        groups.get(event.user).push(event);
      }
    });

    return groups;
  }

  /**
   * Procesar grupos de eventos
   */
  processEventGroups(groups, groupType) {
    groups.forEach((events, key) => {
      // Agrupar por tipo de evento
      const eventsByType = this.groupEventsByType(events);
      
      // Aplicar reglas de correlación
      this.applyCorrelationRules(eventsByType, key, groupType);
    });
  }

  /**
   * Agrupar eventos por tipo
   */
  groupEventsByType(events) {
    const groups = new Map();
    
    events.forEach(event => {
      if (!groups.has(event.type)) {
        groups.set(event.type, []);
      }
      groups.get(event.type).push(event);
    });

    return groups;
  }

  /**
   * Aplicar reglas de correlación
   */
  applyCorrelationRules(eventsByType, key, groupType) {
    this.rules.forEach(rule => {
      const matchingEvents = this.findMatchingEvents(eventsByType, rule);
      
      if (matchingEvents.length > 0) {
        this.createCorrelation(rule, matchingEvents, key, groupType);
      }
    });
  }

  /**
   * Encontrar eventos que coincidan con la regla
   */
  findMatchingEvents(eventsByType, rule) {
    const matchingEvents = [];
    
    rule.conditions.forEach(condition => {
      if (condition.field === 'type' && condition.operator === 'equals') {
        const events = eventsByType.get(condition.value) || [];
        matchingEvents.push(...events);
      }
    });

    // Aplicar filtros adicionales
    return matchingEvents.filter(event => {
      return this.evaluateCondition(event, rule.conditions);
    });
  }

  /**
   * Evaluar condición
   */
  evaluateCondition(event, conditions) {
    return conditions.every(condition => {
      switch (condition.operator) {
        case 'equals':
          return event[condition.field] === condition.value;
        case 'greater_than':
          return event[condition.field] > condition.value;
        case 'contains':
          return event[condition.field] && event[condition.field].includes(condition.value);
        case 'not_equals':
          return event[condition.field] !== condition.value;
        case 'within':
          // Verificar si el evento está dentro del tiempo especificado
          const eventTime = moment(event.timestamp);
          const now = moment();
          return eventTime.isAfter(now.subtract(condition.value, 'seconds'));
        default:
          return true;
      }
    });
  }

  /**
   * Crear correlación
   */
  createCorrelation(rule, events, key, groupType) {
    const correlation = {
      id: this.generateCorrelationId(),
      ruleId: rule.id,
      ruleName: rule.name,
      severity: rule.severity,
      timestamp: moment().toISOString(),
      groupType: groupType,
      groupKey: key,
      eventCount: events.length,
      events: events.map(e => e.id),
      action: rule.action,
      status: 'active'
    };

    this.correlations.set(correlation.id, correlation);
    
    this.logger.warn('🔗 Correlación creada', correlation);
    
    // Ejecutar acción
    this.executeCorrelationAction(correlation);
  }

  /**
   * Ejecutar acción de correlación
   */
  executeCorrelationAction(correlation) {
    switch (correlation.action) {
      case 'block_ip':
        this.blockIP(correlation.groupKey);
        break;
      case 'block_user':
        this.blockUser(correlation.groupKey);
        break;
      case 'alert_admin':
        this.sendAdminAlert(correlation);
        break;
      case 'quarantine_user':
        this.quarantineUser(correlation.groupKey);
        break;
      default:
        this.logger.warn('Acción de correlación no reconocida:', correlation.action);
    }
  }

  /**
   * Bloquear IP
   */
  blockIP(ip) {
    // Esta funcionalidad se integrará con el WAF
    this.logger.warn(`🚫 IP bloqueada por SIEM: ${ip}`);
  }

  /**
   * Bloquear usuario
   */
  blockUser(userId) {
    // Esta funcionalidad se integrará con el sistema de usuarios
    this.logger.warn(`🚫 Usuario bloqueado por SIEM: ${userId}`);
  }

  /**
   * Enviar alerta a administrador
   */
  sendAdminAlert(correlation) {
    this.logger.error('🚨 ALERTA DE ADMINISTRADOR', correlation);
    // Integrar con el sistema de alertas
  }

  /**
   * Poner usuario en cuarentena
   */
  quarantineUser(userId) {
    this.logger.warn(`🔒 Usuario en cuarentena por SIEM: ${userId}`);
  }

  /**
   * Correlacionar eventos
   */
  correlateEvents() {
    const now = moment();
    const recentEvents = this.events.filter(event => 
      moment(event.timestamp).isAfter(now.subtract(24, 'hours'))
    );

    // Buscar patrones temporales
    this.findTemporalPatterns(recentEvents);
    
    // Buscar patrones de comportamiento
    this.findBehavioralPatterns(recentEvents);
    
    // Buscar anomalías
    this.findAnomalies(recentEvents);
  }

  /**
   * Encontrar patrones temporales
   */
  findTemporalPatterns(events) {
    // Agrupar por hora del día
    const hourlyGroups = new Map();
    
    events.forEach(event => {
      const hour = moment(event.timestamp).hour();
      if (!hourlyGroups.has(hour)) {
        hourlyGroups.set(hour, []);
      }
      hourlyGroups.get(hour).push(event);
    });

    // Detectar horas con actividad anómala
    const avgEventsPerHour = events.length / 24;
    
    hourlyGroups.forEach((hourEvents, hour) => {
      if (hourEvents.length > avgEventsPerHour * 2) {
        this.logger.warn(`⏰ Actividad anómala detectada en hora ${hour}: ${hourEvents.length} eventos`);
      }
    });
  }

  /**
   * Encontrar patrones de comportamiento
   */
  findBehavioralPatterns(events) {
    // Agrupar por usuario
    const userGroups = this.groupEventsByUser(events);
    
    userGroups.forEach((userEvents, userId) => {
      // Analizar patrones de acceso
      const accessPatterns = this.analyzeAccessPatterns(userEvents);
      
      // Detectar cambios en el comportamiento
      if (this.hasBehaviorChanged(accessPatterns, userId)) {
        this.logger.warn(`👤 Cambio de comportamiento detectado para usuario: ${userId}`);
      }
    });
  }

  /**
   * Analizar patrones de acceso
   */
  analyzeAccessPatterns(events) {
    const patterns = {
      endpoints: new Set(),
      ips: new Set(),
      times: [],
      userAgents: new Set()
    };

    events.forEach(event => {
      if (event.endpoint) patterns.endpoints.add(event.endpoint);
      if (event.ip) patterns.ips.add(event.ip);
      if (event.timestamp) patterns.times.push(moment(event.timestamp));
      if (event.details?.userAgent) patterns.userAgents.add(event.details.userAgent);
    });

    return patterns;
  }

  /**
   * Verificar si el comportamiento ha cambiado
   */
  hasBehaviorChanged(currentPatterns, userId) {
    // Comparar con patrones históricos
    // Esta es una implementación simplificada
    return currentPatterns.ips.size > 3 || currentPatterns.endpoints.size > 10;
  }

  /**
   * Encontrar anomalías
   */
  findAnomalies(events) {
    // Detectar eventos con severidad alta o crítica
    const highSeverityEvents = events.filter(event => 
      event.severity === 'high' || event.severity === 'critical'
    );

    if (highSeverityEvents.length > 0) {
      this.logger.warn(`🚨 ${highSeverityEvents.length} eventos de alta severidad detectados`);
    }
  }

  /**
   * Generar reportes
   */
  generateReports() {
    const now = moment();
    const last24Hours = this.events.filter(event => 
      moment(event.timestamp).isAfter(now.subtract(24, 'hours'))
    );

    const report = {
      timestamp: now.toISOString(),
      period: '24h',
      totalEvents: last24Hours.length,
      eventsByType: this.getEventsByType(last24Hours),
      eventsBySeverity: this.getEventsBySeverity(last24Hours),
      topIPs: this.getTopIPs(last24Hours),
      topUsers: this.getTopUsers(last24Hours),
      correlations: this.correlations.size,
      threats: this.threats.size
    };

    this.logger.info('📊 Reporte SIEM generado', report);
    
    // Guardar reporte
    this.saveReport(report);
  }

  /**
   * Obtener eventos por tipo
   */
  getEventsByType(events) {
    const types = {};
    events.forEach(event => {
      types[event.type] = (types[event.type] || 0) + 1;
    });
    return types;
  }

  /**
   * Obtener eventos por severidad
   */
  getEventsBySeverity(events) {
    const severities = {};
    events.forEach(event => {
      severities[event.severity] = (severities[event.severity] || 0) + 1;
    });
    return severities;
  }

  /**
   * Obtener IPs más activas
   */
  getTopIPs(events) {
    const ips = {};
    events.forEach(event => {
      if (event.ip) {
        ips[event.ip] = (ips[event.ip] || 0) + 1;
      }
    });
    
    return Object.entries(ips)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .map(([ip, count]) => ({ ip, count }));
  }

  /**
   * Obtener usuarios más activos
   */
  getTopUsers(events) {
    const users = {};
    events.forEach(event => {
      if (event.user && event.user !== 'anonymous') {
        users[event.user] = (users[event.user] || 0) + 1;
      }
    });
    
    return Object.entries(users)
      .sort(([,a], [,b]) => b - a)
      .slice(0, 10)
      .map(([user, count]) => ({ user, count }));
  }

  /**
   * Guardar reporte
   */
  saveReport(report) {
    const reportPath = path.join(__dirname, '../logs/siem-reports');
    if (!fs.existsSync(reportPath)) {
      fs.mkdirSync(reportPath, { recursive: true });
    }

    const filename = `siem-report-${moment().format('YYYY-MM-DD-HH')}.json`;
    const filepath = path.join(reportPath, filename);
    
    fs.writeFileSync(filepath, JSON.stringify(report, null, 2));
  }

  /**
   * Generar ID de evento
   */
  generateEventId() {
    return `evt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Generar ID de correlación
   */
  generateCorrelationId() {
    return `corr_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Obtener estadísticas del SIEM
   */
  getStats() {
    const now = moment();
    const last24Hours = this.events.filter(event => 
      moment(event.timestamp).isAfter(now.subtract(24, 'hours'))
    );

    return {
      totalEvents: this.events.length,
      eventsLast24h: last24Hours.length,
      activeCorrelations: this.correlations.size,
      activeThreats: this.threats.size,
      incidents: this.incidents.length,
      rules: this.rules.length
    };
  }
}

// Instancia singleton
const siemService = new SIEMService();

module.exports = {
  SIEMService,
  siemService
};

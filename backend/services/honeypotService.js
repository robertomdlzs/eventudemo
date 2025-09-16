const winston = require('winston');
const crypto = require('crypto');
const fs = require('fs');
const path = require('path');

/**
 * Honeypot Service
 */
class HoneypotService {
  constructor() {
    this.honeypots = new Map();
    this.interactions = new Map();
    this.attackers = new Map();
    this.decoys = new Map();
    this.traps = new Map();
    
    // Configurar logger
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
      ),
      transports: [
        new winston.transports.File({ 
          filename: path.join(__dirname, '../logs/honeypot.log'),
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

    // Inicializar honeypots
    this.initializeHoneypots();
    
    // Configurar limpieza automática
    this.setupCleanup();
    
    this.logger.info('🍯 Honeypot Service inicializado');
  }

  /**
   * Inicializar honeypots
   */
  initializeHoneypots() {
    // Honeypot de login falso
    this.honeypots.set('fake_login', {
      id: 'fake_login',
      name: 'Login Falso',
      description: 'Formulario de login que no existe realmente',
      endpoint: '/api/auth/fake-login',
      type: 'form',
      severity: 'high',
      isActive: true,
      bait: {
        username: 'admin',
        password: 'password123',
        email: 'admin@eventu.com'
      }
    });

    // Honeypot de admin panel
    this.honeypots.set('fake_admin', {
      id: 'fake_admin',
      name: 'Panel de Admin Falso',
      description: 'Panel de administración que no existe',
      endpoint: '/admin/fake-panel',
      type: 'web',
      severity: 'critical',
      isActive: true,
      bait: {
        title: 'Panel de Administración - Eventu',
        description: 'Acceso administrativo completo'
      }
    });

    // Honeypot de base de datos
    this.honeypots.set('fake_database', {
      id: 'fake_database',
      name: 'Base de Datos Falsa',
      description: 'Endpoint que simula acceso a base de datos',
      endpoint: '/api/db/fake-query',
      type: 'database',
      severity: 'critical',
      isActive: true,
      bait: {
        query: 'SELECT * FROM users',
        table: 'users',
        columns: ['id', 'username', 'password', 'email']
      }
    });

    // Honeypot de archivos
    this.honeypots.set('fake_files', {
      id: 'fake_files',
      name: 'Archivos Falsos',
      description: 'Archivos que no existen pero parecen importantes',
      endpoint: '/files/fake-important',
      type: 'file',
      severity: 'medium',
      isActive: true,
      bait: {
        filename: 'backup.sql',
        size: '2.5MB',
        description: 'Backup completo de la base de datos'
      }
    });

    // Honeypot de API keys
    this.honeypots.set('fake_api_keys', {
      id: 'fake_api_keys',
      name: 'API Keys Falsas',
      description: 'Endpoint que expone API keys falsas',
      endpoint: '/api/keys/fake-keys',
      type: 'api',
      severity: 'high',
      isActive: true,
      bait: {
        keys: [
          'sk-1234567890abcdef',
          'ak-abcdef1234567890',
          'pk-9876543210fedcba'
        ]
      }
    });

    // Honeypot de configuración
    this.honeypots.set('fake_config', {
      id: 'fake_config',
      name: 'Configuración Falsa',
      description: 'Archivo de configuración falso',
      endpoint: '/config/fake.env',
      type: 'config',
      severity: 'high',
      isActive: true,
      bait: {
        content: `
DB_HOST=localhost
DB_USER=admin
DB_PASSWORD=super_secret_password
JWT_SECRET=very_secret_jwt_key
API_KEY=secret_api_key_123
        `
      }
    });

    this.logger.info(`🍯 ${this.honeypots.size} honeypots inicializados`);
  }

  /**
   * Configurar limpieza automática
   */
  setupCleanup() {
    // Limpiar datos antiguos cada 24 horas
    setInterval(() => {
      this.cleanupOldData();
    }, 24 * 60 * 60 * 1000);
  }

  /**
   * Procesar interacción con honeypot
   */
  processInteraction(honeypotId, request) {
    const honeypot = this.honeypots.get(honeypotId);
    if (!honeypot || !honeypot.isActive) {
      return null;
    }

    const interactionId = this.generateInteractionId();
    const attackerIP = request.ip;
    const userAgent = request.headers['user-agent'] || 'unknown';
    const timestamp = new Date().toISOString();

    // Crear registro de interacción
    const interaction = {
      id: interactionId,
      honeypotId: honeypotId,
      honeypotName: honeypot.name,
      attackerIP: attackerIP,
      userAgent: userAgent,
      timestamp: timestamp,
      request: {
        method: request.method,
        path: request.path,
        headers: request.headers,
        body: request.body,
        query: request.query
      },
      severity: honeypot.severity,
      isProcessed: false
    };

    this.interactions.set(interactionId, interaction);

    // Actualizar información del atacante
    this.updateAttackerInfo(attackerIP, honeypot, interaction);

    // Log de la interacción
    this.logger.warn('🍯 HONEYPOT ACTIVADO', {
      honeypot: honeypot.name,
      attackerIP: attackerIP,
      userAgent: userAgent,
      severity: honeypot.severity
    });

    // Generar respuesta engañosa
    const response = this.generateDeceptiveResponse(honeypot, interaction);

    return {
      interaction,
      response
    };
  }

  /**
   * Actualizar información del atacante
   */
  updateAttackerInfo(attackerIP, honeypot, interaction) {
    if (!this.attackers.has(attackerIP)) {
      this.attackers.set(attackerIP, {
        ip: attackerIP,
        firstSeen: interaction.timestamp,
        lastSeen: interaction.timestamp,
        interactions: [],
        honeypotsHit: new Set(),
        severity: honeypot.severity,
        isBlocked: false
      });
    }

    const attacker = this.attackers.get(attackerIP);
    attacker.lastSeen = interaction.timestamp;
    attacker.interactions.push(interaction.id);
    attacker.honeypotsHit.add(honeypot.id);

    // Actualizar severidad si es mayor
    if (this.getSeverityLevel(honeypot.severity) > this.getSeverityLevel(attacker.severity)) {
      attacker.severity = honeypot.severity;
    }

    // Bloquear si ha interactuado con múltiples honeypots críticos
    if (attacker.honeypotsHit.size >= 2 && honeypot.severity === 'critical') {
      attacker.isBlocked = true;
      this.logger.error('🚫 ATACANTE BLOQUEADO', {
        ip: attackerIP,
        honeypotsHit: Array.from(attacker.honeypotsHit),
        severity: attacker.severity
      });
    }
  }

  /**
   * Generar respuesta engañosa
   */
  generateDeceptiveResponse(honeypot, interaction) {
    switch (honeypot.type) {
      case 'form':
        return this.generateFormResponse(honeypot);
      case 'web':
        return this.generateWebResponse(honeypot);
      case 'database':
        return this.generateDatabaseResponse(honeypot);
      case 'file':
        return this.generateFileResponse(honeypot);
      case 'api':
        return this.generateApiResponse(honeypot);
      case 'config':
        return this.generateConfigResponse(honeypot);
      default:
        return { success: true, message: 'Acceso autorizado' };
    }
  }

  /**
   * Generar respuesta de formulario
   */
  generateFormResponse(honeypot) {
    return {
      success: true,
      message: 'Login exitoso',
      token: this.generateFakeToken(),
      user: {
        id: 1,
        username: 'admin',
        role: 'admin',
        email: 'admin@eventu.com'
      }
    };
  }

  /**
   * Generar respuesta web
   */
  generateWebResponse(honeypot) {
    return `
      <!DOCTYPE html>
      <html>
      <head>
        <title>${honeypot.bait.title}</title>
        <style>
          body { font-family: Arial, sans-serif; margin: 40px; }
          .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
          .content { margin-top: 20px; }
        </style>
      </head>
      <body>
        <div class="header">
          <h1>${honeypot.bait.title}</h1>
          <p>${honeypot.bait.description}</p>
        </div>
        <div class="content">
          <h2>Panel de Control</h2>
          <ul>
            <li><a href="/admin/users">Gestionar Usuarios</a></li>
            <li><a href="/admin/events">Gestionar Eventos</a></li>
            <li><a href="/admin/settings">Configuración</a></li>
            <li><a href="/admin/backup">Backup</a></li>
          </ul>
        </div>
      </body>
      </html>
    `;
  }

  /**
   * Generar respuesta de base de datos
   */
  generateDatabaseResponse(honeypot) {
    return {
      success: true,
      query: honeypot.bait.query,
      results: [
        { id: 1, username: 'admin', password: 'hashed_password_123', email: 'admin@eventu.com' },
        { id: 2, username: 'user1', password: 'hashed_password_456', email: 'user1@eventu.com' },
        { id: 3, username: 'user2', password: 'hashed_password_789', email: 'user2@eventu.com' }
      ],
      count: 3
    };
  }

  /**
   * Generar respuesta de archivo
   */
  generateFileResponse(honeypot) {
    return {
      success: true,
      filename: honeypot.bait.filename,
      size: honeypot.bait.size,
      content: this.generateFakeFileContent(),
      description: honeypot.bait.description
    };
  }

  /**
   * Generar respuesta de API
   */
  generateApiResponse(honeypot) {
    return {
      success: true,
      message: 'API keys obtenidas exitosamente',
      keys: honeypot.bait.keys,
      usage: 'Estas keys proporcionan acceso completo a la API'
    };
  }

  /**
   * Generar respuesta de configuración
   */
  generateConfigResponse(honeypot) {
    return {
      success: true,
      filename: 'config.env',
      content: honeypot.bait.content,
      message: 'Archivo de configuración obtenido'
    };
  }

  /**
   * Generar token falso
   */
  generateFakeToken() {
    return 'fake_jwt_token_' + crypto.randomBytes(32).toString('hex');
  }

  /**
   * Generar contenido de archivo falso
   */
  generateFakeFileContent() {
    return `
-- Backup de Base de Datos Eventu
-- Generado: ${new Date().toISOString()}

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  role VARCHAR(20) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password, email, role) VALUES
('admin', 'hashed_admin_password', 'admin@eventu.com', 'admin'),
('user1', 'hashed_user_password', 'user1@eventu.com', 'user'),
('user2', 'hashed_user_password', 'user2@eventu.com', 'user');
    `;
  }

  /**
   * Obtener nivel de severidad
   */
  getSeverityLevel(severity) {
    const levels = {
      'low': 1,
      'medium': 2,
      'high': 3,
      'critical': 4
    };
    return levels[severity] || 0;
  }

  /**
   * Generar ID de interacción
   */
  generateInteractionId() {
    return 'honeypot_' + Date.now() + '_' + crypto.randomBytes(8).toString('hex');
  }

  /**
   * Obtener estadísticas de honeypots
   */
  getStats() {
    const totalInteractions = this.interactions.size;
    const totalAttackers = this.attackers.size;
    const blockedAttackers = Array.from(this.attackers.values()).filter(a => a.isBlocked).length;
    const activeHoneypots = Array.from(this.honeypots.values()).filter(h => h.isActive).length;

    // Estadísticas por severidad
    const interactionsBySeverity = {};
    for (const interaction of this.interactions.values()) {
      interactionsBySeverity[interaction.severity] = (interactionsBySeverity[interaction.severity] || 0) + 1;
    }

    return {
      totalHoneypots: this.honeypots.size,
      activeHoneypots,
      totalInteractions,
      totalAttackers,
      blockedAttackers,
      interactionsBySeverity
    };
  }

  /**
   * Obtener interacciones recientes
   */
  getRecentInteractions(limit = 50) {
    const interactions = Array.from(this.interactions.values())
      .sort((a, b) => new Date(b.timestamp) - new Date(a.timestamp))
      .slice(0, limit);

    return interactions.map(interaction => ({
      id: interaction.id,
      honeypotName: interaction.honeypotName,
      attackerIP: interaction.attackerIP,
      userAgent: interaction.userAgent,
      timestamp: interaction.timestamp,
      severity: interaction.severity
    }));
  }

  /**
   * Obtener atacantes más activos
   */
  getTopAttackers(limit = 10) {
    return Array.from(this.attackers.values())
      .sort((a, b) => b.interactions.length - a.interactions.length)
      .slice(0, limit)
      .map(attacker => ({
        ip: attacker.ip,
        firstSeen: attacker.firstSeen,
        lastSeen: attacker.lastSeen,
        interactions: attacker.interactions.length,
        honeypotsHit: Array.from(attacker.honeypotsHit),
        severity: attacker.severity,
        isBlocked: attacker.isBlocked
      }));
  }

  /**
   * Limpiar datos antiguos
   */
  cleanupOldData() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 30); // 30 días

    let cleanedInteractions = 0;
    let cleanedAttackers = 0;

    // Limpiar interacciones antiguas
    for (const [id, interaction] of this.interactions) {
      if (new Date(interaction.timestamp) < cutoffDate) {
        this.interactions.delete(id);
        cleanedInteractions++;
      }
    }

    // Limpiar atacantes inactivos
    for (const [ip, attacker] of this.attackers) {
      if (new Date(attacker.lastSeen) < cutoffDate && !attacker.isBlocked) {
        this.attackers.delete(ip);
        cleanedAttackers++;
      }
    }

    this.logger.info(`🧹 Limpieza de honeypots: ${cleanedInteractions} interacciones y ${cleanedAttackers} atacantes eliminados`);
  }

  /**
   * Activar/desactivar honeypot
   */
  toggleHoneypot(honeypotId, isActive) {
    const honeypot = this.honeypots.get(honeypotId);
    if (honeypot) {
      honeypot.isActive = isActive;
      this.logger.info(`🍯 Honeypot ${isActive ? 'activado' : 'desactivado'}: ${honeypot.name}`);
    }
  }

  /**
   * Crear honeypot personalizado
   */
  createCustomHoneypot(config) {
    const honeypotId = 'custom_' + Date.now();
    
    const honeypot = {
      id: honeypotId,
      name: config.name,
      description: config.description,
      endpoint: config.endpoint,
      type: config.type,
      severity: config.severity || 'medium',
      isActive: true,
      bait: config.bait || {}
    };

    this.honeypots.set(honeypotId, honeypot);
    
    this.logger.info(`🍯 Honeypot personalizado creado: ${honeypot.name}`);
    
    return honeypotId;
  }
}

// Instancia singleton
const honeypotService = new HoneypotService();

module.exports = {
  HoneypotService,
  honeypotService
};

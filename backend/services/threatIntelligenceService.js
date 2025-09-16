const winston = require('winston');
const axios = require('axios');
const cron = require('node-cron');
const fs = require('fs');
const path = require('path');

/**
 * Threat Intelligence Service
 */
class ThreatIntelligenceService {
  constructor() {
    this.threatFeeds = new Map();
    this.threatIndicators = new Map();
    this.blockedIPs = new Set();
    self.blockedDomains = new Set();
    this.maliciousHashes = new Set();
    this.threatActors = new Map();
    this.campaigns = new Map();
    
    // Configurar logger
    this.logger = winston.createLogger({
      level: 'info',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json()
      ),
      transports: [
        new winston.transports.File({ 
          filename: path.join(__dirname, '../logs/threatintelligence.log'),
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

    // Configurar feeds de threat intelligence
    this.setupThreatFeeds();
    
    // Inicializar actualizaciones automáticas
    this.setupAutomaticUpdates();
    
    this.logger.info('🕵️ Threat Intelligence Service inicializado');
  }

  /**
   * Configurar feeds de threat intelligence
   */
  setupThreatFeeds() {
    // Feed de IPs maliciosas (ejemplo con datos simulados)
    this.threatFeeds.set('malicious_ips', {
      id: 'malicious_ips',
      name: 'IPs Maliciosas',
      description: 'Lista de IPs conocidas por actividades maliciosas',
      url: 'https://api.threatintel.example.com/ips',
      type: 'ip',
      updateInterval: '0 */6 * * *', // Cada 6 horas
      lastUpdate: null,
      isActive: true,
      apiKey: process.env.THREAT_INTEL_API_KEY
    });

    // Feed de dominios maliciosos
    this.threatFeeds.set('malicious_domains', {
      id: 'malicious_domains',
      name: 'Dominios Maliciosos',
      description: 'Lista de dominios conocidos por actividades maliciosas',
      url: 'https://api.threatintel.example.com/domains',
      type: 'domain',
      updateInterval: '0 */12 * * *', // Cada 12 horas
      lastUpdate: null,
      isActive: true,
      apiKey: process.env.THREAT_INTEL_API_KEY
    });

    // Feed de hashes de malware
    this.threatFeeds.set('malware_hashes', {
      id: 'malware_hashes',
      name: 'Hashes de Malware',
      description: 'Lista de hashes de archivos maliciosos',
      url: 'https://api.threatintel.example.com/malware',
      type: 'hash',
      updateInterval: '0 0 * * *', // Diario
      lastUpdate: null,
      isActive: true,
      apiKey: process.env.THREAT_INTEL_API_KEY
    });

    // Feed de threat actors
    this.threatFeeds.set('threat_actors', {
      id: 'threat_actors',
      name: 'Threat Actors',
      description: 'Información sobre grupos de amenazas',
      url: 'https://api.threatintel.example.com/actors',
      type: 'actor',
      updateInterval: '0 0 * * 0', // Semanal
      lastUpdate: null,
      isActive: true,
      apiKey: process.env.THREAT_INTEL_API_KEY
    });

    // Feed de campañas de ataque
    this.threatFeeds.set('attack_campaigns', {
      id: 'attack_campaigns',
      name: 'Campañas de Ataque',
      description: 'Información sobre campañas de ataque activas',
      url: 'https://api.threatintel.example.com/campaigns',
      type: 'campaign',
      updateInterval: '0 */4 * * *', // Cada 4 horas
      lastUpdate: null,
      isActive: true,
      apiKey: process.env.THREAT_INTEL_API_KEY
    });

    this.logger.info(`🕵️ ${this.threatFeeds.size} feeds de threat intelligence configurados`);
  }

  /**
   * Configurar actualizaciones automáticas
   */
  setupAutomaticUpdates() {
    // Actualizar todos los feeds cada hora
    cron.schedule('0 * * * *', () => {
      this.updateAllFeeds();
    });

    // Limpiar datos antiguos diariamente
    cron.schedule('0 2 * * *', () => {
      this.cleanupOldData();
    });

    this.logger.info('⏰ Actualizaciones automáticas de threat intelligence configuradas');
  }

  /**
   * Actualizar todos los feeds
   */
  async updateAllFeeds() {
    this.logger.info('🔄 Iniciando actualización de feeds de threat intelligence');
    
    const updatePromises = Array.from(this.threatFeeds.values()).map(feed => 
      this.updateFeed(feed.id)
    );

    try {
      await Promise.allSettled(updatePromises);
      this.logger.info('✅ Actualización de feeds completada');
    } catch (error) {
      this.logger.error('❌ Error en actualización de feeds:', error);
    }
  }

  /**
   * Actualizar feed específico
   */
  async updateFeed(feedId) {
    const feed = this.threatFeeds.get(feedId);
    if (!feed || !feed.isActive) {
      return;
    }

    try {
      this.logger.info(`🔄 Actualizando feed: ${feed.name}`);

      // Simular datos de threat intelligence (en producción usar APIs reales)
      const threatData = await this.fetchThreatData(feed);
      
      if (threatData) {
        await this.processThreatData(feed, threatData);
        feed.lastUpdate = new Date().toISOString();
        
        this.logger.info(`✅ Feed actualizado: ${feed.name} - ${threatData.length} indicadores`);
      }

    } catch (error) {
      this.logger.error(`❌ Error actualizando feed ${feed.name}:`, error);
    }
  }

  /**
   * Obtener datos de threat intelligence (simulado)
   */
  async fetchThreatData(feed) {
    // En producción, hacer llamadas reales a APIs de threat intelligence
    // Por ahora, simular datos
    
    switch (feed.type) {
      case 'ip':
        return this.getSimulatedMaliciousIPs();
      case 'domain':
        return this.getSimulatedMaliciousDomains();
      case 'hash':
        return this.getSimulatedMalwareHashes();
      case 'actor':
        return this.getSimulatedThreatActors();
      case 'campaign':
        return this.getSimulatedAttackCampaigns();
      default:
        return [];
    }
  }

  /**
   * Obtener IPs maliciosas simuladas
   */
  getSimulatedMaliciousIPs() {
    return [
      { ip: '192.168.1.100', type: 'botnet', severity: 'high', source: 'simulated' },
      { ip: '10.0.0.50', type: 'scanner', severity: 'medium', source: 'simulated' },
      { ip: '172.16.0.25', type: 'malware', severity: 'critical', source: 'simulated' },
      { ip: '203.0.113.1', type: 'phishing', severity: 'high', source: 'simulated' },
      { ip: '198.51.100.1', type: 'spam', severity: 'medium', source: 'simulated' }
    ];
  }

  /**
   * Obtener dominios maliciosos simulados
   */
  getSimulatedMaliciousDomains() {
    return [
      { domain: 'malicious-site.com', type: 'phishing', severity: 'high', source: 'simulated' },
      { domain: 'fake-bank.net', type: 'phishing', severity: 'critical', source: 'simulated' },
      { domain: 'malware-distribution.org', type: 'malware', severity: 'critical', source: 'simulated' },
      { domain: 'spam-sender.info', type: 'spam', severity: 'medium', source: 'simulated' }
    ];
  }

  /**
   * Obtener hashes de malware simulados
   */
  getSimulatedMalwareHashes() {
    return [
      { hash: 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', type: 'trojan', severity: 'critical' },
      { hash: 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1', type: 'ransomware', severity: 'critical' },
      { hash: 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2', type: 'backdoor', severity: 'high' }
    ];
  }

  /**
   * Obtener threat actors simulados
   */
  getSimulatedThreatActors() {
    return [
      {
        name: 'APT-Example',
        description: 'Advanced Persistent Threat group',
        targets: ['financial', 'government'],
        techniques: ['phishing', 'malware', 'lateral_movement'],
        severity: 'critical'
      },
      {
        name: 'Criminal-Group-A',
        description: 'Cybercriminal organization',
        targets: ['e-commerce', 'banking'],
        techniques: ['ransomware', 'data_theft'],
        severity: 'high'
      }
    ];
  }

  /**
   * Obtener campañas de ataque simuladas
   */
  getSimulatedAttackCampaigns() {
    return [
      {
        name: 'Operation-Fake-Event',
        description: 'Campaña de phishing dirigida a plataformas de eventos',
        target: 'event_platforms',
        techniques: ['phishing', 'credential_theft'],
        severity: 'high',
        active: true
      },
      {
        name: 'Ticket-Scalping-Bot',
        description: 'Bots para compra masiva de tickets',
        target: 'ticketing_systems',
        techniques: ['automation', 'rate_abuse'],
        severity: 'medium',
        active: true
      }
    ];
  }

  /**
   * Procesar datos de threat intelligence
   */
  async processThreatData(feed, data) {
    switch (feed.type) {
      case 'ip':
        await this.processIPData(data);
        break;
      case 'domain':
        await this.processDomainData(data);
        break;
      case 'hash':
        await this.processHashData(data);
        break;
      case 'actor':
        await this.processActorData(data);
        break;
      case 'campaign':
        await this.processCampaignData(data);
        break;
    }
  }

  /**
   * Procesar datos de IPs
   */
  async processIPData(ips) {
    for (const ipData of ips) {
      this.blockedIPs.add(ipData.ip);
      this.threatIndicators.set(ipData.ip, {
        type: 'ip',
        value: ipData.ip,
        threatType: ipData.type,
        severity: ipData.severity,
        source: ipData.source,
        timestamp: new Date().toISOString()
      });
    }
  }

  /**
   * Procesar datos de dominios
   */
  async processDomainData(domains) {
    for (const domainData of domains) {
      this.blockedDomains.add(domainData.domain);
      this.threatIndicators.set(domainData.domain, {
        type: 'domain',
        value: domainData.domain,
        threatType: domainData.type,
        severity: domainData.severity,
        source: domainData.source,
        timestamp: new Date().toISOString()
      });
    }
  }

  /**
   * Procesar datos de hashes
   */
  async processHashData(hashes) {
    for (const hashData of hashes) {
      this.maliciousHashes.add(hashData.hash);
      this.threatIndicators.set(hashData.hash, {
        type: 'hash',
        value: hashData.hash,
        threatType: hashData.type,
        severity: hashData.severity,
        timestamp: new Date().toISOString()
      });
    }
  }

  /**
   * Procesar datos de threat actors
   */
  async processActorData(actors) {
    for (const actorData of actors) {
      this.threatActors.set(actorData.name, {
        ...actorData,
        timestamp: new Date().toISOString()
      });
    }
  }

  /**
   * Procesar datos de campañas
   */
  async processCampaignData(campaigns) {
    for (const campaignData of campaigns) {
      this.campaigns.set(campaignData.name, {
        ...campaignData,
        timestamp: new Date().toISOString()
      });
    }
  }

  /**
   * Verificar si una IP está en la lista de amenazas
   */
  isThreatIP(ip) {
    return this.blockedIPs.has(ip);
  }

  /**
   * Verificar si un dominio está en la lista de amenazas
   */
  isThreatDomain(domain) {
    return this.blockedDomains.has(domain);
  }

  /**
   * Verificar si un hash está en la lista de malware
   */
  isMaliciousHash(hash) {
    return this.maliciousHashes.has(hash);
  }

  /**
   * Obtener información de threat intelligence para un indicador
   */
  getThreatInfo(indicator) {
    return this.threatIndicators.get(indicator);
  }

  /**
   * Buscar threat actors relacionados
   */
  findRelatedThreatActors(target, technique) {
    const relatedActors = [];
    
    for (const [name, actor] of this.threatActors) {
      if (actor.targets.includes(target) || actor.techniques.includes(technique)) {
        relatedActors.push(actor);
      }
    }
    
    return relatedActors;
  }

  /**
   * Buscar campañas activas
   */
  getActiveCampaigns() {
    return Array.from(this.campaigns.values()).filter(campaign => campaign.active);
  }

  /**
   * Obtener estadísticas de threat intelligence
   */
  getStats() {
    return {
      totalFeeds: this.threatFeeds.size,
      activeFeeds: Array.from(this.threatFeeds.values()).filter(f => f.isActive).length,
      blockedIPs: this.blockedIPs.size,
      blockedDomains: this.blockedDomains.size,
      maliciousHashes: this.maliciousHashes.size,
      threatActors: this.threatActors.size,
      activeCampaigns: this.getActiveCampaigns().length,
      totalIndicators: this.threatIndicators.size
    };
  }

  /**
   * Limpiar datos antiguos
   */
  cleanupOldData() {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - 30); // 30 días

    let cleanedCount = 0;

    // Limpiar indicadores antiguos
    for (const [key, indicator] of this.threatIndicators) {
      if (new Date(indicator.timestamp) < cutoffDate) {
        this.threatIndicators.delete(key);
        cleanedCount++;
      }
    }

    this.logger.info(`🧹 Limpieza de threat intelligence: ${cleanedCount} indicadores antiguos eliminados`);
  }

  /**
   * Exportar datos de threat intelligence
   */
  exportThreatData() {
    return {
      blockedIPs: Array.from(this.blockedIPs),
      blockedDomains: Array.from(this.blockedDomains),
      maliciousHashes: Array.from(this.maliciousHashes),
      threatActors: Object.fromEntries(this.threatActors),
      campaigns: Object.fromEntries(this.campaigns),
      indicators: Object.fromEntries(this.threatIndicators),
      exportDate: new Date().toISOString()
    };
  }

  /**
   * Importar datos de threat intelligence
   */
  importThreatData(data) {
    try {
      if (data.blockedIPs) {
        data.blockedIPs.forEach(ip => this.blockedIPs.add(ip));
      }
      
      if (data.blockedDomains) {
        data.blockedDomains.forEach(domain => this.blockedDomains.add(domain));
      }
      
      if (data.maliciousHashes) {
        data.maliciousHashes.forEach(hash => this.maliciousHashes.add(hash));
      }
      
      if (data.threatActors) {
        Object.entries(data.threatActors).forEach(([name, actor]) => {
          this.threatActors.set(name, actor);
        });
      }
      
      if (data.campaigns) {
        Object.entries(data.campaigns).forEach(([name, campaign]) => {
          this.campaigns.set(name, campaign);
        });
      }
      
      if (data.indicators) {
        Object.entries(data.indicators).forEach(([key, indicator]) => {
          this.threatIndicators.set(key, indicator);
        });
      }
      
      this.logger.info('📥 Datos de threat intelligence importados exitosamente');
      
    } catch (error) {
      this.logger.error('❌ Error importando datos de threat intelligence:', error);
      throw error;
    }
  }
}

// Instancia singleton
const threatIntelligenceService = new ThreatIntelligenceService();

module.exports = {
  ThreatIntelligenceService,
  threatIntelligenceService
};

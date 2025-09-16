const express = require('express');
const { honeypotService } = require('../services/honeypotService');
const { securityMonitoringService } = require('../services/securityMonitoringService');
const router = express.Router();

/**
 * Rutas de Honeypots
 * Estas rutas están diseñadas para atraer atacantes
 */

// Honeypot de login falso
router.post('/fake-login', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_login', req);
  
  if (interaction) {
    // Log de intento de login falso
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_login_attempt',
      { 
        username: req.body.username,
        password: req.body.password,
        userAgent: req.headers['user-agent']
      }
    );
    
    res.json(interaction.response);
  } else {
    res.status(404).json({ success: false, message: 'Endpoint no encontrado' });
  }
});

// Honeypot de panel de admin falso
router.get('/fake-panel', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_admin', req);
  
  if (interaction) {
    // Log de intento de acceso a admin falso
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_admin_access',
      { 
        userAgent: req.headers['user-agent'],
        referer: req.headers['referer']
      }
    );
    
    res.send(interaction.response);
  } else {
    res.status(404).send('Página no encontrada');
  }
});

// Honeypot de base de datos falsa
router.post('/fake-query', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_database', req);
  
  if (interaction) {
    // Log de intento de acceso a base de datos
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_database_access',
      { 
        query: req.body.query,
        userAgent: req.headers['user-agent']
      }
    );
    
    res.json(interaction.response);
  } else {
    res.status(404).json({ success: false, message: 'Endpoint no encontrado' });
  }
});

// Honeypot de archivos falsos
router.get('/fake-important', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_files', req);
  
  if (interaction) {
    // Log de intento de acceso a archivos
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_file_access',
      { 
        filename: req.query.filename,
        userAgent: req.headers['user-agent']
      }
    );
    
    res.json(interaction.response);
  } else {
    res.status(404).json({ success: false, message: 'Archivo no encontrado' });
  }
});

// Honeypot de API keys falsas
router.get('/fake-keys', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_api_keys', req);
  
  if (interaction) {
    // Log de intento de acceso a API keys
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_api_keys_access',
      { 
        userAgent: req.headers['user-agent'],
        apiKey: req.headers['x-api-key']
      }
    );
    
    res.json(interaction.response);
  } else {
    res.status(404).json({ success: false, message: 'Endpoint no encontrado' });
  }
});

// Honeypot de configuración falsa
router.get('/fake.env', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_config', req);
  
  if (interaction) {
    // Log de intento de acceso a configuración
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_config_access',
      { 
        userAgent: req.headers['user-agent'],
        referer: req.headers['referer']
      }
    );
    
    res.json(interaction.response);
  } else {
    res.status(404).json({ success: false, message: 'Archivo no encontrado' });
  }
});

// Honeypot adicional: endpoint de debug
router.get('/debug', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_debug', req);
  
  if (interaction) {
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_debug_access',
      { 
        userAgent: req.headers['user-agent'],
        query: req.query
      }
    );
    
    res.json({
      success: true,
      debug: true,
      environment: 'production',
      version: '1.0.0',
      database: 'connected',
      redis: 'connected',
      message: 'Debug mode activado'
    });
  } else {
    res.status(404).json({ success: false, message: 'Debug no disponible' });
  }
});

// Honeypot adicional: endpoint de test
router.post('/test', (req, res) => {
  const interaction = honeypotService.processInteraction('fake_test', req);
  
  if (interaction) {
    securityMonitoringService.logSuspiciousActivity(
      req.ip,
      'fake_test_access',
      { 
        userAgent: req.headers['user-agent'],
        body: req.body
      }
    );
    
    res.json({
      success: true,
      message: 'Test endpoint funcionando',
      data: req.body,
      timestamp: new Date().toISOString()
    });
  } else {
    res.status(404).json({ success: false, message: 'Test endpoint no disponible' });
  }
});

module.exports = router;

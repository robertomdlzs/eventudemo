const express = require('express');
const { auth } = require('../middleware/auth');
const requireRole = require('../middleware/requireRole');
const { waf } = require('../middleware/waf');
const router = express.Router();

/**
 * Rutas para gestión del WAF
 * Solo accesibles para administradores
 */

// Obtener estadísticas del WAF
router.get('/stats', auth, requireRole(['admin']), async (req, res) => {
  try {
    const stats = waf.getStats();
    
    res.json({
      success: true,
      data: stats
    });
  } catch (error) {
    console.error('Error obteniendo estadísticas del WAF:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Desbloquear IP
router.post('/unblock-ip', auth, requireRole(['admin']), async (req, res) => {
  try {
    const { ip } = req.body;
    
    if (!ip) {
      return res.status(400).json({
        success: false,
        message: 'IP es requerida'
      });
    }

    waf.unblockIP(ip);
    
    res.json({
      success: true,
      message: `IP ${ip} desbloqueada exitosamente`
    });
  } catch (error) {
    console.error('Error desbloqueando IP:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Obtener IPs bloqueadas
router.get('/blocked-ips', auth, requireRole(['admin']), async (req, res) => {
  try {
    const stats = waf.getStats();
    
    res.json({
      success: true,
      data: {
        blockedIPs: stats.blockedIPs,
        count: stats.totalBlockedIPs
      }
    });
  } catch (error) {
    console.error('Error obteniendo IPs bloqueadas:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Obtener IPs sospechosas
router.get('/suspicious-ips', auth, requireRole(['admin']), async (req, res) => {
  try {
    const stats = waf.getStats();
    
    res.json({
      success: true,
      data: {
        suspiciousIPs: stats.suspiciousIPs,
        count: stats.totalSuspiciousIPs
      }
    });
  } catch (error) {
    console.error('Error obteniendo IPs sospechosas:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

// Limpiar datos del WAF
router.post('/cleanup', auth, requireRole(['admin']), async (req, res) => {
  try {
    waf.cleanup();
    
    res.json({
      success: true,
      message: 'Limpieza del WAF completada'
    });
  } catch (error) {
    console.error('Error limpiando WAF:', error);
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    });
  }
});

module.exports = router;

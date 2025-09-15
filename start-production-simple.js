#!/usr/bin/env node

/**
 * Script de inicio simplificado para producción en DomCloud
 * Maneja errores de dependencias y inicia solo el backend
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación en modo producción (simplificado)...');

// Configurar variables de entorno
process.env.NODE_ENV = 'production';

// Configurar URLs para producción
if (!process.env.NEXT_PUBLIC_API_URL) {
  process.env.NEXT_PUBLIC_API_URL = `https://${process.env.DOMAIN || 'eventu.mnz.dom.my.id'}/api`;
}

if (!process.env.FRONTEND_URL) {
  process.env.FRONTEND_URL = `https://${process.env.DOMAIN || 'eventu.mnz.dom.my.id'}`;
}

// Función para iniciar solo el backend
function startBackendOnly() {
  console.log('📡 Iniciando solo el backend...');
  
  const backendPath = path.join(__dirname, 'backend');
  const backendProcess = spawn('node', ['server.js'], {
    cwd: backendPath,
    env: {
      ...process.env,
      PORT: process.env.PORT || 3001
    },
    stdio: 'inherit'
  });

  backendProcess.on('error', (err) => {
    console.error('❌ Error iniciando backend:', err);
    process.exit(1);
  });

  backendProcess.on('exit', (code) => {
    console.log(`Backend terminó con código ${code}`);
    process.exit(code);
  });

  return backendProcess;
}

// Manejar señales de terminación
process.on('SIGINT', () => {
  console.log('\n🛑 Recibida señal de terminación...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🛑 Recibida señal de terminación...');
  process.exit(0);
});

// Iniciar solo el backend
startBackendOnly();

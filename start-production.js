#!/usr/bin/env node

/**
 * Script de inicio para producción en DomCloud
 * Maneja tanto el frontend Next.js como el backend Node.js
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación en modo producción...');

// Configurar variables de entorno
process.env.NODE_ENV = 'production';

// Cargar configuración de producción si existe
const fs = require('fs');
const productionConfigPath = path.join(__dirname, 'backend/config.production.env');

if (fs.existsSync(productionConfigPath)) {
  console.log('📋 Cargando configuración de producción...');
  require('dotenv').config({ path: productionConfigPath });
}

// Configurar URLs para producción
if (!process.env.NEXT_PUBLIC_API_URL) {
  process.env.NEXT_PUBLIC_API_URL = `https://${process.env.DOMAIN || 'eventu.mnz.dom.my.id'}/api`;
}

if (!process.env.FRONTEND_URL) {
  process.env.FRONTEND_URL = `https://${process.env.DOMAIN || 'eventu.mnz.dom.my.id'}`;
}

// Función para iniciar el backend
function startBackend() {
  console.log('📡 Iniciando backend...');
  
  const backendPath = path.join(__dirname, 'backend');
  const backendProcess = spawn('node', ['server.js'], {
    cwd: backendPath,
    env: {
      ...process.env,
      PORT: process.env.BACKEND_PORT || (parseInt(process.env.PORT) + 1).toString()
    },
    stdio: 'inherit'
  });

  backendProcess.on('error', (err) => {
    console.error('❌ Error iniciando backend:', err);
  });

  backendProcess.on('exit', (code) => {
    console.log(`Backend terminó con código ${code}`);
  });

  return backendProcess;
}

// Función para iniciar el frontend Next.js
function startFrontend() {
  console.log('🌐 Iniciando frontend Next.js...');
  
  const frontendProcess = spawn('node', ['.next/standalone/server.js'], {
    cwd: __dirname,
    env: {
      ...process.env,
      PORT: process.env.PORT || 3000
    },
    stdio: 'inherit'
  });

  frontendProcess.on('error', (err) => {
    console.error('❌ Error iniciando frontend:', err);
  });

  frontendProcess.on('exit', (code) => {
    console.log(`Frontend terminó con código ${code}`);
  });

  return frontendProcess;
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

// Verificar si estamos en modo standalone
if (process.env.STANDALONE_MODE === 'true') {
  // Solo iniciar el frontend si está en modo standalone
  startFrontend();
} else {
  // Iniciar ambos servicios
  const backendProcess = startBackend();
  const frontendProcess = startFrontend();
  
  // Manejar terminación de procesos
  backendProcess.on('exit', () => {
    console.log('Backend terminado, terminando frontend...');
    frontendProcess.kill();
  });
  
  frontendProcess.on('exit', () => {
    console.log('Frontend terminado, terminando backend...');
    backendProcess.kill();
  });
}

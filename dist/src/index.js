#!/usr/bin/env node

/**
 * Punto de entrada optimizado para DomCloud
 * Inicia solo el backend para evitar conflictos de puertos
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación desde dist/src/index.js (optimizado)...');

// Cambiar al directorio raíz
process.chdir(__dirname + '/../..');

// Instalar dependencias del backend si no existen (solo las críticas)
try {
  console.log('📦 Verificando dependencias críticas del backend...');
  const backendPath = path.join(__dirname, '../../backend');
  
  // Solo verificar multer (más rápido)
  try {
    require(path.join(backendPath, 'node_modules/multer'));
    console.log('✅ Multer ya está instalado');
  } catch (error) {
    console.log('⚠️  Multer no encontrado, instalando...');
    const { execSync } = require('child_process');
    execSync('cd backend && npm install multer@^1.4.5-lts.1 --save --no-optional', { stdio: 'inherit' });
    console.log('✅ Multer instalado correctamente');
  }
  
} catch (error) {
  console.error('❌ Error instalando dependencias:', error.message);
  console.log('🔄 Continuando con el inicio...');
}

// Configurar variables de entorno
process.env.NODE_ENV = 'production';

// Cargar configuración de producción si existe
const fs = require('fs');
const productionConfigPath = path.join(__dirname, '../../backend/config.production.env');

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

// Función para iniciar solo el backend (más rápido y sin conflictos)
function startBackendOnly() {
  console.log('📡 Iniciando backend (modo optimizado)...');
  
  const backendPath = path.join(__dirname, '../../backend');
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

  // Enviar señal de que la aplicación está lista
  setTimeout(() => {
    console.log('✅ Aplicación lista y funcionando');
  }, 2000);

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
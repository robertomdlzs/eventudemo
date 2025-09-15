#!/usr/bin/env node

/**
 * Punto de entrada ultra-simple para DomCloud
 * Sin dependencias externas, solo lo esencial
 */

const { spawn } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación (modo simple)...');

// Cambiar al directorio raíz
process.chdir(__dirname + '/../..');

// Configurar variables de entorno básicas
process.env.NODE_ENV = 'production';
process.env.PORT = process.env.PORT || 3001;

// Función para iniciar solo el backend
function startBackend() {
  console.log('📡 Iniciando backend...');
  
  const backendPath = path.join(__dirname, '../../backend');
  const backendProcess = spawn('node', ['server.js'], {
    cwd: backendPath,
    env: {
      ...process.env,
      NODE_ENV: 'production',
      PORT: process.env.PORT,
      DB_TYPE: 'postgresql',
      DB_HOST: 'localhost',
      DB_PORT: '5432',
      DB_NAME: 'eventu_db',
      DB_USER: 'postgres',
      DB_PASSWORD: 'Eventu321',
      FRONTEND_URL: 'https://eventu.mnz.dom.my.id'
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

  // Señal de que la aplicación está lista
  setTimeout(() => {
    console.log('✅ Aplicación lista');
  }, 1000);

  return backendProcess;
}

// Manejar señales de terminación
process.on('SIGINT', () => {
  console.log('\n🛑 Terminando...');
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n🛑 Terminando...');
  process.exit(0);
});

// Iniciar el backend
startBackend();
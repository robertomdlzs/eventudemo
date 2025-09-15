#!/usr/bin/env node

/**
 * Punto de entrada para DomCloud - Solo instala multer
 */

const { execSync } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación desde dist/src/index-multer.js...');

// Cambiar al directorio raíz
process.chdir(__dirname + '/../..');

// Solo instalar multer
try {
  console.log('📦 Instalando multer...');
  execSync('cd backend && npm install multer@^1.4.5-lts.1 --save --no-optional', { stdio: 'inherit' });
  console.log('✅ Multer instalado correctamente');
} catch (error) {
  console.error('❌ Error instalando multer:', error.message);
}

// Ejecutar el script de inicio
require('../../start-production.js');

#!/usr/bin/env node

/**
 * Punto de entrada optimizado para DomCloud
 * Inicia solo el backend para evitar timeouts
 */

const { execSync } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación desde dist/src/index-fast.js...');

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
    execSync('cd backend && npm install multer@^1.4.5-lts.1 --save --no-optional', { stdio: 'inherit' });
    console.log('✅ Multer instalado correctamente');
  }
  
} catch (error) {
  console.error('❌ Error instalando dependencias:', error.message);
  console.log('🔄 Continuando con el inicio...');
}

// Ejecutar el script de inicio optimizado
require('../../start-production-fast.js');

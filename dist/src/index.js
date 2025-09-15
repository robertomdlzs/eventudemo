#!/usr/bin/env node

/**
 * Punto de entrada para DomCloud
 * Instala dependencias y redirige al script de inicio correcto
 */

const { execSync } = require('child_process');
const path = require('path');

console.log('🚀 Iniciando aplicación desde dist/src/index.js...');

// Cambiar al directorio raíz
process.chdir(__dirname + '/../..');

// Instalar dependencias del backend si no existen
try {
  console.log('📦 Verificando dependencias del backend...');
  const backendPath = path.join(__dirname, '../../backend');
  
  // Verificar si multer está instalado
  try {
    require(path.join(backendPath, 'node_modules/multer'));
    console.log('✅ Multer ya está instalado');
  } catch (error) {
    console.log('⚠️  Multer no encontrado, instalando...');
    execSync('cd backend && npm install multer@^1.4.5-lts.1 --save', { stdio: 'inherit' });
    console.log('✅ Multer instalado correctamente');
  }
  
  // Verificar otras dependencias críticas
  const criticalDeps = ['express', 'mysql2', 'cors', 'helmet'];
  for (const dep of criticalDeps) {
    try {
      require(path.join(backendPath, `node_modules/${dep}`));
    } catch (error) {
      console.log(`⚠️  ${dep} no encontrado, instalando...`);
      execSync(`cd backend && npm install ${dep} --save`, { stdio: 'inherit' });
    }
  }
  
} catch (error) {
  console.error('❌ Error instalando dependencias:', error.message);
  console.log('🔄 Continuando con el inicio...');
}

// Ejecutar el script de inicio
require('../../start-production.js');

#!/usr/bin/env node

/**
 * Punto de entrada simplificado para DomCloud
 * Usa el script de inicio simplificado
 */

console.log('🚀 Iniciando aplicación desde dist/src/index-simple.js...');

// Cambiar al directorio raíz y ejecutar el script simplificado
process.chdir(__dirname + '/../..');
require('../../start-production-simple.js');

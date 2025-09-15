#!/usr/bin/env node

/**
 * Punto de entrada para DomCloud
 * Redirige al script de inicio correcto
 */

console.log('🚀 Iniciando aplicación desde dist/src/index.js...');

// Cambiar al directorio raíz y ejecutar el script correcto
process.chdir(__dirname + '/../..');
require('../../start-production.js');

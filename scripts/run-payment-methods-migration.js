#!/usr/bin/env node

/**
 * Script para ejecutar la migración de métodos de pago por evento
 * Este script agrega los campos payment_methods y payment_methods_config a la tabla events
 */

const fs = require('fs')
const path = require('path')

async function runMigration() {
  try {
    console.log('🔄 Iniciando migración de métodos de pago por evento...')
    
    // Leer el archivo SQL de migración
    const migrationPath = path.join(__dirname, 'add_payment_methods_fields.sql')
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8')
    
    console.log('📄 Archivo de migración leído:', migrationPath)
    console.log('📋 Contenido de la migración:')
    console.log(migrationSQL)
    
    console.log('✅ Migración preparada correctamente')
    console.log('')
    console.log('📝 Para ejecutar la migración, ejecuta uno de los siguientes comandos:')
    console.log('')
    console.log('Para MySQL:')
    console.log('  mysql -u root -p eventu_db < scripts/add_payment_methods_fields.sql')
    console.log('')
    console.log('Para PostgreSQL:')
    console.log('  psql -U postgres -d eventu_db -f scripts/add_payment_methods_fields.sql')
    console.log('')
    console.log('Para SQLite:')
    console.log('  sqlite3 eventu.db < scripts/add_payment_methods_fields.sql')
    console.log('')
    console.log('⚠️  IMPORTANTE: Haz un respaldo de tu base de datos antes de ejecutar la migración')
    console.log('')
    console.log('🎯 Funcionalidades que se habilitarán después de la migración:')
    console.log('  • Configuración de métodos de pago por evento')
    console.log('  • Activación/desactivación de PSE, tarjetas, Daviplata, TC Serfinanza')
    console.log('  • Configuración detallada de cada método de pago')
    console.log('  • Integración con carrito y checkout')
    console.log('  • Interfaz de administración para gestionar métodos de pago')
    
  } catch (error) {
    console.error('❌ Error ejecutando la migración:', error)
    process.exit(1)
  }
}

// Ejecutar si es llamado directamente
if (require.main === module) {
  runMigration()
}

module.exports = { runMigration }


#!/usr/bin/env node

/**
 * Script para ejecutar la migración de tarifa de servicio
 * Este script agrega los campos service_fee_type, service_fee_value y service_fee_description a la tabla events
 */

const fs = require('fs')
const path = require('path')

async function runMigration() {
  try {
    console.log('🔄 Iniciando migración de tarifa de servicio...')
    
    // Leer el archivo SQL de migración
    const migrationPath = path.join(__dirname, 'add_service_fee_field.sql')
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8')
    
    console.log('📄 Archivo de migración leído:', migrationPath)
    console.log('📋 Contenido de la migración:')
    console.log(migrationSQL)
    
    console.log('✅ Migración preparada correctamente')
    console.log('')
    console.log('📝 Para ejecutar la migración, ejecuta uno de los siguientes comandos:')
    console.log('')
    console.log('Para MySQL:')
    console.log('  mysql -u root -p eventu_db < scripts/add_service_fee_field.sql')
    console.log('')
    console.log('Para PostgreSQL:')
    console.log('  psql -U postgres -d eventu_db -f scripts/add_service_fee_field.sql')
    console.log('')
    console.log('Para SQLite:')
    console.log('  sqlite3 eventu.db < scripts/add_service_fee_field.sql')
    console.log('')
    console.log('⚠️  IMPORTANTE: Haz un respaldo de tu base de datos antes de ejecutar la migración')
    
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


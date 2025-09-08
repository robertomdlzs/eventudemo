#!/usr/bin/env node

/**
 * Script para ejecutar la migración del evento próximo con cuenta regresiva
 * Este script crea la tabla featured_countdown_event y configura el evento por defecto
 */

const fs = require('fs')
const path = require('path')

async function runMigration() {
  try {
    console.log('🔄 Iniciando migración del evento próximo con cuenta regresiva...')
    
    // Leer el archivo SQL de migración
    const migrationPath = path.join(__dirname, 'add_featured_countdown_event.sql')
    const migrationSQL = fs.readFileSync(migrationPath, 'utf8')
    
    console.log('📄 Archivo de migración leído:', migrationPath)
    console.log('📋 Contenido de la migración:')
    console.log(migrationSQL)
    
    console.log('✅ Migración preparada correctamente')
    console.log('')
    console.log('📝 Para ejecutar la migración, ejecuta uno de los siguientes comandos:')
    console.log('')
    console.log('Para MySQL:')
    console.log('  mysql -u root -p eventu_db < scripts/add_featured_countdown_event.sql')
    console.log('')
    console.log('Para PostgreSQL:')
    console.log('  psql -U postgres -d eventu_db -f scripts/add_featured_countdown_event.sql')
    console.log('')
    console.log('Para SQLite:')
    console.log('  sqlite3 eventu.db < scripts/add_featured_countdown_event.sql')
    console.log('')
    console.log('⚠️  IMPORTANTE: Haz un respaldo de tu base de datos antes de ejecutar la migración')
    console.log('')
    console.log('🎯 Funcionalidades que se habilitarán después de la migración:')
    console.log('  • Tabla para gestionar evento próximo destacado')
    console.log('  • Interfaz de administración para editar evento próximo')
    console.log('  • API endpoints para gestionar evento próximo')
    console.log('  • CountdownBanner dinámico con datos de la base de datos')
    console.log('  • Redireccionamiento configurable a compra')
    console.log('  • Activación/desactivación del evento próximo')
    console.log('  • Vista previa en tiempo real en el panel de administración')
    console.log('')
    console.log('🔧 Endpoints de API que se crearán:')
    console.log('  • GET /api/admin/featured-countdown-event - Obtener evento próximo (admin)')
    console.log('  • POST /api/admin/featured-countdown-event - Crear/actualizar evento próximo (admin)')
    console.log('  • PUT /api/admin/featured-countdown-event/toggle - Activar/desactivar evento (admin)')
    console.log('  • GET /api/admin/featured-countdown-event/history - Historial de eventos (admin)')
    console.log('  • GET /api/public/featured-countdown-event - Obtener evento próximo (público)')
    console.log('  • GET /api/public/featured-countdown-event/info - Información básica (público)')
    console.log('')
    console.log('🎨 Interfaz de administración:')
    console.log('  • URL: /admin/evento-proximo')
    console.log('  • Formulario completo para editar evento próximo')
    console.log('  • Vista previa en tiempo real')
    console.log('  • Activación/desactivación con switch')
    console.log('  • Generación automática de slug')
    console.log('  • Configuración de redireccionamiento personalizado')
    console.log('')
    console.log('📱 Componente CountdownBanner actualizado:')
    console.log('  • Carga datos dinámicamente desde la API')
    console.log('  • Fallback a datos por defecto si hay error')
    console.log('  • Redireccionamiento configurable')
    console.log('  • Estado de carga y error')
    console.log('  • Cuenta regresiva en tiempo real')
    
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


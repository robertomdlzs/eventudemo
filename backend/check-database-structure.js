const { Pool } = require('pg')
require('dotenv').config({ path: './config.env' })

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "eventu_db",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "Eventu321",
})

async function checkDatabaseStructure() {
  try {
    console.log('🔍 Verificando estructura de la base de datos...')
    
    // Verificar tabla sales
    console.log('\n📊 Tabla SALES:')
    const salesStructure = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns
      WHERE table_name = 'sales'
      ORDER BY ordinal_position
    `)
    
    console.log('Columnas en tabla sales:')
    salesStructure.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`)
    })
    
    // Verificar tabla users
    console.log('\n👥 Tabla USERS:')
    const usersStructure = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns
      WHERE table_name = 'users'
      ORDER BY ordinal_position
    `)
    
    console.log('Columnas en tabla users:')
    usersStructure.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`)
    })
    
    // Verificar tabla events
    console.log('\n🎪 Tabla EVENTS:')
    const eventsStructure = await pool.query(`
      SELECT column_name, data_type, is_nullable
      FROM information_schema.columns
      WHERE table_name = 'events'
      ORDER BY ordinal_position
    `)
    
    console.log('Columnas en tabla events:')
    eventsStructure.rows.forEach(col => {
      console.log(`  - ${col.column_name}: ${col.data_type} (${col.is_nullable === 'YES' ? 'nullable' : 'not null'})`)
    })
    
    // Verificar datos de ejemplo
    console.log('\n📈 Datos de ejemplo:')
    
    const salesCount = await pool.query('SELECT COUNT(*) as count FROM sales')
    console.log(`  - Ventas: ${salesCount.rows[0].count}`)
    
    const usersCount = await pool.query('SELECT COUNT(*) as count FROM users')
    console.log(`  - Usuarios: ${usersCount.rows[0].count}`)
    
    const eventsCount = await pool.query('SELECT COUNT(*) as count FROM events')
    console.log(`  - Eventos: ${eventsCount.rows[0].count}`)
    
  } catch (error) {
    console.error('❌ Error verificando estructura:', error)
  } finally {
    await pool.end()
  }
}

checkDatabaseStructure()

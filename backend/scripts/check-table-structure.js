const { Pool } = require("pg")

// Configuración directa para PostgreSQL
const pool = new Pool({
  host: "localhost",
  port: 5432,
  database: "eventu_db",
  user: "postgres",
  password: "Eventu321",
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
})

async function checkTableStructure() {
  try {
    console.log('🔍 Verificando estructura de la tabla users...')
    
    const result = await pool.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = 'users' 
      ORDER BY ordinal_position
    `)
    
    if (result.rows.length === 0) {
      console.log('❌ La tabla users no existe')
    } else {
      console.log(`✅ Se encontraron ${result.rows.length} columnas:`)
      console.log('\n📋 Estructura de la tabla users:')
      
      result.rows.forEach((column, index) => {
        console.log(`${index + 1}. ${column.column_name} (${column.data_type}) - ${column.is_nullable === 'YES' ? 'NULL' : 'NOT NULL'}`)
      })
    }
    
    // También verificar si hay datos
    const countResult = await pool.query('SELECT COUNT(*) as total FROM users')
    console.log(`\n📊 Total de usuarios en la tabla: ${countResult.rows[0].total}`)
    
  } catch (error) {
    console.error('❌ Error verificando estructura:', error.message)
  } finally {
    await pool.end()
    process.exit(0)
  }
}

checkTableStructure()

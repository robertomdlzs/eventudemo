const db = require('../config/database-postgres')

async function checkUsers() {
  try {
    console.log('🔍 Verificando usuarios en la base de datos...')
    
    const result = await db.query(
      'SELECT id, name, email, role, status, created_at FROM users ORDER BY created_at DESC'
    )
    
    if (result.rows.length === 0) {
      console.log('❌ No hay usuarios en la base de datos')
    } else {
      console.log(`✅ Se encontraron ${result.rows.length} usuarios:`)
      console.log('\n📋 Lista de usuarios:')
      
      result.rows.forEach((user, index) => {
        console.log(`${index + 1}. ${user.name} (${user.email}) - ${user.role} - ${user.status}`)
      })
    }
    
  } catch (error) {
    console.error('❌ Error verificando usuarios:', error.message)
  } finally {
    process.exit(0)
  }
}

checkUsers()

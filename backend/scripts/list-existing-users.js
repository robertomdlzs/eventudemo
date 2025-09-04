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

async function listExistingUsers() {
  try {
    console.log('🔍 Listando usuarios existentes en la base de datos...')
    
    const result = await pool.query(`
      SELECT 
        id, 
        first_name, 
        last_name, 
        email, 
        role, 
        status,
        created_at
      FROM users 
      ORDER BY created_at DESC
    `)
    
    if (result.rows.length === 0) {
      console.log('❌ No hay usuarios en la base de datos')
    } else {
      console.log(`✅ Se encontraron ${result.rows.length} usuarios:`)
      console.log('\n📋 Lista de usuarios:')
      
      result.rows.forEach((user, index) => {
        const fullName = `${user.first_name} ${user.last_name}`
        const roleEmoji = user.role === 'admin' ? '👑' : user.role === 'organizer' ? '🏢' : '👤'
        console.log(`${index + 1}. ${roleEmoji} ${fullName} (${user.email}) - ${user.role || 'sin rol'} - ${user.status || 'sin estado'}`)
      })
      
      // Mostrar usuarios por rol
      const adminUsers = result.rows.filter(u => u.role === 'admin')
      const organizerUsers = result.rows.filter(u => u.role === 'organizer')
      const regularUsers = result.rows.filter(u => u.role === 'user' || !u.role)
      
      console.log('\n📊 Resumen por roles:')
      console.log(`👑 Administradores: ${adminUsers.length}`)
      console.log(`🏢 Organizadores: ${organizerUsers.length}`)
      console.log(`👤 Usuarios regulares: ${regularUsers.length}`)
      
      if (adminUsers.length > 0) {
        console.log('\n🔑 Usuarios con acceso administrativo:')
        adminUsers.forEach(user => {
          console.log(`   • ${user.email} (${user.first_name} ${user.last_name})`)
        })
      }
      
      if (organizerUsers.length > 0) {
        console.log('\n🎪 Usuarios organizadores:')
        organizerUsers.forEach(user => {
          console.log(`   • ${user.email} (${user.first_name} ${user.last_name})`)
        })
      }
    }
    
  } catch (error) {
    console.error('❌ Error listando usuarios:', error.message)
  } finally {
    await pool.end()
    process.exit(0)
  }
}

listExistingUsers()

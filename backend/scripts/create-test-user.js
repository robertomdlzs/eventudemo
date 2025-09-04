const { Pool } = require("pg")
const bcrypt = require('bcryptjs')

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

async function createTestUser() {
  try {
    console.log('🔧 Creando usuario de prueba...')

    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash('test123', 10)

    // Usuario de prueba
    const testUser = {
      first_name: 'Test',
      last_name: 'Admin',
      email: 'test@eventu.com',
      password_hash: hashedPassword,
      role: 'admin',
      status: 'active'
    }

    // Insertar usuario
    const result = await pool.query(
      `INSERT INTO users (first_name, last_name, email, password_hash, role, status, created_at, updated_at) 
       VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW()) 
       ON CONFLICT (email) DO UPDATE SET 
       first_name = EXCLUDED.first_name, 
       last_name = EXCLUDED.last_name,
       password_hash = EXCLUDED.password_hash, 
       role = EXCLUDED.role, 
       status = EXCLUDED.status, 
       updated_at = NOW()
       RETURNING id, first_name, last_name, email, role`,
      [testUser.first_name, testUser.last_name, testUser.email, testUser.password_hash, testUser.role, testUser.status]
    )
    
    console.log(`✅ Usuario creado/actualizado: ${testUser.email} (${testUser.role})`)
    console.log('\n🎉 Usuario de prueba creado exitosamente!')
    console.log('\n📋 Credenciales de acceso:')
    console.log('👑 Test Admin: test@eventu.com / test123')

  } catch (error) {
    console.error('❌ Error creando usuario de prueba:', error)
  } finally {
    await pool.end()
    process.exit(0)
  }
}

createTestUser()

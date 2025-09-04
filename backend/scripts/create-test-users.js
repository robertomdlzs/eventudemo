const bcrypt = require('bcryptjs')
const db = require('../config/database-postgres')

async function createTestUsers() {
  try {
    console.log('🔧 Creando usuarios de prueba...')

    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash('test123', 10)

    // Usuarios de prueba
    const testUsers = [
      {
        name: 'Admin Eventu',
        email: 'admin@test.eventu.com',
        password: hashedPassword,
        role: 'admin',
        status: 'active'
      },
      {
        name: 'Juan Pérez Organizador',
        email: 'organizer1@test.eventu.com',
        password: hashedPassword,
        role: 'organizer',
        status: 'active'
      },
      {
        name: 'María García Organizadora',
        email: 'organizer2@test.eventu.com',
        password: hashedPassword,
        role: 'organizer',
        status: 'active'
      },
      {
        name: 'Carlos López Usuario',
        email: 'user1@test.eventu.com',
        password: hashedPassword,
        role: 'user',
        status: 'active'
      },
      {
        name: 'Ana Rodríguez Usuaria',
        email: 'user2@test.eventu.com',
        password: hashedPassword,
        role: 'user',
        status: 'active'
      },
      {
        name: 'Luis Martínez Cliente',
        email: 'user3@test.eventu.com',
        password: hashedPassword,
        role: 'user',
        status: 'active'
      }
    ]

    // Insertar usuarios
    for (const user of testUsers) {
      try {
        const result = await db.query(
          `INSERT INTO users (name, email, password, role, status, created_at, updated_at) 
           VALUES ($1, $2, $3, $4, $5, NOW(), NOW()) 
           ON CONFLICT (email) DO UPDATE SET 
           name = EXCLUDED.name, 
           password = EXCLUDED.password, 
           role = EXCLUDED.role, 
           status = EXCLUDED.status, 
           updated_at = NOW()
           RETURNING id, name, email, role`,
          [user.name, user.email, user.password, user.role, user.status]
        )
        
        console.log(`✅ Usuario creado/actualizado: ${user.email} (${user.role})`)
      } catch (error) {
        console.log(`⚠️  Error con usuario ${user.email}:`, error.message)
      }
    }

    console.log('\n🎉 Usuarios de prueba creados exitosamente!')
    console.log('\n📋 Credenciales de acceso:')
    console.log('👑 Admin: admin@test.eventu.com / test123')
    console.log('🏢 Organizador 1: organizer1@test.eventu.com / test123')
    console.log('🏢 Organizador 2: organizer2@test.eventu.com / test123')
    console.log('👤 Usuario 1: user1@test.eventu.com / test123')
    console.log('👤 Usuario 2: user2@test.eventu.com / test123')
    console.log('👤 Usuario 3: user3@test.eventu.com / test123')

  } catch (error) {
    console.error('❌ Error creando usuarios de prueba:', error)
  } finally {
    process.exit(0)
  }
}

createTestUsers()

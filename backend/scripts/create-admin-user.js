const { Pool } = require('pg')
const bcrypt = require('bcryptjs')
require('dotenv').config()

const pool = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
})

async function createAdminUser() {
  try {
    console.log('👑 Creando usuario administrador...')
    
    // Datos del administrador
    const adminData = {
      first_name: 'Administrador',
      last_name: 'Eventu',
      email: 'admin@eventu.co',
      password: 'Eventu321',
      role: 'admin',
      status: 'active'
    }
    
    // Verificar si el usuario ya existe
    const existingUser = await pool.query(
      'SELECT id FROM users WHERE email = $1',
      [adminData.email]
    )
    
    if (existingUser.rows.length > 0) {
      console.log('⚠️  El usuario admin ya existe, actualizando contraseña...')
      
      // Actualizar contraseña
      const hashedPassword = await bcrypt.hash(adminData.password, 12)
      await pool.query(
        'UPDATE users SET password_hash = $1, first_name = $2, last_name = $3, role = $4, status = $5, updated_at = NOW() WHERE email = $6',
        [hashedPassword, adminData.first_name, adminData.last_name, adminData.role, adminData.status, adminData.email]
      )
      
      console.log('✅ Usuario admin actualizado exitosamente')
    } else {
      // Crear nuevo usuario admin
      const hashedPassword = await bcrypt.hash(adminData.password, 12)
      
      const result = await pool.query(
        `INSERT INTO users (first_name, last_name, email, password_hash, role, status, created_at, updated_at)
         VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
         RETURNING id, first_name, last_name, email, role`,
        [
          adminData.first_name,
          adminData.last_name,
          adminData.email,
          hashedPassword,
          adminData.role,
          adminData.status
        ]
      )
      
      console.log('✅ Usuario admin creado exitosamente:')
      console.log(`   ID: ${result.rows[0].id}`)
      console.log(`   Nombre: ${result.rows[0].first_name} ${result.rows[0].last_name}`)
      console.log(`   Email: ${result.rows[0].email}`)
      console.log(`   Rol: ${result.rows[0].role}`)
    }
    
    // Verificar que el usuario se creó/actualizó correctamente
    const verifyUser = await pool.query(
      'SELECT id, first_name, last_name, email, role, status FROM users WHERE email = $1',
      [adminData.email]
    )
    
    if (verifyUser.rows.length > 0) {
      const user = verifyUser.rows[0]
      console.log('\n✅ Verificación del usuario admin:')
      console.log(`   ID: ${user.id}`)
      console.log(`   Nombre: ${user.first_name} ${user.last_name}`)
      console.log(`   Email: ${user.email}`)
      console.log(`   Rol: ${user.role}`)
      console.log(`   Estado: ${user.status}`)
    }
    
    console.log('\n🎉 Usuario administrador configurado exitosamente!')
    console.log('\n📋 Credenciales de acceso:')
    console.log(`   Email: ${adminData.email}`)
    console.log(`   Contraseña: ${adminData.password}`)
    console.log(`   Rol: ${adminData.role}`)
    console.log('\n🔗 URL de acceso: http://localhost:3002')
    
  } catch (error) {
    console.error('❌ Error creando usuario admin:', error)
  } finally {
    await pool.end()
  }
}

createAdminUser()


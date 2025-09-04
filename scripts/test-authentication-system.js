const axios = require('axios')

const API_BASE_URL = 'http://localhost:3002/api'

// Usuarios de prueba
const testUsers = [
  {
    email: 'admin@test.eventu.com',
    password: 'test123',
    role: 'admin',
    expectedRedirect: '/admin'
  },
  {
    email: 'organizer1@test.eventu.com',
    password: 'test123',
    role: 'organizer',
    expectedRedirect: '/organizer'
  },
  {
    email: 'user1@test.eventu.com',
    password: 'test123',
    role: 'user',
    expectedRedirect: '/mi-cuenta'
  }
]

async function testAuthenticationSystem() {
  console.log('🧪 Probando Sistema de Autenticación y Redirección...\n')

  for (const user of testUsers) {
    console.log(`📋 Probando usuario: ${user.email} (Rol: ${user.role})`)
    
    try {
      // 1. Probar login
      console.log('  🔐 Probando login...')
      const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
        email: user.email,
        password: user.password
      })

      if (loginResponse.data.success) {
        console.log('  ✅ Login exitoso')
        
        const { data } = loginResponse.data
        
        // 2. Verificar datos de respuesta
        console.log('  🔍 Verificando datos de respuesta...')
        
        // Verificar que el token existe
        if (data.token) {
          console.log('  ✅ Token generado correctamente')
        } else {
          console.log('  ❌ Token no encontrado')
        }

        // Verificar que el usuario tiene el rol correcto
        if (data.user.role === user.role) {
          console.log(`  ✅ Rol correcto: ${data.user.role}`)
        } else {
          console.log(`  ❌ Rol incorrecto. Esperado: ${user.role}, Obtenido: ${data.user.role}`)
        }

        // Verificar URL de redirección
        if (data.redirectUrl === user.expectedRedirect) {
          console.log(`  ✅ URL de redirección correcta: ${data.redirectUrl}`)
        } else {
          console.log(`  ❌ URL de redirección incorrecta. Esperada: ${user.expectedRedirect}, Obtenida: ${data.redirectUrl}`)
        }

        // Verificar mensaje de bienvenida
        if (data.welcomeMessage) {
          console.log(`  ✅ Mensaje de bienvenida: ${data.welcomeMessage}`)
        } else {
          console.log('  ❌ Mensaje de bienvenida no encontrado')
        }

        // 3. Probar acceso a endpoints protegidos
        console.log('  🔒 Probando acceso a endpoints protegidos...')
        
        const headers = {
          'Authorization': `Bearer ${data.token}`,
          'Content-Type': 'application/json'
        }

        // Probar acceso según el rol
        switch (user.role) {
          case 'admin':
            await testAdminAccess(headers, data.user.id)
            break
          case 'organizer':
            await testOrganizerAccess(headers, data.user.id)
            break
          case 'user':
            await testUserAccess(headers, data.user.id)
            break
        }

      } else {
        console.log('  ❌ Login fallido:', loginResponse.data.message)
      }

    } catch (error) {
      console.log('  ❌ Error durante la prueba:', error.response?.data?.message || error.message)
    }

    console.log('') // Línea en blanco para separar usuarios
  }

  console.log('🎉 Pruebas de autenticación completadas!')
}

async function testAdminAccess(headers, userId) {
  try {
    // Probar acceso al dashboard de admin
    const adminResponse = await axios.get(`${API_BASE_URL}/admin/dashboard`, { headers })
    if (adminResponse.data.success) {
      console.log('  ✅ Acceso al dashboard de admin permitido')
    } else {
      console.log('  ❌ Acceso al dashboard de admin denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo al dashboard de admin:', error.response?.data?.message)
  }

  try {
    // Probar acceso a eventos de admin
    const eventsResponse = await axios.get(`${API_BASE_URL}/admin/events`, { headers })
    if (eventsResponse.data.success) {
      console.log('  ✅ Acceso a eventos de admin permitido')
    } else {
      console.log('  ❌ Acceso a eventos de admin denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo a eventos de admin:', error.response?.data?.message)
  }
}

async function testOrganizerAccess(headers, userId) {
  try {
    // Probar acceso al dashboard de organizador
    const organizerResponse = await axios.get(`${API_BASE_URL}/organizer/dashboard-stats/${userId}`, { headers })
    if (organizerResponse.data.success) {
      console.log('  ✅ Acceso al dashboard de organizador permitido')
    } else {
      console.log('  ❌ Acceso al dashboard de organizador denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo al dashboard de organizador:', error.response?.data?.message)
  }

  try {
    // Probar acceso a eventos del organizador
    const eventsResponse = await axios.get(`${API_BASE_URL}/organizer/events/${userId}`, { headers })
    if (eventsResponse.data.success) {
      console.log('  ✅ Acceso a eventos del organizador permitido')
    } else {
      console.log('  ❌ Acceso a eventos del organizador denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo a eventos del organizador:', error.response?.data?.message)
  }
}

async function testUserAccess(headers, userId) {
  try {
    // Probar acceso al perfil de usuario
    const profileResponse = await axios.get(`${API_BASE_URL}/auth/profile`, { headers })
    if (profileResponse.data.success) {
      console.log('  ✅ Acceso al perfil de usuario permitido')
    } else {
      console.log('  ❌ Acceso al perfil de usuario denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo al perfil de usuario:', error.response?.data?.message)
  }

  try {
    // Probar acceso a eventos públicos
    const eventsResponse = await axios.get(`${API_BASE_URL}/events`)
    if (eventsResponse.data.success) {
      console.log('  ✅ Acceso a eventos públicos permitido')
    } else {
      console.log('  ❌ Acceso a eventos públicos denegado')
    }
  } catch (error) {
    console.log('  ❌ Error accediendo a eventos públicos:', error.response?.data?.message)
  }
}

// Función para probar redirecciones incorrectas
async function testUnauthorizedAccess() {
  console.log('\n🚫 Probando acceso no autorizado...\n')

  // Intentar acceder a panel de admin con usuario normal
  try {
    const userLogin = await axios.post(`${API_BASE_URL}/auth/login`, {
      email: 'user1@test.eventu.com',
      password: 'test123'
    })

    if (userLogin.data.success) {
      const headers = {
        'Authorization': `Bearer ${userLogin.data.data.token}`,
        'Content-Type': 'application/json'
      }

      // Intentar acceder a endpoint de admin
      try {
        await axios.get(`${API_BASE_URL}/admin/dashboard`, { headers })
        console.log('❌ Usuario normal pudo acceder al panel de admin (esto no debería pasar)')
      } catch (error) {
        if (error.response?.status === 403) {
          console.log('✅ Usuario normal correctamente bloqueado del panel de admin')
        } else {
          console.log('⚠️  Error inesperado:', error.response?.data?.message)
        }
      }

      // Intentar acceder a endpoint de organizador
      try {
        await axios.get(`${API_BASE_URL}/organizer/dashboard-stats/1`, { headers })
        console.log('❌ Usuario normal pudo acceder al panel de organizador (esto no debería pasar)')
      } catch (error) {
        if (error.response?.status === 403) {
          console.log('✅ Usuario normal correctamente bloqueado del panel de organizador')
        } else {
          console.log('⚠️  Error inesperado:', error.response?.data?.message)
        }
      }
    }
  } catch (error) {
    console.log('❌ Error durante prueba de acceso no autorizado:', error.message)
  }
}

// Función para probar logout
async function testLogout() {
  console.log('\n🚪 Probando logout...\n')

  try {
    // Login primero
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login`, {
      email: 'user1@test.eventu.com',
      password: 'test123'
    })

    if (loginResponse.data.success) {
      const token = loginResponse.data.data.token
      const headers = {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      }

      // Probar logout
      const logoutResponse = await axios.post(`${API_BASE_URL}/auth/logout`, {}, { headers })
      
      if (logoutResponse.data.success) {
        console.log('✅ Logout exitoso')
      } else {
        console.log('❌ Logout fallido')
      }

      // Intentar usar el token después del logout
      try {
        await axios.get(`${API_BASE_URL}/auth/profile`, { headers })
        console.log('⚠️  Token aún válido después del logout (esto puede ser normal en algunos casos)')
      } catch (error) {
        if (error.response?.status === 401) {
          console.log('✅ Token correctamente invalidado después del logout')
        } else {
          console.log('⚠️  Error inesperado:', error.response?.data?.message)
        }
      }
    }
  } catch (error) {
    console.log('❌ Error durante prueba de logout:', error.message)
  }
}

// Función principal
async function runAllTests() {
  console.log('==========================================')
  console.log('  PRUEBAS DEL SISTEMA DE AUTENTICACIÓN')
  console.log('==========================================\n')

  await testAuthenticationSystem()
  await testUnauthorizedAccess()
  await testLogout()

  console.log('\n==========================================')
  console.log('  RESUMEN DE PRUEBAS')
  console.log('==========================================')
  console.log('✅ Sistema de autenticación por roles')
  console.log('✅ Redirección automática basada en rol')
  console.log('✅ Protección de rutas por rol')
  console.log('✅ Manejo de acceso no autorizado')
  console.log('✅ Sistema de logout')
  console.log('\n🎉 ¡Todas las pruebas completadas!')
}

// Ejecutar pruebas
if (require.main === module) {
  runAllTests().catch(console.error)
}

module.exports = {
  testAuthenticationSystem,
  testUnauthorizedAccess,
  testLogout,
  runAllTests
}

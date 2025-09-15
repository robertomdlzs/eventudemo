// Script para probar el logging de login
const fetch = (...args) => import('node-fetch').then(({default: fetch}) => fetch(...args))

async function testLoginLogging() {
  try {
    console.log('🧪 Probando el logging de login...')
    
    // Simular un login exitoso
    const loginResponse = await fetch('http://localhost:3002/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'admin@eventu.co',
        password: 'admin123'
      })
    })
    
    const loginData = await loginResponse.json()
    console.log('📝 Respuesta del login:', loginData.success ? '✅ Exitoso' : '❌ Fallido')
    
    if (loginData.success) {
      console.log('🔑 Token recibido:', loginData.data?.token ? 'Sí' : 'No')
      
      // Esperar un momento para que se registre en la base de datos
      await new Promise(resolve => setTimeout(resolve, 1000))
      
      // Verificar los logs de auditoría
      const auditResponse = await fetch('http://localhost:3002/api/audit/logs?limit=5', {
        headers: {
          'Authorization': `Bearer ${loginData.data.token}`,
          'Content-Type': 'application/json'
        }
      })
      
      const auditData = await auditResponse.json()
      console.log('📊 Logs de auditoría obtenidos:', auditData.success ? '✅ Sí' : '❌ No')
      
      if (auditData.success && auditData.data.logs) {
        console.log('📋 Últimos 5 logs:')
        auditData.data.logs.forEach((log, i) => {
          console.log(`  ${i+1}. ${log.action} - ${log.user_email} - ${log.status} - ${log.timestamp}`)
        })
        
        // Buscar el login reciente
        const recentLogin = auditData.data.logs.find(log => 
          log.action === 'LOGIN' && 
          log.user_email === 'admin@eventu.co' &&
          log.status === 'success'
        )
        
        if (recentLogin) {
          console.log('✅ ¡Login registrado correctamente en auditoría!')
          console.log(`   Usuario: ${recentLogin.user_name}`)
          console.log(`   Email: ${recentLogin.user_email}`)
          console.log(`   Acción: ${recentLogin.action}`)
          console.log(`   Estado: ${recentLogin.status}`)
          console.log(`   Timestamp: ${recentLogin.timestamp}`)
        } else {
          console.log('❌ No se encontró el login en los logs recientes')
        }
      }
    }
    
    // Probar un login fallido
    console.log('\n🧪 Probando login fallido...')
    const failedLoginResponse = await fetch('http://localhost:3002/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'test@nonexistent.com',
        password: 'wrongpassword'
      })
    })
    
    const failedLoginData = await failedLoginResponse.json()
    console.log('📝 Respuesta del login fallido:', failedLoginData.success ? '✅ Exitoso' : '❌ Fallido (esperado)')
    
    // Esperar y verificar logs de login fallido
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    const auditResponse2 = await fetch('http://localhost:3002/api/audit/logs?limit=10', {
      headers: {
        'Authorization': `Bearer ${loginData.data?.token || 'test-token'}`,
        'Content-Type': 'application/json'
      }
    })
    
    const auditData2 = await auditResponse2.json()
    if (auditData2.success && auditData2.data.logs) {
      const failedLogin = auditData2.data.logs.find(log => 
        log.action === 'LOGIN' && 
        log.user_email === 'test@nonexistent.com' &&
        log.status === 'failure'
      )
      
      if (failedLogin) {
        console.log('✅ ¡Login fallido registrado correctamente en auditoría!')
        console.log(`   Email: ${failedLogin.user_email}`)
        console.log(`   Estado: ${failedLogin.status}`)
      } else {
        console.log('❌ No se encontró el login fallido en los logs')
      }
    }
    
  } catch (error) {
    console.error('❌ Error en la prueba:', error.message)
  }
}

testLoginLogging()

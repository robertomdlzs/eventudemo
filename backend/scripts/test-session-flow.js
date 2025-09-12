const jwt = require('jsonwebtoken')
const fetch = require('node-fetch')

async function testSessionFlow() {
  console.log('🧪 Probando flujo de sesión...')
  
  try {
    // 1. Crear un token de prueba
    const testToken = jwt.sign(
      { 
        userId: '1', 
        email: 'admin@eventu.com', 
        role: 'admin',
        lastActivity: Date.now()
      },
      'your-super-secret-jwt-key-change-this-in-production',
      { expiresIn: '7d' }
    )
    
    console.log('✅ Token creado:', testToken.substring(0, 50) + '...')
    
    // 2. Probar endpoint de verificación de token
    console.log('📡 Probando /api/auth/verify-token...')
    const verifyResponse = await fetch('http://localhost:3002/api/auth/verify-token', {
      headers: {
        'Authorization': `Bearer ${testToken}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('📊 Respuesta verify-token:', verifyResponse.status)
    if (verifyResponse.ok) {
      const verifyData = await verifyResponse.json()
      console.log('✅ Token verificado:', verifyData.message)
      
      // Verificar si hay nuevo token
      const newToken = verifyResponse.headers.get('X-New-Token')
      if (newToken) {
        console.log('🔄 Nuevo token recibido:', newToken.substring(0, 50) + '...')
      }
    } else {
      const errorData = await verifyResponse.json()
      console.log('❌ Error verificando token:', errorData)
    }
    
    // 3. Probar endpoint de auditoría
    console.log('📡 Probando /api/audit/logs...')
    const auditResponse = await fetch('http://localhost:3002/api/audit/logs?limit=5', {
      headers: {
        'Authorization': `Bearer ${testToken}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('📊 Respuesta audit-logs:', auditResponse.status)
    if (auditResponse.ok) {
      const auditData = await auditResponse.json()
      console.log('✅ Logs obtenidos:', auditData.data.logs.length, 'registros')
      
      // Verificar si hay nuevo token
      const newToken = auditResponse.headers.get('X-New-Token')
      if (newToken) {
        console.log('🔄 Nuevo token recibido:', newToken.substring(0, 50) + '...')
      }
    } else {
      const errorData = await auditResponse.json()
      console.log('❌ Error obteniendo logs:', errorData)
    }
    
    // 4. Probar con token expirado
    console.log('📡 Probando con token expirado...')
    const expiredToken = jwt.sign(
      { 
        userId: '1', 
        email: 'admin@eventu.com', 
        role: 'admin',
        lastActivity: Date.now() - (20 * 60 * 1000) // 20 minutos atrás
      },
      'your-super-secret-jwt-key-change-this-in-production',
      { expiresIn: '7d' }
    )
    
    const expiredResponse = await fetch('http://localhost:3002/api/auth/verify-token', {
      headers: {
        'Authorization': `Bearer ${expiredToken}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('📊 Respuesta token expirado:', expiredResponse.status)
    if (!expiredResponse.ok) {
      const errorData = await expiredResponse.json()
      console.log('✅ Token expirado correctamente:', errorData.code)
    }
    
  } catch (error) {
    console.error('❌ Error en prueba:', error.message)
  }
}

testSessionFlow()

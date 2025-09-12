const jwt = require('jsonwebtoken')

async function debugFrontendConnection() {
  console.log('🔍 Debugging frontend-backend connection...')
  
  try {
    // 1. Crear un token de prueba válido
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
    
    console.log('✅ Token de prueba creado')
    console.log('🔑 Token:', testToken.substring(0, 50) + '...')
    
    // 2. Probar endpoint de verificación
    console.log('\n📡 Probando /api/auth/verify-token...')
    const verifyResponse = await fetch('http://localhost:3002/api/auth/verify-token', {
      headers: {
        'Authorization': `Bearer ${testToken}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('📊 Status:', verifyResponse.status)
    if (verifyResponse.ok) {
      const data = await verifyResponse.json()
      console.log('✅ Respuesta:', data)
    } else {
      const error = await verifyResponse.text()
      console.log('❌ Error:', error)
    }
    
    // 3. Probar endpoint de auditoría
    console.log('\n📡 Probando /api/audit/logs...')
    const auditResponse = await fetch('http://localhost:3002/api/audit/logs?limit=5', {
      headers: {
        'Authorization': `Bearer ${testToken}`,
        'Content-Type': 'application/json'
      }
    })
    
    console.log('📊 Status:', auditResponse.status)
    if (auditResponse.ok) {
      const data = await auditResponse.json()
      console.log('✅ Logs encontrados:', data.data?.logs?.length || 0)
      if (data.data?.logs?.length > 0) {
        console.log('📋 Primer log:', data.data.logs[0])
      }
    } else {
      const error = await auditResponse.text()
      console.log('❌ Error:', error)
    }
    
    // 4. Probar con token expirado
    console.log('\n📡 Probando con token expirado...')
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
    
    console.log('📊 Status token expirado:', expiredResponse.status)
    if (!expiredResponse.ok) {
      const error = await expiredResponse.json()
      console.log('✅ Token expirado correctamente:', error.code)
    }
    
  } catch (error) {
    console.error('❌ Error en debug:', error.message)
  }
}

// Usar fetch nativo de Node.js 18+
if (typeof fetch === 'undefined') {
  console.log('⚠️ Fetch no disponible, usando curl...')
  
  // Crear token
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
  
  console.log('🔑 Token de prueba:')
  console.log(testToken)
  console.log('\n📋 Usa este token para probar manualmente:')
  console.log('curl -H "Authorization: Bearer ' + testToken + '" http://localhost:3002/api/auth/verify-token')
  console.log('curl -H "Authorization: Bearer ' + testToken + '" http://localhost:3002/api/audit/logs?limit=5')
} else {
  debugFrontendConnection()
}

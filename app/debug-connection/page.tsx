"use client"

import { useState, useEffect } from 'react'

export default function DebugConnectionPage() {
  const [results, setResults] = useState<any[]>([])
  const [loading, setLoading] = useState(false)

  const addResult = (message: string, type: 'info' | 'success' | 'error' = 'info') => {
    setResults(prev => [...prev, { message, type, timestamp: new Date().toLocaleTimeString() }])
  }

  const testConnection = async () => {
    setLoading(true)
    setResults([])
    
    addResult('🔍 Iniciando pruebas de conexión...')
    
    try {
      // 1. Verificar localStorage
      const token = localStorage.getItem("auth_token")
      const isAuth = localStorage.getItem("eventu_authenticated")
      const user = localStorage.getItem("current_user")
      
      addResult(`📱 Token en localStorage: ${token ? 'Sí' : 'No'}`)
      addResult(`📱 Autenticado: ${isAuth}`)
      addResult(`📱 Usuario: ${user ? 'Sí' : 'No'}`)
      
      if (!token) {
        addResult('❌ No hay token de autenticación', 'error')
        return
      }
      
      // 2. Probar endpoint de verificación
      addResult('📡 Probando /api/auth/verify-token...')
      const verifyResponse = await fetch('http://localhost:3002/api/auth/verify-token', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      
      addResult(`📊 Status verify-token: ${verifyResponse.status}`)
      
      if (verifyResponse.ok) {
        const verifyData = await verifyResponse.json()
        addResult(`✅ Token válido: ${verifyData.message}`, 'success')
        addResult(`👤 Usuario: ${verifyData.user?.email}`)
      } else {
        const errorData = await verifyResponse.json().catch(() => ({}))
        addResult(`❌ Error verify-token: ${JSON.stringify(errorData)}`, 'error')
      }
      
      // 3. Probar endpoint de auditoría
      addResult('📡 Probando /api/audit/logs...')
      const auditResponse = await fetch('http://localhost:3002/api/audit/logs?limit=5', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })
      
      addResult(`📊 Status audit-logs: ${auditResponse.status}`)
      
      if (auditResponse.ok) {
        const auditData = await auditResponse.json()
        addResult(`✅ Logs obtenidos: ${auditData.data?.logs?.length || 0} registros`, 'success')
        
        if (auditData.data?.logs?.length > 0) {
          const firstLog = auditData.data.logs[0]
          addResult(`📋 Primer log: ${firstLog.action} - ${firstLog.user_email}`)
        }
      } else {
        const errorData = await auditResponse.json().catch(() => ({}))
        addResult(`❌ Error audit-logs: ${JSON.stringify(errorData)}`, 'error')
      }
      
      // 4. Probar recarga de página
      addResult('🔄 Probando persistencia de sesión...')
      setTimeout(() => {
        const tokenAfter = localStorage.getItem("auth_token")
        if (tokenAfter === token) {
          addResult('✅ Token persiste después de la prueba', 'success')
        } else {
          addResult('❌ Token cambió durante la prueba', 'error')
        }
      }, 1000)
      
    } catch (error) {
      addResult(`❌ Error de conexión: ${error}`, 'error')
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    testConnection()
  }, [])

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Debug de Conexión Frontend-Backend</h1>
      
      <div className="mb-4">
        <button 
          onClick={testConnection}
          disabled={loading}
          className="bg-blue-500 text-white px-4 py-2 rounded disabled:opacity-50"
        >
          {loading ? 'Probando...' : 'Probar Conexión'}
        </button>
      </div>

      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {results.map((result, index) => (
            <li key={index} className="px-6 py-4">
              <div className={`flex items-center ${
                result.type === 'success' ? 'text-green-700' : 
                result.type === 'error' ? 'text-red-700' : 
                'text-gray-700'
              }`}>
                <span className="text-sm font-mono mr-2">{result.timestamp}</span>
                <span className="text-sm">{result.message}</span>
              </div>
            </li>
          ))}
        </ul>
      </div>

      {results.length === 0 && !loading && (
        <div className="text-center py-8 text-gray-500">
          No hay resultados de prueba
        </div>
      )}
    </div>
  )
}

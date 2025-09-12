"use client"

import { useState, useEffect } from 'react'

export default function TestAuditPage() {
  const [logs, setLogs] = useState<any[]>([])
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const testAuditConnection = async () => {
    setLoading(true)
    setError(null)
    
    try {
      const token = localStorage.getItem("auth_token")
      console.log('🔍 Token encontrado:', token ? 'Sí' : 'No')
      
      if (!token) {
        setError('No hay token de autenticación')
        return
      }

      console.log('📡 Haciendo petición a /api/audit/logs...')
      const response = await fetch('http://localhost:3002/api/audit/logs?limit=10', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })

      console.log('📊 Respuesta del servidor:', response.status, response.statusText)
      
      if (response.ok) {
        const data = await response.json()
        console.log('📋 Datos recibidos:', data)
        
        if (data.success && data.data && data.data.logs) {
          setLogs(data.data.logs)
          console.log('✅ Logs cargados exitosamente:', data.data.logs.length)
        } else {
          setError('No se encontraron logs en la respuesta')
        }
      } else {
        const errorData = await response.json().catch(() => ({}))
        setError(`Error del servidor: ${response.status} - ${JSON.stringify(errorData)}`)
        console.log('❌ Error del servidor:', errorData)
      }
    } catch (error) {
      setError(`Error de conexión: ${error}`)
      console.error('❌ Error:', error)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    testAuditConnection()
  }, [])

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Prueba de Conexión de Auditoría</h1>
      
      <div className="mb-4">
        <button 
          onClick={testAuditConnection}
          disabled={loading}
          className="bg-blue-500 text-white px-4 py-2 rounded disabled:opacity-50"
        >
          {loading ? 'Cargando...' : 'Probar Conexión'}
        </button>
      </div>

      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          <strong>Error:</strong> {error}
        </div>
      )}

      {logs.length > 0 && (
        <div className="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-4">
          <strong>Éxito:</strong> Se encontraron {logs.length} logs de auditoría
        </div>
      )}

      <div className="bg-white shadow overflow-hidden sm:rounded-md">
        <ul className="divide-y divide-gray-200">
          {logs.map((log) => (
            <li key={log.id} className="px-6 py-4">
              <div className="flex items-center justify-between">
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">
                    {log.action} - {log.user_email}
                  </p>
                  <p className="text-sm text-gray-500">
                    {log.resource} - {new Date(log.timestamp).toLocaleString()}
                  </p>
                  <p className="text-xs text-gray-400">
                    IP: {log.ip_address} | Severidad: {log.severity} | Estado: {log.status}
                  </p>
                </div>
                <div className="ml-4">
                  <span className={`inline-flex px-2 py-1 text-xs font-semibold rounded-full ${
                    log.status === 'success' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                  }`}>
                    {log.status}
                  </span>
                </div>
              </div>
            </li>
          ))}
        </ul>
      </div>

      {logs.length === 0 && !loading && !error && (
        <div className="text-center py-8 text-gray-500">
          No se encontraron logs de auditoría
        </div>
      )}
    </div>
  )
}

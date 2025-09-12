"use client"

import { useAuth } from "@/hooks/use-auth"
import { useState, useEffect } from "react"

export default function TestAuthPage() {
  const { isAuthenticated, user, token, isLoading } = useAuth()
  const [logs, setLogs] = useState<string[]>([])

  const addLog = (message: string) => {
    setLogs(prev => [...prev, `${new Date().toLocaleTimeString()}: ${message}`])
  }

  useEffect(() => {
    addLog(`Estado de autenticación: ${isAuthenticated ? 'Autenticado' : 'No autenticado'}`)
    addLog(`Usuario: ${user ? user.email : 'Ninguno'}`)
    addLog(`Token: ${token ? 'Presente' : 'Ausente'}`)
    addLog(`Cargando: ${isLoading ? 'Sí' : 'No'}`)
  }, [isAuthenticated, user, token, isLoading])

  const testAuditLogs = async () => {
    if (!token) {
      addLog('❌ No hay token para probar')
      return
    }

    try {
      addLog('📡 Probando endpoint de auditoría...')
      const response = await fetch('http://localhost:3002/api/audit/logs?limit=5', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })

      addLog(`📊 Status: ${response.status}`)
      
      if (response.ok) {
        const data = await response.json()
        addLog(`✅ Logs obtenidos: ${data.data?.logs?.length || 0}`)
      } else {
        const error = await response.json().catch(() => ({}))
        addLog(`❌ Error: ${JSON.stringify(error)}`)
      }
    } catch (error) {
      addLog(`❌ Error de conexión: ${error}`)
    }
  }

  const testVerifyToken = async () => {
    if (!token) {
      addLog('❌ No hay token para probar')
      return
    }

    try {
      addLog('📡 Probando verificación de token...')
      const response = await fetch('http://localhost:3002/api/auth/verify-token', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })

      addLog(`📊 Status: ${response.status}`)
      
      if (response.ok) {
        const data = await response.json()
        addLog(`✅ Token válido: ${data.message}`)
      } else {
        const error = await response.json().catch(() => ({}))
        addLog(`❌ Error: ${JSON.stringify(error)}`)
      }
    } catch (error) {
      addLog(`❌ Error de conexión: ${error}`)
    }
  }

  return (
    <div className="container mx-auto p-6">
      <h1 className="text-2xl font-bold mb-6">Prueba de Autenticación</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-lg font-semibold mb-4">Estado de Autenticación</h2>
          <div className="space-y-2">
            <p><strong>Autenticado:</strong> {isAuthenticated ? '✅ Sí' : '❌ No'}</p>
            <p><strong>Usuario:</strong> {user ? user.email : 'Ninguno'}</p>
            <p><strong>Token:</strong> {token ? '✅ Presente' : '❌ Ausente'}</p>
            <p><strong>Cargando:</strong> {isLoading ? '⏳ Sí' : '✅ No'}</p>
          </div>
        </div>

        <div className="bg-white p-6 rounded-lg shadow">
          <h2 className="text-lg font-semibold mb-4">Pruebas de API</h2>
          <div className="space-y-2">
            <button 
              onClick={testVerifyToken}
              className="w-full bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            >
              Probar Verificación de Token
            </button>
            <button 
              onClick={testAuditLogs}
              className="w-full bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
            >
              Probar Logs de Auditoría
            </button>
          </div>
        </div>
      </div>

      <div className="mt-6 bg-white p-6 rounded-lg shadow">
        <h2 className="text-lg font-semibold mb-4">Logs de Prueba</h2>
        <div className="bg-gray-100 p-4 rounded max-h-96 overflow-y-auto">
          {logs.map((log, index) => (
            <div key={index} className="text-sm font-mono mb-1">
              {log}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

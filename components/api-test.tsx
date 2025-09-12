"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Loader2, CheckCircle2, XCircle, Server, Database, Wifi } from "lucide-react"
import { apiClient } from "@/lib/api-client"

export function ApiTest() {
  const [isTestingConnection, setIsTestingConnection] = useState(false)
  const [isTestingAuth, setIsTestingAuth] = useState(false)
  const [isTestingEvents, setIsTestingEvents] = useState(false)
  const [connectionStatus, setConnectionStatus] = useState<"idle" | "success" | "error">("idle")
  const [authStatus, setAuthStatus] = useState<"idle" | "success" | "error">("idle")
  const [eventsStatus, setEventsStatus] = useState<"idle" | "success" | "error">("idle")
  const [testResults, setTestResults] = useState<string[]>([])

  const addResult = (message: string) => {
    setTestResults((prev) => [...prev, `${new Date().toLocaleTimeString()}: ${message}`])
  }

  const testConnection = async () => {
    setIsTestingConnection(true)
    setConnectionStatus("idle")
    addResult("Probando conexión al backend...")

    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || "http://localhost:3002"}/api/health`)

      if (response.ok) {
        const data = await response.json()
        setConnectionStatus("success")
        addResult(`✅ Conexión exitosa: ${data.status}`)
      } else {
        setConnectionStatus("error")
        addResult(`❌ Error de conexión: ${response.status}`)
      }
    } catch (error) {
      setConnectionStatus("error")
      addResult(`❌ Error de red: ${error instanceof Error ? error.message : "Error desconocido"}`)
    }

    setIsTestingConnection(false)
  }

  const testAuth = async () => {
    setIsTestingAuth(true)
    setAuthStatus("idle")
    addResult("Probando autenticación...")

    try {
      const response = await apiClient.login("demo@eventu.co", "demo123")

      if (response.success) {
        setAuthStatus("success")
        addResult(`✅ Login exitoso: ${response.user?.name || "Usuario"}`)
      } else {
        setAuthStatus("error")
        addResult(`❌ Error de login: ${response.error || "Error desconocido"}`)
      }
    } catch (error) {
      setAuthStatus("error")
      addResult(`❌ Error de autenticación: ${error instanceof Error ? error.message : "Error desconocido"}`)
    }

    setIsTestingAuth(false)
  }

  const testEvents = async () => {
    setIsTestingEvents(true)
    setEventsStatus("idle")
    addResult("Probando API de eventos...")

    try {
      const response = await apiClient.getEvents()

      if (response.success && response.data) {
        setEventsStatus("success")
        addResult(`✅ Eventos obtenidos: ${response.data.length} eventos`)
      } else {
        setEventsStatus("error")
        addResult(`❌ Error al obtener eventos: ${response.error || "Error desconocido"}`)
      }
    } catch (error) {
      setEventsStatus("error")
      addResult(`❌ Error de API: ${error instanceof Error ? error.message : "Error desconocido"}`)
    }

    setIsTestingEvents(false)
  }

  const runAllTests = async () => {
    setTestResults([])
    await testConnection()
    await new Promise((resolve) => setTimeout(resolve, 1000))
    await testAuth()
    await new Promise((resolve) => setTimeout(resolve, 1000))
    await testEvents()
  }

  const getStatusIcon = (status: "idle" | "success" | "error") => {
    switch (status) {
      case "success":
        return <CheckCircle2 className="h-4 w-4 text-green-500" />
      case "error":
        return <XCircle className="h-4 w-4 text-red-500" />
      default:
        return <Wifi className="h-4 w-4 text-gray-400" />
    }
  }

  const getStatusBadge = (status: "idle" | "success" | "error") => {
    switch (status) {
      case "success":
        return (
          <Badge variant="default" className="bg-green-100 text-green-800">
            ✓
          </Badge>
        )
      case "error":
        return <Badge variant="destructive">Error</Badge>
      default:
        return <Badge variant="secondary">Sin probar</Badge>
    }
  }

  return (
    <Card className="w-full max-w-2xl">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Server className="h-5 w-5" />
          Prueba de Integración API
        </CardTitle>
        <CardDescription>Verifica la conexión entre el frontend y el backend Node.js</CardDescription>
      </CardHeader>
      <CardContent className="space-y-6">
        {/* Test Controls */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <Button onClick={runAllTests} className="w-full">
            Ejecutar Todas las Pruebas
          </Button>
          <div className="text-sm text-gray-600">
            Backend URL: {process.env.NEXT_PUBLIC_API_URL || "http://localhost:3002"}
          </div>
        </div>

        {/* Individual Tests */}
        <div className="space-y-4">
          <div className="flex items-center justify-between p-4 border rounded-lg">
            <div className="flex items-center gap-3">
              {getStatusIcon(connectionStatus)}
              <div>
                <div className="font-medium">Conexión al Servidor</div>
                <div className="text-sm text-gray-600">Prueba el endpoint /api/health</div>
              </div>
            </div>
            <div className="flex items-center gap-2">
              {getStatusBadge(connectionStatus)}
              <Button onClick={testConnection} disabled={isTestingConnection} size="sm" variant="outline">
                {isTestingConnection ? <Loader2 className="h-4 w-4 animate-spin" /> : "Probar"}
              </Button>
            </div>
          </div>

          <div className="flex items-center justify-between p-4 border rounded-lg">
            <div className="flex items-center gap-3">
              {getStatusIcon(authStatus)}
              <div>
                <div className="font-medium">Autenticación</div>
                <div className="text-sm text-gray-600">Prueba login con credenciales demo</div>
              </div>
            </div>
            <div className="flex items-center gap-2">
              {getStatusBadge(authStatus)}
              <Button onClick={testAuth} disabled={isTestingAuth} size="sm" variant="outline">
                {isTestingAuth ? <Loader2 className="h-4 w-4 animate-spin" /> : "Probar"}
              </Button>
            </div>
          </div>

          <div className="flex items-center justify-between p-4 border rounded-lg">
            <div className="flex items-center gap-3">
              {getStatusIcon(eventsStatus)}
              <div>
                <div className="font-medium">API de Eventos</div>
                <div className="text-sm text-gray-600">Obtiene la lista de eventos</div>
              </div>
            </div>
            <div className="flex items-center gap-2">
              {getStatusBadge(eventsStatus)}
              <Button onClick={testEvents} disabled={isTestingEvents} size="sm" variant="outline">
                {isTestingEvents ? <Loader2 className="h-4 w-4 animate-spin" /> : "Probar"}
              </Button>
            </div>
          </div>
        </div>

        {/* Test Results */}
        {testResults.length > 0 && (
          <div className="space-y-2">
            <h3 className="font-medium flex items-center gap-2">
              <Database className="h-4 w-4" />
              Resultados de las Pruebas
            </h3>
            <div className="bg-gray-50 rounded-lg p-4 max-h-60 overflow-y-auto">
              <div className="space-y-1 text-sm font-mono">
                {testResults.map((result, index) => (
                  <div key={index} className="text-gray-700">
                    {result}
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </CardContent>
    </Card>
  )
}

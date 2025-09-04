"use client"

import type React from "react"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { CheckCircle, XCircle, Loader2, Wifi, Database, Server } from "lucide-react"
import { apiClient } from "@/lib/api-client"

interface TestResult {
  name: string
  status: "pending" | "success" | "error"
  message: string
  icon: React.ReactNode
}

export function ConnectionTest() {
  const [testing, setTesting] = useState(false)
  const [results, setResults] = useState<TestResult[]>([])
  const apiBase = (process.env.NEXT_PUBLIC_API_URL?.replace(/\/+$/, "") || (typeof window !== "undefined" ? `${window.location.origin}/api` : "http://localhost:3002/api"))

  const runTests = async () => {
    setTesting(true)
    const testResults: TestResult[] = []

    // Test 1: Backend Health Check
    testResults.push({
      name: "Conexión Backend",
      status: "pending",
      message: "Verificando conexión al servidor...",
      icon: <Server className="h-4 w-4" />,
    })
    setResults([...testResults])

    try {
      const response = await fetch(`${apiBase}/health`)
      if (response.ok) {
        testResults[0] = {
          ...testResults[0],
          status: "success",
          message: `Backend conectado correctamente (${apiBase})`,
        }
      } else {
        testResults[0] = {
          ...testResults[0],
          status: "error",
          message: `Error HTTP: ${response.status}`,
        }
      }
    } catch (error) {
      testResults[0] = {
        ...testResults[0],
        status: "error",
        message: "Backend no disponible - Verificar que esté corriendo",
      }
    }
    setResults([...testResults])

    // Test 2: Database Connection
    testResults.push({
      name: "Base de Datos",
      status: "pending",
      message: "Verificando conexión a PostgreSQL...",
      icon: <Database className="h-4 w-4" />,
    })
    setResults([...testResults])

    try {
      const response = await apiClient.getEvents()
      if (response.success) {
        testResults[1] = {
          ...testResults[1],
          status: "success",
          message: "Base de datos conectada y funcionando",
        }
      } else {
        testResults[1] = {
          ...testResults[1],
          status: "error",
          message: response.error || "Error al consultar la base de datos",
        }
      }
    } catch (error) {
      testResults[1] = {
        ...testResults[1],
        status: "error",
        message: "Error de conexión a la base de datos",
      }
    }
    setResults([...testResults])

    // Test 3: API Endpoints
    testResults.push({
      name: "APIs REST",
      status: "pending",
      message: "Probando endpoints principales...",
      icon: <Wifi className="h-4 w-4" />,
    })
    setResults([...testResults])

    try {
      const [eventsResponse, categoriesResponse] = await Promise.all([apiClient.getEvents(), apiClient.getCategories()])

      if (eventsResponse.success && categoriesResponse.success) {
        testResults[2] = {
          ...testResults[2],
          status: "success",
          message: "Todos los endpoints funcionando correctamente",
        }
      } else {
        testResults[2] = {
          ...testResults[2],
          status: "error",
          message: "Algunos endpoints no responden correctamente",
        }
      }
    } catch (error) {
      testResults[2] = {
        ...testResults[2],
        status: "error",
        message: "Error al probar los endpoints de API",
      }
    }
    setResults([...testResults])

    setTesting(false)
  }

  const getStatusIcon = (status: TestResult["status"]) => {
    switch (status) {
      case "success":
        return <CheckCircle className="h-4 w-4 text-green-500" />
      case "error":
        return <XCircle className="h-4 w-4 text-red-500" />
      case "pending":
        return <Loader2 className="h-4 w-4 animate-spin text-blue-500" />
    }
  }

  const getStatusBadge = (status: TestResult["status"]) => {
    switch (status) {
      case "success":
        return (
          <Badge variant="default" className="bg-green-100 text-green-800">
            Conectado
          </Badge>
        )
      case "error":
        return <Badge variant="destructive">Error</Badge>
      case "pending":
        return <Badge variant="secondary">Probando...</Badge>
    }
  }

  return (
    <Card className="w-full max-w-2xl mx-auto">
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <Wifi className="h-5 w-5" />
          Prueba de Conectividad
        </CardTitle>
        <CardDescription>Verifica la conexión entre el frontend y backend</CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <Button onClick={runTests} disabled={testing} className="w-full">
          {testing ? (
            <>
              <Loader2 className="mr-2 h-4 w-4 animate-spin" />
              Probando conexión...
            </>
          ) : (
            "Probar Conectividad"
          )}
        </Button>

        {results.length > 0 && (
          <div className="space-y-3">
            {results.map((result, index) => (
              <div key={index} className="flex items-center justify-between p-3 border rounded-lg">
                <div className="flex items-center gap-3">
                  {result.icon}
                  <div>
                    <p className="font-medium">{result.name}</p>
                    <p className="text-sm text-muted-foreground">{result.message}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  {getStatusIcon(result.status)}
                  {getStatusBadge(result.status)}
                </div>
              </div>
            ))}
          </div>
        )}

        <div className="text-xs text-muted-foreground mt-4 p-3 bg-muted rounded-lg">
          <p>
            <strong>Configuración actual:</strong>
          </p>
          <p>• Frontend: http://localhost:3000</p>
          <p>• Backend: {apiBase}</p>
          <p>• Base de datos: PostgreSQL (Puerto 5432)</p>
        </div>
      </CardContent>
    </Card>
  )
}

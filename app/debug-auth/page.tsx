"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"

export default function DebugAuthPage() {
  const [authData, setAuthData] = useState<any>({})

  useEffect(() => {
    const data = {
      eventu_authenticated: localStorage.getItem("eventu_authenticated"),
      auth_token: localStorage.getItem("auth_token"),
      current_user: localStorage.getItem("current_user"),
      eventu_user_id: localStorage.getItem("eventu_user_id"),
      eventu_user_email: localStorage.getItem("eventu_user_email"),
    }
    
    setAuthData(data)
  }, [])

  const clearAuth = () => {
    localStorage.removeItem("eventu_authenticated")
    localStorage.removeItem("auth_token")
    localStorage.removeItem("current_user")
    localStorage.removeItem("eventu_user_id")
    localStorage.removeItem("eventu_user_email")
    window.location.reload()
  }

  const setTestAuth = () => {
    localStorage.setItem("eventu_authenticated", "true")
    localStorage.setItem("auth_token", "test-token")
    localStorage.setItem("current_user", JSON.stringify({
      id: 1,
      email: "test@eventu.co",
      first_name: "Test",
      last_name: "User",
      name: "Test User",
      phone: "3001234567"
    }))
    localStorage.setItem("eventu_user_id", "1")
    localStorage.setItem("eventu_user_email", "test@eventu.co")
    window.location.reload()
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8">Debug de Autenticación</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <Card>
          <CardHeader>
            <CardTitle>Datos de Autenticación</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {Object.entries(authData).map(([key, value]) => (
                <div key={key} className="flex justify-between">
                  <span className="font-medium">{key}:</span>
                  <span className="text-sm bg-gray-100 p-1 rounded">
                    {typeof value === 'string' && value.length > 50 
                      ? value.substring(0, 50) + '...' 
                      : value || 'null'}
                  </span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Acciones</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <Button onClick={setTestAuth} className="w-full">
              Establecer Auth de Prueba
            </Button>
            <Button onClick={clearAuth} variant="destructive" className="w-full">
              Limpiar Auth
            </Button>
            <Button onClick={() => window.location.reload()} variant="outline" className="w-full">
              Recargar Página
            </Button>
          </CardContent>
        </Card>
      </div>

      <Card className="mt-6">
        <CardHeader>
          <CardTitle>Pruebas de Navegación</CardTitle>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <Button onClick={() => window.location.href = '/checkout'} className="w-full">
              Ir al Checkout
            </Button>
            <Button onClick={() => window.location.href = '/mi-cuenta'} className="w-full">
              Ir a Mi Cuenta
            </Button>
            <Button onClick={() => window.location.href = '/carrito'} className="w-full">
              Ir al Carrito
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

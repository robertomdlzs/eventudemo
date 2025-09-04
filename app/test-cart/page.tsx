"use client"

import { useCart } from "@/hooks/use-cart"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"

export default function TestCartPage() {
  const { cart, addToCart, clearCart, getCartItemCount } = useCart()

  const handleAddTestItem = () => {
    addToCart({
      eventId: "test-event-1",
      eventTitle: "Evento de Prueba",
      eventSlug: "evento-prueba",
      ticketTypeId: "general",
      ticketTypeName: "General",
      quantity: 2,
      price: 50000,
      eventDate: "2025-09-01",
      eventLocation: "Bogotá"
    })
  }

  const handleCheckLocalStorage = () => {
    const savedCart = localStorage.getItem('eventu_cart')
    console.log('localStorage cart:', savedCart)
    if (savedCart) {
      console.log('Parsed cart:', JSON.parse(savedCart))
    }
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8">Prueba del Carrito</h1>
      
      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <Card>
          <CardHeader>
            <CardTitle>Acciones</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <Button onClick={handleAddTestItem} className="w-full">
              Agregar Item de Prueba
            </Button>
            <Button onClick={handleCheckLocalStorage} variant="outline" className="w-full">
              Verificar localStorage
            </Button>
            <Button onClick={clearCart} variant="destructive" className="w-full">
              Limpiar Carrito
            </Button>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Estado del Carrito</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div>
                <strong>Total de items:</strong> {getCartItemCount()}
              </div>
              <div>
                <strong>Items en carrito:</strong> {cart.items.length}
              </div>
              <div>
                <strong>Total precio:</strong> ${cart.total.toLocaleString()}
              </div>
              
              {cart.items.length > 0 && (
                <div>
                  <strong>Items:</strong>
                  <ul className="mt-2 space-y-2">
                    {cart.items.map((item, index) => (
                      <li key={item.id} className="text-sm border p-2 rounded">
                        <div><strong>{item.eventTitle}</strong></div>
                        <div>{item.ticketTypeName} - {item.quantity} x ${item.price.toLocaleString()}</div>
                        <div className="text-gray-500">ID: {item.id}</div>
                      </li>
                    ))}
                  </ul>
                </div>
              )}
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="mt-8">
        <Card>
          <CardHeader>
            <CardTitle>Logs del Console</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-gray-600">
              Abre las herramientas de desarrollador (F12) y ve a la pestaña Console para ver los logs del carrito.
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}

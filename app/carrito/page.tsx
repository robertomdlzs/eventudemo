"use client"

import { useState, useEffect } from "react"
import { useCart } from "@/hooks/use-cart"
import { useServiceFee } from "@/hooks/use-service-fee"
import { useEventPaymentMethods } from "@/hooks/use-event-payment-methods"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Separator } from "@/components/ui/separator"
import { Trash2, ShoppingCart, ArrowRight, MapPin, Calendar, Clock } from "lucide-react"
import Link from "next/link"
import { useRouter } from "next/navigation"

export default function CarritoPage() {
  const { cart, removeFromCart, updateCartItem, clearCart } = useCart()
  const { getCartServiceFee, isLoading: isServiceFeeLoading } = useServiceFee()
  const router = useRouter()
  const [serviceFeeData, setServiceFeeData] = useState<{
    total: number
    breakdown: Array<{
      eventId: string
      eventTitle: string
      amount: number
      serviceFee: number
      config: any
    }>
  } | null>(null)
  const [availablePaymentMethods, setAvailablePaymentMethods] = useState<any[]>([])
  
  console.log('CarritoPage - Estado del carrito:', cart)

  // Calcular tarifa de servicio cuando cambie el carrito
  useEffect(() => {
    if (cart.items.length > 0) {
      getCartServiceFee().then(setServiceFeeData)
    } else {
      setServiceFeeData(null)
    }
  }, [cart.items, getCartServiceFee])

  // Cargar métodos de pago disponibles para los eventos en el carrito
  useEffect(() => {
    if (cart.items.length > 0) {
      loadAvailablePaymentMethods()
    } else {
      setAvailablePaymentMethods([])
    }
  }, [cart.items])

  const loadAvailablePaymentMethods = async () => {
    try {
      const eventIds = [...new Set(cart.items.map(item => item.eventId))]
      const allMethods: any[] = []

      for (const eventId of eventIds) {
        const { getAvailablePaymentMethodsForCart } = useEventPaymentMethods(eventId)
        const methods = getAvailablePaymentMethodsForCart()
        allMethods.push(...methods)
      }

      // Eliminar duplicados
      const uniqueMethods = allMethods.filter((method, index, self) => 
        index === self.findIndex(m => m.id === method.id)
      )

      setAvailablePaymentMethods(uniqueMethods)
    } catch (error) {
      console.error('Error cargando métodos de pago:', error)
      // Métodos por defecto si hay error
      setAvailablePaymentMethods([
        { id: 'pse', name: 'PSE - Pagos Seguros en Línea', description: 'Transferencia bancaria directa', enabled: true },
        { id: 'credit_card', name: 'Tarjetas de Crédito', description: 'Visa, Mastercard, Diners Club', enabled: true },
        { id: 'debit_card', name: 'Tarjetas de Débito', description: 'Visa, Mastercard, Diners Club', enabled: true },
        { id: 'daviplata', name: 'Daviplata', description: 'Billetera digital de Davivienda', enabled: true },
        { id: 'tc_serfinanza', name: 'TC Serfinanza', description: 'Tarjeta de crédito Serfinanza', enabled: true }
      ])
    }
  }

  const handleQuantityChange = (itemId: string, newQuantity: number) => {
    if (newQuantity <= 0) {
      removeFromCart(itemId)
    } else {
      updateCartItem(itemId, { quantity: newQuantity })
    }
  }

  const handleCheckout = () => {
    if (cart.items.length > 0) {
      // FUNCIONALIDAD DE PAGOS DESACTIVADA
      alert('La funcionalidad de pagos está temporalmente desactivada. Por favor, contacta con el organizador del evento para más información.')
      return
      
      // Código original comentado:
      // // Verificar autenticación
      // const token = localStorage.getItem("auth_token")
      // const userStr = localStorage.getItem("current_user")
      // 
      // if (token && userStr) {
      //   // Usuario autenticado, ir al checkout
      //   router.push('/checkout')
      // } else {
      //   // Usuario no autenticado, redirigir al login con redirect
      //   router.push('/login?redirect=/checkout')
      // }
    }
  }

  const handleSelectSeats = () => {
    if (cart.items.length > 0) {
      // Redirigir al primer evento que no tenga asientos seleccionados
      const itemWithoutSeats = cart.items.find(item => !item.selectedSeats || item.selectedSeats.length === 0)
      if (itemWithoutSeats) {
        // Crear un objeto con las boletas seleccionadas para este evento
        const ticketsForEvent = cart.items
          .filter(item => item.eventId === itemWithoutSeats.eventId)
          .reduce((acc, item) => {
            acc[item.ticketTypeId] = item.quantity
            return acc
          }, {} as { [key: string]: number })
        
        const ticketsParam = encodeURIComponent(JSON.stringify(ticketsForEvent))
        router.push(`/evento/${itemWithoutSeats.eventSlug}/asientos?tickets=${ticketsParam}`)
      }
    }
  }

  if (cart.items.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 py-8">
        <div className="container mx-auto px-4">
          <h1 className="text-3xl font-bold text-gray-900 mb-8">Carrito de Compras</h1>
          
          <div className="bg-white rounded-lg shadow p-6">
            <div className="text-center py-12">
              <ShoppingCart className="h-16 w-16 text-gray-400 mx-auto mb-4" />
              <h2 className="text-xl font-semibold text-gray-900 mb-2">Tu carrito está vacío</h2>
              <p className="text-gray-600 mb-6">
                No tienes boletos en tu carrito. ¡Explora nuestros eventos y encuentra algo increíble!
              </p>
              <Link href="/eventos">
                <Button size="lg">
                  Explorar Eventos
                  <ArrowRight className="h-4 w-4 ml-2" />
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="container mx-auto px-4">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Carrito de Compras</h1>
          <Badge variant="secondary" className="text-lg px-4 py-2">
            {cart.items.length} {cart.items.length === 1 ? 'item' : 'items'}
          </Badge>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Lista de items */}
          <div className="lg:col-span-2 space-y-4">
            {cart.items.map((item) => (
              <Card key={item.id}>
                <CardContent className="p-6">
                  <div className="flex items-start justify-between">
                    <div className="flex-1">
                      <div className="flex items-start gap-4">
                        <div className="flex-1">
                          <h3 className="text-lg font-semibold text-gray-900 mb-1">
                            {item.eventTitle}
                          </h3>
                          <p className="text-gray-600 mb-2">{item.ticketTypeName}</p>
                          
                          {item.eventDate && (
                            <div className="flex items-center gap-2 text-sm text-gray-500 mb-1">
                              <Calendar className="h-4 w-4" />
                              <span>{new Date(item.eventDate).toLocaleDateString('es-ES')}</span>
                            </div>
                          )}
                          
                          {item.eventLocation && (
                            <div className="flex items-center gap-2 text-sm text-gray-500 mb-2">
                              <MapPin className="h-4 w-4" />
                              <span>{item.eventLocation}</span>
                            </div>
                          )}

                          {item.selectedSeats && item.selectedSeats.length > 0 && (
                            <div className="mt-2">
                              <p className="text-sm font-medium text-gray-700 mb-1">Asientos seleccionados:</p>
                              <div className="flex flex-wrap gap-1">
                                {item.selectedSeats.map((seat, index) => (
                                  <Badge key={index} variant="outline" className="text-xs">
                                    {seat}
                                  </Badge>
                                ))}
                              </div>
                            </div>
                          )}
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-4">
                      <div className="text-right">
                        <p className="text-lg font-semibold text-gray-900">
                          ${((item.price || 0) * (item.quantity || 1)).toLocaleString()}
                        </p>
                        <p className="text-sm text-gray-500">
                          ${(item.price || 0).toLocaleString()} c/u
                        </p>
                      </div>

                      <div className="flex items-center gap-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleQuantityChange(item.id, item.quantity - 1)}
                        >
                          -
                        </Button>
                        <span className="w-8 text-center font-medium">{item.quantity}</span>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => handleQuantityChange(item.id, item.quantity + 1)}
                        >
                          +
                        </Button>
                      </div>

                      <Button
                        variant="ghost"
                        size="sm"
                        onClick={() => removeFromCart(item.id)}
                        className="text-red-600 hover:text-red-700"
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}

            {/* Botón limpiar carrito */}
            <div className="flex justify-end">
              <Button
                variant="outline"
                onClick={clearCart}
                className="text-red-600 hover:text-red-700"
              >
                <Trash2 className="h-4 w-4 mr-2" />
                Limpiar Carrito
              </Button>
            </div>
          </div>

          {/* Resumen del pedido */}
          <div className="lg:col-span-1">
            <Card className="sticky top-6">
              <CardHeader>
                <CardTitle>Resumen del Pedido</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Subtotal */}
                <div className="flex justify-between text-sm">
                  <span>Subtotal:</span>
                  <span>${(cart.total || 0).toLocaleString()}</span>
                </div>

                {/* Servicio */}
                <div className="flex justify-between text-sm">
                  <span>Servicio:</span>
                  <span>
                    {isServiceFeeLoading ? (
                      <span className="text-gray-400">Calculando...</span>
                    ) : (
                      `$${Math.round(serviceFeeData?.total || 0).toLocaleString()}`
                    )}
                  </span>
                </div>

                {/* Desglose de tarifas de servicio por evento */}
                {serviceFeeData && serviceFeeData.breakdown.length > 1 && (
                  <div className="text-xs text-gray-500 space-y-1">
                    {serviceFeeData.breakdown.map((item, index) => (
                      <div key={index} className="flex justify-between">
                        <span>{item.eventTitle}:</span>
                        <span>${Math.round(item.serviceFee).toLocaleString()}</span>
                      </div>
                    ))}
                  </div>
                )}

                <Separator />

                {/* Total */}
                <div className="flex justify-between text-lg font-bold">
                  <span>Total:</span>
                  <span className="text-green-600">
                    ${((cart.total || 0) + Math.round(serviceFeeData?.total || 0)).toLocaleString()}
                  </span>
                </div>

                {/* Métodos de Pago Disponibles */}
                {availablePaymentMethods.length > 0 && (
                  <div className="space-y-3">
                    <h4 className="text-sm font-semibold text-gray-700">Métodos de Pago Disponibles</h4>
                    <div className="grid grid-cols-2 gap-2">
                      {availablePaymentMethods.map((method) => (
                        <div key={method.id} className="flex items-center space-x-2 p-2 bg-gray-50 rounded-lg">
                          <div className={`w-3 h-3 rounded-full ${
                            method.id === 'pse' ? 'bg-blue-500' :
                            method.id === 'credit_card' ? 'bg-green-500' :
                            method.id === 'debit_card' ? 'bg-orange-500' :
                            method.id === 'daviplata' ? 'bg-purple-500' :
                            method.id === 'tc_serfinanza' ? 'bg-red-500' : 'bg-gray-500'
                          }`}></div>
                          <span className="text-xs text-gray-600">{method.name}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                {/* Botones de acción */}
                <div className="space-y-3">
                  {cart.items.some(item => !item.selectedSeats || item.selectedSeats.length === 0) && (
                    <Button 
                      variant="outline"
                      className="w-full"
                      onClick={handleSelectSeats}
                    >
                      Seleccionar Asientos
                    </Button>
                  )}
                  
                  <Button 
                    className="w-full" 
                    size="lg"
                    onClick={handleCheckout}
                    variant="outline"
                    disabled
                  >
                    Pagos Temporalmente Desactivados
                    <ArrowRight className="h-4 w-4 ml-2" />
                  </Button>
                </div>

                <p className="text-xs text-gray-500 text-center">
                  Al proceder, aceptas nuestros términos y condiciones
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}

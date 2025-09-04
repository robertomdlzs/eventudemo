"use client"

import { useCart } from "@/hooks/use-cart"
import { useAuth } from "@/hooks/use-auth"
import { trackBeginCheckout, trackPurchase } from "@/lib/analytics"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Separator } from "@/components/ui/separator"
import { ArrowLeft, CreditCard, Check, MapPin, Calendar, Clock, User, Mail, Phone, Shield, Lock, Info } from "lucide-react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { useState, useEffect } from "react"
import { PaymentMethods } from "@/components/payment/payment-methods"
import { PaymentLogos } from "@/components/payment/payment-logos"
import { apiClient } from "@/lib/api-client"

export default function CheckoutPage() {
  const { cart, clearCart } = useCart()
  const { isAuthenticated, user, isLoading } = useAuth()
  const router = useRouter()
  const [loading, setLoading] = useState(false)
  
  // Estado para información personal
  const [personalData, setPersonalData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    phone: ''
  })

  // Estado para método de pago
  const [selectedPaymentMethod, setSelectedPaymentMethod] = useState('credit_card')
  
  // Estado para datos de tarjeta
  const [cardData, setCardData] = useState({
    number: '',
    expiry: '',
    cvv: '',
    holderName: ''
  })

  // Estado para datos bancarios (PSE)
  const [bankData, setBankData] = useState({
    bank: '',
    accountType: '',
    documentType: '',
    documentNumber: ''
  })

  // Estado para datos de Daviplata
  const [phoneData, setPhoneData] = useState({
    phone: ''
  })

  useEffect(() => {
    if (user) {
      setPersonalData({
        firstName: user.first_name || user.name || '',
        lastName: user.last_name || '',
        email: user.email || '',
        phone: user.phone || ''
      })
    }
  }, [user])

  // Si no hay items en el carrito, redirigir
  useEffect(() => {
    if (cart.items.length === 0) {
      router.push('/carrito')
    } else {
      // Track begin checkout
      trackBeginCheckout(cart.total)
    }
  }, [cart.items.length, router])

  // Si no está autenticado y no está cargando, redirigir al login
  useEffect(() => {
    if (!isLoading && !isAuthenticated && cart.items.length > 0) {
      router.push('/login?redirect=/checkout')
    }
  }, [isAuthenticated, isLoading, cart.items.length, router])

  const handlePersonalDataChange = (field: string, value: string) => {
    setPersonalData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleCardDataChange = (field: string, value: string) => {
    setCardData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleBankDataChange = (field: string, value: string) => {
    setBankData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handlePhoneDataChange = (field: string, value: string) => {
    setPhoneData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)

    try {
      // Verificar disponibilidad de boletos antes de procesar el pago
      for (const item of cart.items) {
        const availabilityResponse = await apiClient.checkTicketAvailability({
          eventId: item.eventId,
          ticketTypeId: item.ticketTypeId,
          quantity: item.quantity
        })

        if (!availabilityResponse.success) {
          throw new Error(availabilityResponse.message || 'Error al verificar disponibilidad')
        }

        if (!availabilityResponse.data.isAvailable) {
          throw new Error(`No hay suficientes boletos disponibles para ${item.eventTitle}. ${availabilityResponse.data.message}`)
        }
      }

      // Validar datos según el método de pago seleccionado
      if (selectedPaymentMethod === 'credit_card' || selectedPaymentMethod === 'debit_card' || selectedPaymentMethod === 'tc_serfinanza') {
        if (!cardData.number || !cardData.expiry || !cardData.cvv || !cardData.holderName) {
          throw new Error('Por favor completa toda la información de la tarjeta')
        }
      } else if (selectedPaymentMethod === 'pse') {
        if (!bankData.bank || !bankData.accountType || !bankData.documentType || !bankData.documentNumber) {
          throw new Error('Por favor completa toda la información bancaria')
        }
      } else if (selectedPaymentMethod === 'daviplata') {
        if (!phoneData.phone) {
          throw new Error('Por favor ingresa tu número de teléfono de Daviplata')
        }
      }

      // Procesar pago según el método seleccionado
      let paymentResponse

      if (selectedPaymentMethod === 'credit_card' || selectedPaymentMethod === 'debit_card' || selectedPaymentMethod === 'tc_serfinanza') {
        // Procesar pago con tarjeta
        const cardPaymentData = {
          cardNumber: cardData.number.replace(/\s/g, ''),
          expiryDate: cardData.expiry,
          cvv: cardData.cvv,
          holderName: cardData.holderName,
          amount: calculateTotal(),
          currency: 'COP',
          description: `Compra de boletas - ${cart.items.map(item => item.eventTitle).join(', ')}`,
          customerId: user?.id || 0,
          eventId: cart.items[0]?.eventId || 0,
          ticketTypeId: cart.items[0]?.ticketTypeId || 0,
          quantity: cart.items.reduce((total, item) => total + item.quantity, 0)
        }

        paymentResponse = await apiClient.processCardPayment(cardPaymentData)
      } else if (selectedPaymentMethod === 'pse') {
        // Procesar pago PSE
        const psePaymentData = {
          bank: bankData.bank,
          accountType: bankData.accountType,
          documentType: bankData.documentType,
          documentNumber: bankData.documentNumber,
          amount: calculateTotal(),
          currency: 'COP',
          description: `Compra de boletas - ${cart.items.map(item => item.eventTitle).join(', ')}`,
          customerId: user?.id || 0,
          eventId: cart.items[0]?.eventId || 0,
          ticketTypeId: cart.items[0]?.ticketTypeId || 0,
          quantity: cart.items.reduce((total, item) => total + item.quantity, 0)
        }

        paymentResponse = await apiClient.processPSEPayment(psePaymentData)
      } else if (selectedPaymentMethod === 'daviplata') {
        // Procesar pago Daviplata
        const daviplataPaymentData = {
          phone: phoneData.phone,
          amount: calculateTotal(),
          currency: 'COP',
          description: `Compra de boletas - ${cart.items.map(item => item.eventTitle).join(', ')}`,
          customerId: user?.id || 0,
          eventId: cart.items[0]?.eventId || 0,
          ticketTypeId: cart.items[0]?.ticketTypeId || 0,
          quantity: cart.items.reduce((total, item) => total + item.quantity, 0)
        }

        paymentResponse = await apiClient.processDaviplataPayment(daviplataPaymentData)
      }

      if (!paymentResponse?.success) {
        throw new Error(paymentResponse?.message || 'Error al procesar el pago')
      }

      // Track successful purchase
      const transactionId = paymentResponse.data?.transactionId || `TXN-${Date.now()}`
      const items = cart.items.map(item => ({
        item_id: item.eventId.toString(),
        item_name: item.eventTitle || 'Evento',
        price: item.price,
        quantity: item.quantity
      }))
      
      trackPurchase(transactionId, cart.total, 'COP', items)
      
      // Limpiar carrito después del pago exitoso
      clearCart()
      
      // Redirigir a página de éxito
      router.push('/checkout/success')
    } catch (error) {
      console.error('Error processing payment:', error)
      alert(error instanceof Error ? error.message : 'Error al procesar el pago')
    } finally {
      setLoading(false)
    }
  }

  // Calcular total
  const calculateTotal = () => {
    return cart.total + Math.round(cart.total * 0.05) // 5% de servicio
  }

  if (cart.items.length === 0) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Carrito vacío</h1>
          <p className="text-gray-600 mb-4">No hay items en tu carrito para procesar.</p>
          <Link href="/carrito">
            <Button>Volver al Carrito</Button>
          </Link>
        </div>
      </div>
    )
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Cargando...</h1>
          <p className="text-gray-600 mb-4">Verificando autenticación...</p>
        </div>
      </div>
    )
  }

  if (!isAuthenticated) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold mb-4">Inicia sesión para continuar</h1>
          <p className="text-gray-600 mb-4">Necesitas estar logueado para proceder con el pago.</p>
          <div className="space-x-4">
            <Link href="/login?redirect=/checkout">
              <Button>Iniciar Sesión</Button>
            </Link>
            <Link href="/registro?redirect=/checkout">
              <Button variant="outline">Registrarse</Button>
            </Link>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white shadow-sm border-b">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center gap-4">
            <Link href="/carrito">
              <Button variant="ghost" size="sm">
                <ArrowLeft className="h-4 w-4 mr-2" />
                Volver al Carrito
              </Button>
            </Link>
            <div>
              <h1 className="text-xl font-semibold">Finalizar Compra</h1>
              <p className="text-sm text-gray-500">Completa tu información de pago</p>
            </div>
          </div>
        </div>
      </div>

      <div className="max-w-6xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Formulario de pago */}
          <div className="lg:col-span-2 space-y-6">
            {/* Información personal */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <User className="h-5 w-5" />
                  Información Personal
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div>
                    <Label htmlFor="firstName">Nombre</Label>
                    <Input
                      id="firstName"
                      value={personalData.firstName}
                      onChange={(e) => handlePersonalDataChange("firstName", e.target.value)}
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="lastName">Apellido</Label>
                    <Input
                      id="lastName"
                      value={personalData.lastName}
                      onChange={(e) => handlePersonalDataChange("lastName", e.target.value)}
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="email">Email</Label>
                    <Input
                      id="email"
                      type="email"
                      value={personalData.email}
                      onChange={(e) => handlePersonalDataChange("email", e.target.value)}
                      required
                    />
                  </div>
                  <div>
                    <Label htmlFor="phone">Teléfono</Label>
                    <Input
                      id="phone"
                      value={personalData.phone}
                      onChange={(e) => handlePersonalDataChange("phone", e.target.value)}
                      required
                    />
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Métodos de pago */}
            <Card>
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CreditCard className="h-5 w-5" />
                  Método de Pago
                </CardTitle>
              </CardHeader>
              <CardContent>
                <PaymentMethods
                  selectedMethod={selectedPaymentMethod}
                  onMethodChange={setSelectedPaymentMethod}
                  cardData={cardData}
                  onCardDataChange={handleCardDataChange}
                  bankData={bankData}
                  onBankDataChange={handleBankDataChange}
                  phoneData={phoneData}
                  onPhoneDataChange={handlePhoneDataChange}
                />
              </CardContent>
            </Card>

            {/* Botón de confirmación */}
            <Card>
              <CardContent className="pt-6">
                <Button 
                  onClick={handleSubmit}
                  className="w-full" 
                  size="lg"
                  disabled={loading}
                >
                  {loading ? (
                    <div className="flex items-center gap-2">
                      <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                      Procesando...
                    </div>
                  ) : (
                    <div className="flex items-center gap-2">
                      <Lock className="h-4 w-4" />
                      Confirmar Pago Seguro
                    </div>
                  )}
                </Button>
                
                {/* Información de seguridad */}
                <div className="mt-4 flex items-center justify-center gap-2 text-sm text-gray-600">
                  <Shield className="h-4 w-4" />
                  <span>Pago procesado de forma segura con encriptación SSL</span>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Resumen del pedido */}
          <div className="lg:col-span-1 space-y-6">
            <Card className="sticky top-6">
              <CardHeader>
                <CardTitle>Resumen del Pedido</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Items del carrito */}
                <div className="space-y-3">
                  {cart.items.map((item) => (
                    <div key={item.id} className="flex justify-between items-start text-sm">
                      <div className="flex-1">
                        <p className="font-medium">{item.eventTitle}</p>
                        <p className="text-gray-500">{item.ticketTypeName}</p>
                        <p className="text-gray-500">{item.quantity} x ${item.price.toLocaleString()}</p>
                        {item.selectedSeats && item.selectedSeats.length > 0 && (
                          <div className="mt-1">
                            <p className="text-xs text-gray-500">Asientos: {item.selectedSeats.join(', ')}</p>
                          </div>
                        )}
                      </div>
                      <p className="font-semibold">
                        ${(item.price * item.quantity).toLocaleString()}
                      </p>
                    </div>
                  ))}
                </div>

                <Separator />

                {/* Totales */}
                <div className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span>Subtotal:</span>
                    <span>${cart.total.toLocaleString()}</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span>Servicio (5%):</span>
                    <span>${Math.round(cart.total * 0.05).toLocaleString()}</span>
                  </div>
                  <Separator />
                  <div className="flex justify-between text-lg font-bold">
                    <span>Total:</span>
                    <span className="text-green-600">${calculateTotal().toLocaleString()}</span>
                  </div>
                </div>

                {/* Información adicional */}
                <div className="mt-4 p-3 bg-blue-50 rounded-lg">
                  <div className="flex items-start gap-2">
                    <Info className="h-4 w-4 text-blue-600 mt-0.5" />
                    <div className="text-xs text-blue-800">
                      <p className="font-medium mb-1">Información importante:</p>
                      <ul className="space-y-1">
                        <li>• Tus datos se utilizan para procesar tu pedido</li>
                        <li>• Mejoramos tu experiencia en esta web</li>
                        <li>• Otros propósitos en nuestra política de privacidad</li>
                      </ul>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Logos de métodos de pago */}
            <PaymentLogos />
          </div>
        </div>
      </div>
    </div>
  )
}

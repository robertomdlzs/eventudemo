"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Separator } from "@/components/ui/separator"
import { 
  ShoppingCart, 
  Calendar, 
  MapPin, 
  Clock, 
  Download, 
  Eye,
  CreditCard,
  Receipt
} from "lucide-react"
import { useRouter } from "next/navigation"

interface Purchase {
  id: string
  orderNumber: string
  eventName: string
  eventDate: string
  venue: string
  ticketType: string
  quantity: number
  unitPrice: number
  totalAmount: number
  paymentMethod: string
  status: string
  purchaseDate: string
  transactionId: string
}

export default function HistorialComprasPage() {
  const [purchases, setPurchases] = useState<Purchase[]>([])
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const checkAuth = () => {
      const token = localStorage.getItem("auth_token")
      if (!token) {
        router.push("/login")
        return
      }
      
      // Simular datos de compras (en producción esto vendría de la API)
      const mockPurchases: Purchase[] = [
        {
          id: "1",
          orderNumber: "ORD-2024-001",
          eventName: "Concierto Rock Nacional",
          eventDate: "2024-12-15",
          venue: "Estadio El Campín",
          ticketType: "General",
          quantity: 2,
          unitPrice: 50000,
          totalAmount: 100000,
          paymentMethod: "Tarjeta de Crédito",
          status: "completed",
          purchaseDate: "2024-11-20",
          transactionId: "TXN-001-2024"
        },
        {
          id: "2",
          orderNumber: "ORD-2024-002",
          eventName: "Festival Gastronómico",
          eventDate: "2024-12-20",
          venue: "Centro Comercial Andino",
          ticketType: "VIP",
          quantity: 1,
          unitPrice: 120000,
          totalAmount: 120000,
          paymentMethod: "Transferencia Bancaria",
          status: "completed",
          purchaseDate: "2024-11-25",
          transactionId: "TXN-002-2024"
        },
        {
          id: "3",
          orderNumber: "ORD-2024-003",
          eventName: "Teatro: Romeo y Julieta",
          eventDate: "2024-11-30",
          venue: "Teatro Colón",
          ticketType: "Platea",
          quantity: 3,
          unitPrice: 80000,
          totalAmount: 240000,
          paymentMethod: "Tarjeta de Débito",
          status: "completed",
          purchaseDate: "2024-11-10",
          transactionId: "TXN-003-2024"
        },
        {
          id: "4",
          orderNumber: "ORD-2024-004",
          eventName: "Tech Summit 2024",
          eventDate: "2025-01-15",
          venue: "Centro de Convenciones",
          ticketType: "Early Bird",
          quantity: 1,
          unitPrice: 150000,
          totalAmount: 150000,
          paymentMethod: "PSE",
          status: "pending",
          purchaseDate: "2024-12-01",
          transactionId: "TXN-004-2024"
        }
      ]
      
      setPurchases(mockPurchases)
      setLoading(false)
    }

    checkAuth()
  }, [router])

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "completed":
        return <Badge className="bg-green-100 text-green-800">Completada</Badge>
      case "pending":
        return <Badge className="bg-yellow-100 text-yellow-800">Pendiente</Badge>
      case "cancelled":
        return <Badge className="bg-red-100 text-red-800">Cancelada</Badge>
      case "refunded":
        return <Badge className="bg-blue-100 text-blue-800">Reembolsada</Badge>
      default:
        return <Badge variant="secondary">{status}</Badge>
    }
  }

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP'
    }).format(price)
  }

  const formatDate = (date: string) => {
    return new Date(date).toLocaleDateString('es-ES', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  }

  const getPaymentMethodIcon = (method: string) => {
    switch (method.toLowerCase()) {
      case 'tarjeta de crédito':
      case 'tarjeta de débito':
        return <CreditCard className="h-4 w-4" />
      case 'transferencia bancaria':
        return <Receipt className="h-4 w-4" />
      case 'pse':
        return <Receipt className="h-4 w-4" />
      default:
        return <ShoppingCart className="h-4 w-4" />
    }
  }

  if (loading) {
    return (
      <div className="container mx-auto px-4 py-8">
        <div className="animate-pulse">
          <div className="h-8 bg-gray-200 rounded w-1/4 mb-4"></div>
          <div className="space-y-4">
            {[1, 2, 3].map((i) => (
              <div key={i} className="h-32 bg-gray-200 rounded"></div>
            ))}
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Historial de Compras</h1>
        <p className="text-gray-600">Revisa todas tus transacciones y compras realizadas</p>
      </div>

      {purchases.length === 0 ? (
        <Card>
          <CardContent className="text-center py-12">
            <ShoppingCart className="h-12 w-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No hay compras</h3>
            <p className="text-gray-600 mb-6">Aún no has realizado ninguna compra.</p>
            <Button onClick={() => router.push("/eventos")}>
              Explorar Eventos
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-6">
          {purchases.map((purchase) => (
            <Card key={purchase.id} className="hover:shadow-md transition-shadow">
              <CardHeader>
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle className="text-xl">{purchase.eventName}</CardTitle>
                    <CardDescription className="flex items-center gap-4 mt-2">
                      <span className="flex items-center gap-1">
                        <Calendar className="h-4 w-4" />
                        {formatDate(purchase.eventDate)}
                      </span>
                      <span className="flex items-center gap-1">
                        <MapPin className="h-4 w-4" />
                        {purchase.venue}
                      </span>
                    </CardDescription>
                  </div>
                  <div className="flex items-center gap-2">
                    {getStatusBadge(purchase.status)}
                    <Badge variant="outline">{purchase.ticketType}</Badge>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500">Número de Orden</p>
                    <p className="text-sm text-gray-900 font-mono">{purchase.orderNumber}</p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Cantidad</p>
                    <p className="text-sm text-gray-900">{purchase.quantity} boletos</p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Precio Unitario</p>
                    <p className="text-sm text-gray-900">{formatPrice(purchase.unitPrice)}</p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Total</p>
                    <p className="text-sm text-gray-900 font-semibold">{formatPrice(purchase.totalAmount)}</p>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500">Método de Pago</p>
                    <div className="flex items-center gap-2 mt-1">
                      {getPaymentMethodIcon(purchase.paymentMethod)}
                      <span className="text-sm text-gray-900">{purchase.paymentMethod}</span>
                    </div>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Fecha de Compra</p>
                    <p className="text-sm text-gray-900">{formatDate(purchase.purchaseDate)}</p>
                  </div>
                </div>

                <div className="mb-4 p-3 bg-gray-50 rounded-lg">
                  <p className="text-sm text-gray-600">
                    <span className="font-medium">ID de Transacción:</span> {purchase.transactionId}
                  </p>
                </div>

                <Separator className="my-4" />

                <div className="flex flex-wrap gap-2">
                  <Button variant="outline" size="sm">
                    <Eye className="h-4 w-4 mr-2" />
                    Ver Detalles
                  </Button>
                  <Button variant="outline" size="sm">
                    <Download className="h-4 w-4 mr-2" />
                    Descargar Factura
                  </Button>
                  {purchase.status === "completed" && (
                    <Button variant="outline" size="sm">
                      <Receipt className="h-4 w-4 mr-2" />
                      Ver Boletos
                    </Button>
                  )}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* Estadísticas */}
      <Card className="mt-8">
        <CardHeader>
          <CardTitle>Resumen de Compras</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div className="text-center">
              <p className="text-2xl font-bold text-gray-900">{purchases.length}</p>
              <p className="text-sm text-gray-600">Total de Compras</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-green-600">
                {purchases.filter(p => p.status === "completed").length}
              </p>
              <p className="text-sm text-gray-600">Completadas</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-yellow-600">
                {purchases.filter(p => p.status === "pending").length}
              </p>
              <p className="text-sm text-gray-600">Pendientes</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-blue-600">
                {purchases.reduce((sum, p) => sum + p.quantity, 0)}
              </p>
              <p className="text-sm text-gray-600">Total Boletos</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-purple-600">
                {formatPrice(purchases.reduce((sum, p) => sum + p.totalAmount, 0))}
              </p>
              <p className="text-sm text-gray-600">Total Gastado</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

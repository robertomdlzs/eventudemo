"use client"

import { useEffect, useState } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Separator } from "@/components/ui/separator"
import { 
  FileText, 
  Calendar, 
  MapPin, 
  Clock, 
  Download, 
  QrCode,
  Eye,
  Mail
} from "lucide-react"
import { useRouter } from "next/navigation"

interface Ticket {
  id: string
  ticketNumber: string
  eventName: string
  eventDate: string
  eventTime: string
  venue: string
  ticketType: string
  price: number
  status: string
  purchaseDate: string
  qrCode: string
  usedAt?: string
}

export default function MisBoletosPage() {
  const [tickets, setTickets] = useState<Ticket[]>([])
  const [loading, setLoading] = useState(true)
  const router = useRouter()

  useEffect(() => {
    const checkAuth = () => {
      const token = localStorage.getItem("auth_token")
      if (!token) {
        router.push("/login")
        return
      }
      
      // Simular datos de boletos (en producción esto vendría de la API)
      const mockTickets: Ticket[] = [
        {
          id: "1",
          ticketNumber: "TKT-2024-001",
          eventName: "Concierto Rock Nacional",
          eventDate: "2024-12-15",
          eventTime: "20:00",
          venue: "Estadio El Campín",
          ticketType: "General",
          price: 50000,
          status: "active",
          purchaseDate: "2024-11-20",
          qrCode: "qr-code-1"
        },
        {
          id: "2",
          ticketNumber: "TKT-2024-002",
          eventName: "Festival Gastronómico",
          eventDate: "2024-12-20",
          eventTime: "18:00",
          venue: "Centro Comercial Andino",
          ticketType: "VIP",
          price: 120000,
          status: "active",
          purchaseDate: "2024-11-25",
          qrCode: "qr-code-2"
        },
        {
          id: "3",
          ticketNumber: "TKT-2024-003",
          eventName: "Teatro: Romeo y Julieta",
          eventDate: "2024-11-30",
          eventTime: "19:30",
          venue: "Teatro Colón",
          ticketType: "Platea",
          price: 80000,
          status: "used",
          purchaseDate: "2024-11-10",
          qrCode: "qr-code-3",
          usedAt: "2024-11-30 19:30"
        }
      ]
      
      setTickets(mockTickets)
      setLoading(false)
    }

    checkAuth()
  }, [router])

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "active":
        return <Badge className="bg-green-100 text-green-800">Activo</Badge>
      case "used":
        return <Badge className="bg-gray-100 text-gray-800">Usado</Badge>
      case "cancelled":
        return <Badge className="bg-red-100 text-red-800">Cancelado</Badge>
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
        <h1 className="text-3xl font-bold text-gray-900 mb-2">Mis Boletos</h1>
        <p className="text-gray-600">Gestiona y visualiza todos tus boletos comprados</p>
      </div>

      {tickets.length === 0 ? (
        <Card>
          <CardContent className="text-center py-12">
            <FileText className="h-12 w-12 text-gray-400 mx-auto mb-4" />
            <h3 className="text-lg font-medium text-gray-900 mb-2">No tienes boletos</h3>
            <p className="text-gray-600 mb-6">Aún no has comprado ningún boleto para eventos.</p>
            <Button onClick={() => router.push("/eventos")}>
              Explorar Eventos
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-6">
          {tickets.map((ticket) => (
            <Card key={ticket.id} className="hover:shadow-md transition-shadow">
              <CardHeader>
                <div className="flex justify-between items-start">
                  <div>
                    <CardTitle className="text-xl">{ticket.eventName}</CardTitle>
                    <CardDescription className="flex items-center gap-4 mt-2">
                      <span className="flex items-center gap-1">
                        <Calendar className="h-4 w-4" />
                        {formatDate(ticket.eventDate)} - {ticket.eventTime}
                      </span>
                      <span className="flex items-center gap-1">
                        <MapPin className="h-4 w-4" />
                        {ticket.venue}
                      </span>
                    </CardDescription>
                  </div>
                  <div className="flex items-center gap-2">
                    {getStatusBadge(ticket.status)}
                    <Badge variant="outline">{ticket.ticketType}</Badge>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
                  <div>
                    <p className="text-sm font-medium text-gray-500">Número de Boleto</p>
                    <p className="text-sm text-gray-900 font-mono">{ticket.ticketNumber}</p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Precio</p>
                    <p className="text-sm text-gray-900 font-semibold">{formatPrice(ticket.price)}</p>
                  </div>
                  <div>
                    <p className="text-sm font-medium text-gray-500">Fecha de Compra</p>
                    <p className="text-sm text-gray-900">{formatDate(ticket.purchaseDate)}</p>
                  </div>
                </div>

                {ticket.usedAt && (
                  <div className="mb-4 p-3 bg-gray-50 rounded-lg">
                    <p className="text-sm text-gray-600 flex items-center gap-2">
                      <Clock className="h-4 w-4" />
                      Usado el {formatDate(ticket.usedAt)}
                    </p>
                  </div>
                )}

                <Separator className="my-4" />

                <div className="flex flex-wrap gap-2">
                  <Button variant="outline" size="sm">
                    <Eye className="h-4 w-4 mr-2" />
                    Ver Detalles
                  </Button>
                  <Button variant="outline" size="sm">
                    <QrCode className="h-4 w-4 mr-2" />
                    Ver QR
                  </Button>
                  <Button variant="outline" size="sm">
                    <Download className="h-4 w-4 mr-2" />
                    Descargar
                  </Button>
                  <Button variant="outline" size="sm">
                    <Mail className="h-4 w-4 mr-2" />
                    Reenviar
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      {/* Estadísticas */}
      <Card className="mt-8">
        <CardHeader>
          <CardTitle>Resumen de Boletos</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div className="text-center">
              <p className="text-2xl font-bold text-gray-900">{tickets.length}</p>
              <p className="text-sm text-gray-600">Total de Boletos</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-green-600">
                {tickets.filter(t => t.status === "active").length}
              </p>
              <p className="text-sm text-gray-600">Activos</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-gray-600">
                {tickets.filter(t => t.status === "used").length}
              </p>
              <p className="text-sm text-gray-600">Usados</p>
            </div>
            <div className="text-center">
              <p className="text-2xl font-bold text-blue-600">
                {formatPrice(tickets.reduce((sum, t) => sum + t.price, 0))}
              </p>
              <p className="text-sm text-gray-600">Total Invertido</p>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

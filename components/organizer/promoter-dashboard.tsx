"use client"

import { useState, useEffect } from "react"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import { Badge } from "@/components/ui/badge"
import { 
  TrendingUp, 
  TrendingDown, 
  Users, 
  Ticket, 
  DollarSign, 
  Calendar,
  BarChart3,
  Activity,
  RefreshCw,
  Target,
  Percent
} from "lucide-react"
import { apiClient } from "@/lib/api-client"

interface PromoterDashboardData {
  totalRevenue: number
  totalTicketsSold: number
  totalEvents: number
  uniqueCustomers: number
  averageOrderValue: number
  occupancyRate: number
  monthlyGoal: number
  progressToGoal: number
  salesTrend: Array<{
    date: string
    revenue: number
    tickets: number
  }>
  ticketTypeBreakdown: Array<{
    type: string
    sold: number
    revenue: number
    percentage: number
  }>
  recentActivity: Array<{
    type: string
    description: string
    amount: number
    timestamp: string
  }>
}

export function PromoterDashboard() {
  const [data, setData] = useState<PromoterDashboardData | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchDashboardData = async () => {
    try {
      setLoading(true)
      setError(null)

      // Obtener datos del dashboard
      const dashboardResponse = await apiClient.getOrganizerDashboard()
      const eventsResponse = await apiClient.getOrganizerEvents()

      if (dashboardResponse.success && eventsResponse.success) {
        const stats = dashboardResponse.data.stats
        const events = eventsResponse.data || []

        // Calcular métricas adicionales
        const monthlyGoal = 1000000 // Meta mensual de $1M
        const progressToGoal = (stats.totalRevenue / monthlyGoal) * 100

        // Generar datos de tendencia (últimos 7 días)
        const salesTrend = generateSalesTrend(stats.totalRevenue)

        // Generar desglose por tipo de ticket
        const ticketTypeBreakdown = generateTicketTypeBreakdown(events)

        // Generar actividad reciente
        const recentActivity = generateRecentActivity(events)

        const dashboardData: PromoterDashboardData = {
          totalRevenue: stats.totalRevenue || 0,
          totalTicketsSold: stats.totalTicketsSold || 0,
          totalEvents: stats.totalEvents || 0,
          uniqueCustomers: stats.uniqueCustomers || 0,
          averageOrderValue: stats.averageOrderValue || 0,
          occupancyRate: events.length > 0 ? (stats.totalTicketsSold / (events[0]?.totalCapacity || 1)) * 100 : 0,
          monthlyGoal,
          progressToGoal,
          salesTrend,
          ticketTypeBreakdown,
          recentActivity
        }

        setData(dashboardData)
      } else {
        setError("Error al cargar datos del dashboard")
      }
    } catch (err) {
      setError("Error de conexión")
      console.error("Error fetching dashboard data:", err)
    } finally {
      setLoading(false)
    }
  }

  const generateSalesTrend = (totalRevenue: number) => {
    const days = 7
    const trend = []
    const baseAmount = totalRevenue / days

    for (let i = days - 1; i >= 0; i--) {
      const date = new Date()
      date.setDate(date.getDate() - i)
      
      // Simular variación en las ventas
      const variation = 0.8 + Math.random() * 0.4 // 80% a 120% del promedio
      const revenue = Math.round(baseAmount * variation)
      const tickets = Math.round((revenue / 110000) * (0.8 + Math.random() * 0.4))

      trend.push({
        date: date.toISOString().split('T')[0],
        revenue,
        tickets
      })
    }

    return trend
  }

  const generateTicketTypeBreakdown = (events: any[]) => {
    if (events.length === 0) return []

    const event = events[0] // Tomar el primer evento
    const totalSold = event.ticketsSold || 0
    const totalRevenue = event.revenue || 0

    return [
      {
        type: "Early Bird",
        sold: Math.round(totalSold * 0.4),
        revenue: Math.round(totalRevenue * 0.4),
        percentage: 40
      },
      {
        type: "Entrada Regular",
        sold: Math.round(totalSold * 0.5),
        revenue: Math.round(totalRevenue * 0.5),
        percentage: 50
      },
      {
        type: "Platea",
        sold: Math.round(totalSold * 0.1),
        revenue: Math.round(totalRevenue * 0.1),
        percentage: 10
      }
    ]
  }

  const generateRecentActivity = (events: any[]) => {
    const activities = []
    const event = events[0]

    if (event) {
      activities.push(
        {
          type: "sale",
          description: `Nueva venta en ${event.title}`,
          amount: event.revenue / 4,
          timestamp: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString() // 2 horas atrás
        },
        {
          type: "ticket",
          description: `${event.ticketsSold} tickets vendidos`,
          amount: event.ticketsSold * 110000,
          timestamp: new Date(Date.now() - 4 * 60 * 60 * 1000).toISOString() // 4 horas atrás
        },
        {
          type: "customer",
          description: "Nuevo cliente registrado",
          amount: 0,
          timestamp: new Date(Date.now() - 6 * 60 * 60 * 1000).toISOString() // 6 horas atrás
        }
      )
    }

    return activities
  }

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0
    }).format(amount)
  }

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('es-CO', {
      month: 'short',
      day: 'numeric'
    })
  }

  useEffect(() => {
    fetchDashboardData()
  }, [])

  if (loading) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold">Dashboard del Promotor</h1>
            <p className="text-muted-foreground">Monitoreando el rendimiento de tus eventos</p>
          </div>
        </div>
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <Card key={i}>
              <CardHeader className="space-y-0 pb-2">
                <div className="h-4 bg-gray-200 rounded animate-pulse"></div>
              </CardHeader>
              <CardContent>
                <div className="h-8 bg-gray-200 rounded animate-pulse mb-2"></div>
                <div className="h-3 bg-gray-200 rounded animate-pulse"></div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold">Dashboard del Promotor</h1>
            <p className="text-muted-foreground">Monitoreando el rendimiento de tus eventos</p>
          </div>
          <Button onClick={fetchDashboardData} variant="outline">
            <RefreshCw className="h-4 w-4 mr-2" />
            Reintentar
          </Button>
        </div>
        <Card>
          <CardContent className="flex items-center justify-center h-32">
            <div className="text-center">
              <p className="text-red-500 mb-2">{error}</p>
              <Button onClick={fetchDashboardData} variant="outline">
                Reintentar
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    )
  }

  if (!data) return null

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold">Dashboard del Promotor</h1>
          <p className="text-muted-foreground">Monitoreando el rendimiento de tus eventos</p>
        </div>
        <Button onClick={fetchDashboardData} variant="outline">
          <RefreshCw className="h-4 w-4 mr-2" />
          Actualizar
        </Button>
      </div>

      {/* Métricas principales */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">INGRESOS ESTE MES</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{formatCurrency(data.totalRevenue)}</div>
            <p className="text-xs text-muted-foreground">
              Vendido hasta la fecha vs {formatCurrency(data.monthlyGoal)} meta
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">PROGRESO HACIA META</CardTitle>
            <Target className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{Math.round(data.progressToGoal)}%</div>
            <p className="text-xs text-muted-foreground">Porcentaje del Valor de la Meta</p>
            <Progress value={data.progressToGoal} className="mt-2" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">BOLETOS VENDIDOS</CardTitle>
            <Ticket className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{data.totalTicketsSold}</div>
            <p className="text-xs text-muted-foreground">Número de Boletos</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">TASA DE OCUPACIÓN</CardTitle>
            <Percent className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{Math.round(data.occupancyRate)}%</div>
            <p className="text-xs text-muted-foreground">Porcentaje de Ocupación</p>
            <Progress value={data.occupancyRate} className="mt-2" />
          </CardContent>
        </Card>
      </div>

      {/* Gráficos y análisis */}
      <div className="grid gap-4 md:grid-cols-2">
        {/* Tendencias de ventas */}
        <Card>
          <CardHeader>
            <CardTitle>TENDENCIA DE VENTAS V. META</CardTitle>
            <CardDescription>Evolución de ventas en los últimos 7 días</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {data.salesTrend.map((day, index) => (
                <div key={day.date} className="flex items-center justify-between">
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                    <span className="text-sm">{formatDate(day.date)}</span>
                  </div>
                  <div className="text-right">
                    <div className="text-sm font-medium">{formatCurrency(day.revenue)}</div>
                    <div className="text-xs text-muted-foreground">{day.tickets} tickets</div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Desglose por tipo de ticket */}
        <Card>
          <CardHeader>
            <CardTitle>VENTAS POR TIPO DE BOLETO</CardTitle>
            <CardDescription>Distribución de ventas por categoría</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              {data.ticketTypeBreakdown.map((ticket, index) => (
                <div key={ticket.type} className="space-y-2">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium">{ticket.type}</span>
                    <span className="text-sm text-muted-foreground">{ticket.percentage}%</span>
                  </div>
                  <div className="flex items-center space-x-2">
                    <Progress value={ticket.percentage} className="flex-1" />
                    <div className="text-right text-xs">
                      <div>{ticket.sold} tickets</div>
                      <div className="text-muted-foreground">{formatCurrency(ticket.revenue)}</div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Actividad reciente */}
      <Card>
        <CardHeader>
          <CardTitle>ACTIVIDAD RECIENTE</CardTitle>
          <CardDescription>Últimas transacciones y eventos</CardDescription>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {data.recentActivity.map((activity, index) => (
              <div key={index} className="flex items-center justify-between p-3 border rounded-lg">
                <div className="flex items-center space-x-3">
                  <div className={`w-2 h-2 rounded-full ${
                    activity.type === 'sale' ? 'bg-green-500' :
                    activity.type === 'ticket' ? 'bg-blue-500' : 'bg-purple-500'
                  }`}></div>
                  <div>
                    <p className="text-sm font-medium">{activity.description}</p>
                    <p className="text-xs text-muted-foreground">
                      {new Date(activity.timestamp).toLocaleString('es-CO')}
                    </p>
                  </div>
                </div>
                {activity.amount > 0 && (
                  <div className="text-right">
                    <p className="text-sm font-medium">{formatCurrency(activity.amount)}</p>
                  </div>
                )}
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  )
}

'use client'

import { useState } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select'
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table'
import { Badge } from '@/components/ui/badge'
import { 
  BarChart3, 
  TrendingUp, 
  Users, 
  Calendar,
  DollarSign,
  Download,
  Filter,
  Search
} from 'lucide-react'
import { ActivityChart } from '@/components/admin/charts/activity-chart'
import { TransactionDistributionChart } from '@/components/admin/charts/transaction-distribution-chart'
import { HourlyActivityChart } from '@/components/admin/charts/hourly-activity-chart'
import { IntelligentSalesAnalysis } from '@/components/admin/analytics/intelligent-sales-analysis'

interface AdminReportsClientProps {
  salesData: any
  eventsData: any
  usersData: any
  financialData: any
  activeTab?: string
}

export default function AdminReportsClient({
  salesData,
  eventsData,
  usersData,
  financialData,
  activeTab = 'overview'
}: AdminReportsClientProps) {
  const [filters, setFilters] = useState({
    startDate: '',
    endDate: '',
    category: '',
    status: '',
    paymentMethod: 'all'
  })

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('es-CO', {
      style: 'currency',
      currency: 'COP',
      minimumFractionDigits: 0
    }).format(amount)
  }

  const formatDate = (date: string) => {
    return new Date(date).toLocaleDateString('es-CO')
  }

  const renderSalesReport = () => (
    <div className="space-y-6">
      {/* Filtros */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <Filter className="h-5 w-5" />
            Filtros de Ventas
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
              <Label htmlFor="startDate">Fecha Inicio</Label>
              <Input
                id="startDate"
                type="date"
                value={filters.startDate}
                onChange={(e) => setFilters({ ...filters, startDate: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="endDate">Fecha Fin</Label>
              <Input
                id="endDate"
                type="date"
                value={filters.endDate}
                onChange={(e) => setFilters({ ...filters, endDate: e.target.value })}
              />
            </div>
            <div>
              <Label htmlFor="paymentMethod">Método de Pago</Label>
              <Select value={filters.paymentMethod} onValueChange={(value) => setFilters({ ...filters, paymentMethod: value })}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todos los métodos</SelectItem>
                  <SelectItem value="credit_card">Tarjeta de Crédito</SelectItem>
                  <SelectItem value="debit_card">Tarjeta de Débito</SelectItem>
                  <SelectItem value="bank_transfer">Transferencia Bancaria</SelectItem>
                  <SelectItem value="cash">Efectivo</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Estadísticas */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Ventas</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{salesData.stats?.totalSales || 0}</div>
            <p className="text-xs text-muted-foreground">
              {salesData.stats?.uniqueCustomers || 0} clientes únicos
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Ingresos Totales</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {formatCurrency(salesData.stats?.totalRevenue || 0)}
            </div>
            <p className="text-xs text-muted-foreground">
              Promedio: {formatCurrency(salesData.stats?.averageTicketPrice || 0)}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Eventos con Ventas</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{salesData.stats?.eventsWithSales || 0}</div>
            <p className="text-xs text-muted-foreground">
              Eventos activos
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Tasa de Conversión</CardTitle>
            <BarChart3 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">85.2%</div>
            <p className="text-xs text-muted-foreground">
              +2.1% desde el mes pasado
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Ventas por Evento */}
      <Card>
        <CardHeader>
          <CardTitle>Ventas por Evento</CardTitle>
          <CardDescription>
            Top eventos por ingresos generados
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Evento</TableHead>
                <TableHead>Fecha</TableHead>
                <TableHead>Ventas</TableHead>
                <TableHead>Ingresos</TableHead>
                <TableHead>Promedio</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {salesData.salesByEvent?.map((event: any) => (
                <TableRow key={event.event_id}>
                  <TableCell className="font-medium">{event.event_name}</TableCell>
                  <TableCell>{formatDate(event.event_date)}</TableCell>
                  <TableCell>{event.sales_count}</TableCell>
                  <TableCell>{formatCurrency(event.revenue)}</TableCell>
                  <TableCell>{formatCurrency(event.revenue / event.sales_count)}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Ventas por Método de Pago */}
      <Card>
        <CardHeader>
          <CardTitle>Ventas por Método de Pago</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {salesData.salesByPaymentMethod?.map((method: any) => (
              <div key={method.payment_method} className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Badge variant="outline">{method.payment_method}</Badge>
                  <span className="text-sm text-muted-foreground">
                    {method.sales_count} transacciones
                  </span>
                </div>
                <div className="text-right">
                  <div className="font-medium">{formatCurrency(method.revenue)}</div>
                  <div className="text-sm text-muted-foreground">
                    {((method.revenue / (salesData.stats?.totalRevenue || 1)) * 100).toFixed(1)}%
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  )

  const renderEventsReport = () => (
    <div className="space-y-6">
      {/* Estadísticas */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Eventos</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{eventsData.stats?.totalEvents || 0}</div>
            <p className="text-xs text-muted-foreground">
              {eventsData.stats?.uniqueOrganizers || 0} organizadores
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Eventos Publicados</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{eventsData.stats?.publishedEvents || 0}</div>
            <p className="text-xs text-muted-foreground">
              {eventsData.stats?.draftEvents || 0} en borrador
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Eventos Cancelados</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{eventsData.stats?.cancelledEvents || 0}</div>
            <p className="text-xs text-muted-foreground">
              Tasa de cancelación
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Promedio Asistencia</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">75.5%</div>
            <p className="text-xs text-muted-foreground">
              +5.2% desde el mes pasado
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Eventos por Categoría */}
      <Card>
        <CardHeader>
          <CardTitle>Eventos por Categoría</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Categoría</TableHead>
                <TableHead>Total Eventos</TableHead>
                <TableHead>Publicados</TableHead>
                <TableHead>Porcentaje</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {eventsData.eventsByCategory?.map((category: any) => (
                <TableRow key={category.category_id}>
                  <TableCell className="font-medium">{category.category_name}</TableCell>
                  <TableCell>{category.events_count}</TableCell>
                  <TableCell>{category.published_count}</TableCell>
                  <TableCell>
                    {((category.published_count / category.events_count) * 100).toFixed(1)}%
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Top Eventos por Rendimiento */}
      <Card>
        <CardHeader>
          <CardTitle>Top Eventos por Rendimiento</CardTitle>
          <CardDescription>
            Eventos con mejor asistencia y ventas
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Evento</TableHead>
                <TableHead>Fecha</TableHead>
                <TableHead>Boletos Vendidos</TableHead>
                <TableHead>Ingresos</TableHead>
                <TableHead>Asistencia</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {eventsData.topPerformingEvents?.map((event: any) => (
                <TableRow key={event.event_id}>
                  <TableCell className="font-medium">{event.event_name}</TableCell>
                  <TableCell>{formatDate(event.event_date)}</TableCell>
                  <TableCell>{event.tickets_sold}</TableCell>
                  <TableCell>{formatCurrency(event.revenue)}</TableCell>
                  <TableCell>
                    <Badge variant={event.attendance_percentage > 80 ? "default" : "secondary"}>
                      {event.attendance_percentage}%
                    </Badge>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )

  const renderUsersReport = () => (
    <div className="space-y-6">
      {/* Estadísticas */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Usuarios</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{usersData.stats?.totalUsers || 0}</div>
            <p className="text-xs text-muted-foreground">
              +180 desde el mes pasado
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Usuarios Activos</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{usersData.stats?.activeUsers || 0}</div>
            <p className="text-xs text-muted-foreground">
              {usersData.stats?.activeLast30Days || 0} últimos 30 días
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Organizadores</CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{usersData.stats?.organizerUsers || 0}</div>
            <p className="text-xs text-muted-foreground">
              {usersData.stats?.adminUsers || 0} administradores
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Tasa de Retención</CardTitle>
            <BarChart3 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">85.2%</div>
            <p className="text-xs text-muted-foreground">
              +2.1% desde el mes pasado
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Usuarios por Rol */}
      <Card>
        <CardHeader>
          <CardTitle>Usuarios por Rol</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {usersData.usersByRole?.map((role: any) => (
              <div key={role.role} className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Badge variant="outline">{role.role}</Badge>
                  <span className="text-sm text-muted-foreground">
                    {role.users_count} usuarios
                  </span>
                </div>
                <div className="text-right">
                  <div className="font-medium">
                    {((role.users_count / (usersData.stats?.totalUsers || 1)) * 100).toFixed(1)}%
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Top Usuarios */}
      <Card>
        <CardHeader>
          <CardTitle>Top Usuarios por Actividad</CardTitle>
          <CardDescription>
            Usuarios más activos en la plataforma
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Usuario</TableHead>
                <TableHead>Rol</TableHead>
                <TableHead>Eventos Creados</TableHead>
                <TableHead>Boletos Comprados</TableHead>
                <TableHead>Total Gastado</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {usersData.topUsers?.map((user: any) => (
                <TableRow key={user.user_id}>
                  <TableCell className="font-medium">
                    {user.first_name} {user.last_name}
                  </TableCell>
                  <TableCell>
                    <Badge variant="outline">{user.role}</Badge>
                  </TableCell>
                  <TableCell>{user.events_created}</TableCell>
                  <TableCell>{user.tickets_purchased}</TableCell>
                  <TableCell>{formatCurrency(user.total_spent)}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )

  const renderFinancialReport = () => (
    <div className="space-y-6">
      {/* Resumen Financiero */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Transacciones</CardTitle>
            <BarChart3 className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{financialData.summary?.totalTransactions || 0}</div>
            <p className="text-xs text-muted-foreground">
              {financialData.summary?.uniqueCustomers || 0} clientes únicos
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Ingresos Totales</CardTitle>
            <DollarSign className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {formatCurrency(financialData.summary?.totalRevenue || 0)}
            </div>
            <p className="text-xs text-muted-foreground">
              Promedio: {formatCurrency(financialData.summary?.averageTransaction || 0)}
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Eventos con Ingresos</CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{financialData.summary?.eventsWithRevenue || 0}</div>
            <p className="text-xs text-muted-foreground">
              Eventos generando ingresos
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Margen de Ganancia</CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">70.5%</div>
            <p className="text-xs text-muted-foreground">
              +2.1% desde el mes pasado
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Top Eventos por Ingresos */}
      <Card>
        <CardHeader>
          <CardTitle>Top Eventos por Ingresos</CardTitle>
          <CardDescription>
            Eventos que generan más ingresos
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Evento</TableHead>
                <TableHead>Fecha</TableHead>
                <TableHead>Transacciones</TableHead>
                <TableHead>Ingresos</TableHead>
                <TableHead>Promedio</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {financialData.topEventsByRevenue?.map((event: any) => (
                <TableRow key={event.event_id}>
                  <TableCell className="font-medium">{event.event_name}</TableCell>
                  <TableCell>{formatDate(event.event_date)}</TableCell>
                  <TableCell>{event.transactions}</TableCell>
                  <TableCell>{formatCurrency(event.revenue)}</TableCell>
                  <TableCell>{formatCurrency(event.revenue / event.transactions)}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>

      {/* Ingresos por Mes */}
      <Card>
        <CardHeader>
          <CardTitle>Ingresos por Mes</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Mes</TableHead>
                <TableHead>Transacciones</TableHead>
                <TableHead>Ingresos</TableHead>
                <TableHead>Promedio</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {financialData.revenueByMonth?.map((month: any) => (
                <TableRow key={month.month}>
                  <TableCell className="font-medium">
                    {new Date(month.month).toLocaleDateString('es-CO', { 
                      year: 'numeric', 
                      month: 'long' 
                    })}
                  </TableCell>
                  <TableCell>{month.transactions}</TableCell>
                  <TableCell>{formatCurrency(month.revenue)}</TableCell>
                  <TableCell>{formatCurrency(month.revenue / month.transactions)}</TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )

  const renderOverview = () => (
    <div className="space-y-6">
      {/* Análisis Inteligente de Ventas */}
      <IntelligentSalesAnalysis />
      
      {/* Gráfico de Actividad */}
      <ActivityChart />
      
      {/* Gráfico de Distribución de Transacciones */}
      <TransactionDistributionChart />
      
      {/* Gráfico de Actividad por Hora */}
      <HourlyActivityChart />
    </div>
  )

  const renderContent = () => {
    switch (activeTab) {
      case 'sales':
        return renderSalesReport()
      case 'events':
        return renderEventsReport()
      case 'users':
        return renderUsersReport()
      case 'financial':
        return renderFinancialReport()
      default:
        return renderOverview()
    }
  }

  return (
    <div className="space-y-6">
      {/* Botones de Acción */}
      <div className="flex justify-between items-center">
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            <Download className="h-4 w-4 mr-2" />
            Exportar PDF
          </Button>
          <Button variant="outline" size="sm">
            <Download className="h-4 w-4 mr-2" />
            Exportar Excel
          </Button>
        </div>
        <div className="flex gap-2">
          <Button variant="outline" size="sm">
            <Search className="h-4 w-4 mr-2" />
            Búsqueda Avanzada
          </Button>
        </div>
      </div>

      {/* Contenido del Reporte */}
      {renderContent()}
    </div>
  )
}

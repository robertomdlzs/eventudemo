"use client"

import type React from "react"

import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Checkbox } from "@/components/ui/checkbox"
import { Badge } from "@/components/ui/badge"
import { ScrollArea } from "@/components/ui/scroll-area"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { AlertTriangle, Calendar, MapPin } from "lucide-react"
import type { AdminUser } from "@/app/admin/actions"
import { apiClient } from "@/lib/api-client"
import { getEventsForOrganizers } from "@/app/admin/actions"

interface UserFormProps {
  initialData?: AdminUser
  onSubmit: (data: Omit<AdminUser, "id" | "createdAt"> | Partial<Omit<AdminUser, "id" | "createdAt">>) => void
  onCancel?: () => void
}

export function UserForm({ initialData, onSubmit, onCancel }: UserFormProps) {
  // Usar first_name y last_name directamente
  const firstName = initialData?.first_name || ''
  const lastName = initialData?.last_name || ''

  const [formData, setFormData] = useState({
    firstName: firstName,
    lastName: lastName,
    email: initialData?.email || "",
    password: "", // Campo de contraseña
    phone: initialData?.phone || "",
    role: initialData?.role || ("user" as const),
    status: initialData?.status || ("active" as const),
  })

  // Estado para eventos
  const [events, setEvents] = useState<any[]>([])
  const [selectedEvents, setSelectedEvents] = useState<string[]>([])
  const [loadingEvents, setLoadingEvents] = useState(false)

  // Cargar eventos cuando el rol es organizador
  useEffect(() => {
    if (formData.role === 'organizer') {
      loadEvents()
    }
  }, [formData.role])

  const loadEvents = async () => {
    setLoadingEvents(true)
    try {
      // Usar server action para obtener eventos (funciona desde el servidor con autenticación)
      const eventsData = await getEventsForOrganizers()
      setEvents(eventsData)
      console.log('✅ Eventos cargados:', eventsData.length)
    } catch (error) {
      console.error('Error loading events:', error)
    } finally {
      setLoadingEvents(false)
    }
  }

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    
    // Validar que si es organizador, tenga al menos un evento asignado
    if (formData.role === 'organizer' && selectedEvents.length === 0) {
      alert('Los organizadores deben tener al menos un evento asignado.')
      return
    }
    
    // Preparar datos para enviar
    const submitData = {
      ...formData,
      // Solo incluir password si no está vacío (para edición)
      ...(formData.password && { password: formData.password }),
      // Incluir eventos seleccionados si es organizador
      ...(formData.role === 'organizer' && { assignedEvents: selectedEvents })
    }
    
    
    onSubmit(submitData)
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle>{initialData ? "Editar Usuario" : "Crear Nuevo Usuario"}</CardTitle>
      </CardHeader>
      <CardContent>
        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="firstName">Nombre</Label>
              <Input
                id="firstName"
                value={formData.firstName}
                onChange={(e) => setFormData({ ...formData, firstName: e.target.value })}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="lastName">Apellido</Label>
              <Input
                id="lastName"
                value={formData.lastName}
                onChange={(e) => setFormData({ ...formData, lastName: e.target.value })}
                required
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="email">Email</Label>
              <Input
                id="email"
                type="email"
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                required
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password">
                {initialData ? "Nueva Contraseña (opcional)" : "Contraseña"}
              </Label>
              <Input
                id="password"
                type="password"
                value={formData.password}
                onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                required={!initialData} // Requerido solo para crear usuario
                placeholder={initialData ? "Dejar vacío para mantener la actual" : ""}
              />
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="phone">Teléfono</Label>
              <Input
                id="phone"
                value={formData.phone}
                onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="role">Rol</Label>
              <Select
                value={formData.role}
                onValueChange={(value: "admin" | "organizer" | "user") => setFormData({ ...formData, role: value })}
              >
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="admin">Administrador</SelectItem>
                  <SelectItem value="organizer">Organizador</SelectItem>
                  <SelectItem value="user">Usuario</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>

          <div className="space-y-2">
            <Label htmlFor="status">Estado</Label>
            <Select
              value={formData.status}
              onValueChange={(value: "active" | "inactive") => setFormData({ ...formData, status: value })}
            >
              <SelectTrigger>
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="active">Activo</SelectItem>
                <SelectItem value="inactive">Inactivo</SelectItem>
              </SelectContent>
            </Select>
          </div>

          {/* Sección de eventos para organizadores */}
          {formData.role === 'organizer' && (
            <div className="space-y-4">
              <div className="flex items-center gap-2">
                <AlertTriangle className="h-4 w-4 text-amber-500" />
                <Label className="text-sm font-medium text-amber-700">
                  Eventos Asignados (Obligatorio para organizadores)
                </Label>
              </div>
              
              {loadingEvents ? (
                <div className="text-sm text-gray-500">Cargando eventos...</div>
              ) : events.length === 0 ? (
                <Alert>
                  <AlertTriangle className="h-4 w-4" />
                  <AlertDescription>
                    No hay eventos disponibles. Debes crear eventos antes de asignar organizadores.
                  </AlertDescription>
                </Alert>
              ) : (
                <ScrollArea className="h-48 w-full border rounded-md p-4">
                  <div className="space-y-2">
                    {events.map((event) => (
                      <div key={event.id} className="flex items-center space-x-2">
                        <Checkbox
                          id={`event-${event.id}`}
                          checked={selectedEvents.includes(event.id.toString())}
                          onCheckedChange={(checked) => {
                            if (checked) {
                              setSelectedEvents([...selectedEvents, event.id.toString()])
                            } else {
                              setSelectedEvents(selectedEvents.filter(id => id !== event.id.toString()))
                            }
                          }}
                        />
                        <Label htmlFor={`event-${event.id}`} className="flex-1 cursor-pointer">
                          <div className="flex items-center justify-between">
                            <span className="font-medium">{event.title}</span>
                            <div className="flex items-center gap-2 text-xs text-gray-500">
                              <Calendar className="h-3 w-3" />
                              <span>{new Date(event.date).toLocaleDateString()}</span>
                              <MapPin className="h-3 w-3" />
                              <span>{event.venue}</span>
                            </div>
                          </div>
                        </Label>
                      </div>
                    ))}
                  </div>
                </ScrollArea>
              )}
              
              {selectedEvents.length > 0 && (
                <div className="flex flex-wrap gap-2">
                  <span className="text-sm text-gray-600">Eventos seleccionados:</span>
                  {selectedEvents.map((eventId) => {
                    const event = events.find(e => e.id.toString() === eventId)
                    return event ? (
                      <Badge key={eventId} variant="secondary">
                        {event.title}
                      </Badge>
                    ) : null
                  })}
                </div>
              )}
            </div>
          )}

          <div className="flex gap-2 pt-4">
            <Button type="submit">{initialData ? "Actualizar Usuario" : "Crear Usuario"}</Button>
            <Button type="button" variant="outline" onClick={onCancel}>
              Cancelar
            </Button>
          </div>
        </form>
      </CardContent>
    </Card>
  )
}

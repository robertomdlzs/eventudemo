"use client"

import { Event } from "@/lib/types"
import { useState, useEffect, useCallback } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Separator } from "@/components/ui/separator"
import { ArrowLeft, MapPin, Users, ShoppingCart, Check, ZoomIn, ZoomOut, RotateCcw, Clock, AlertCircle, Star, Crown, Wheelchair } from "lucide-react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { apiClient } from "@/lib/api-client"
import { useCart } from "@/hooks/use-cart"
import { useSeatReservation } from "@/lib/seat-reservation-manager"
import { toast } from "@/hooks/use-toast"

interface SeatSelectionClientProps {
  event: any // Cambiar a any para evitar problemas de tipo
  selectedTickets: { [key: string]: number }
}

interface Seat {
  id: string
  row: string
  number: string
  section: string
  status: 'available' | 'occupied' | 'reserved' | 'blocked'
  price?: number
  type?: 'regular' | 'vip' | 'accessible' | 'premium'
  isWheelchairAccessible?: boolean
  hasExtraLegroom?: boolean
  isAisleSeat?: boolean
  isWindowSeat?: boolean
  category?: 'economy' | 'business' | 'first'
}

export default function SeatSelectionClient({ event, selectedTickets }: SeatSelectionClientProps) {
  const router = useRouter()
  const { addToCart, updateCartItem, cart } = useCart()
  
  const [seats, setSeats] = useState<Seat[]>([])
  const [selectedSeats, setSelectedSeats] = useState<Seat[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [zoom, setZoom] = useState(1)
  const [pan, setPan] = useState({ x: 0, y: 0 })
  const [isDragging, setIsDragging] = useState(false)
  const [dragStart, setDragStart] = useState({ x: 0, y: 0 })

  // Calcular el total de boletas necesarias
  const totalTicketsNeeded = Object.values(selectedTickets).reduce((total, quantity) => total + quantity, 0)
  
  // Si no hay boletas seleccionadas, permitir seleccionar hasta 4 asientos por defecto
  const maxSeatsToSelect = totalTicketsNeeded > 0 ? totalTicketsNeeded : 4

  useEffect(() => {
    loadSeats()
  }, [])

  // Debug: Log cuando cambia el estado de seats
  useEffect(() => {
    console.log('🔄 Seats state changed:', seats.length, 'seats')
    if (seats.length > 0) {
      console.log('📊 First few seats:', seats.slice(0, 3))
    }
  }, [seats])


  const loadSeats = async () => {
    try {
      setLoading(true)
      console.log('🪑 Loading seats for event:', event.id, 'with seatMapId:', event.seatMapId)
      
      // Si el evento tiene mapa de asientos, obtener asientos reales
      if (event.seatMapId) {
        try {
          // Intentar obtener asientos desde la API
          const response = await apiClient.getEventSeats(event.id)
          console.log('📡 API Response:', response)
          if (response.success && response.data) {
            console.log('✅ Seats loaded from API:', response.data.length, 'seats')
            setSeats(response.data)
            return
          } else {
            console.warn('❌ API response not successful:', response)
          }
        } catch (apiError) {
          console.warn('Failed to fetch seats from API, using mock data:', apiError)
        }
      }
      
      // Fallback a datos mock si no hay API o falla
      console.log('🔄 Using mock data fallback')
      const mockSeats: Seat[] = generateMockSeats()
      setSeats(mockSeats)
    } catch (err) {
      console.error('💥 Error loading seats:', err)
      setError('Error al cargar los asientos')
    } finally {
      setLoading(false)
    }
  }

  const generateMockSeats = (): Seat[] => {
    const sections = [
      { name: 'A', type: 'premium', price: 80000, category: 'first' },
      { name: 'B', type: 'vip', price: 65000, category: 'business' },
      { name: 'C', type: 'regular', price: 45000, category: 'economy' },
      { name: 'D', type: 'regular', price: 40000, category: 'economy' },
      { name: 'E', type: 'accessible', price: 45000, category: 'accessible' }
    ]
    
    const seats: Seat[] = []
    
    sections.forEach((section, sectionIndex) => {
      for (let row = 1; row <= 10; row++) {
        for (let seatNum = 1; seatNum <= 20; seatNum++) {
          const isWheelchair = section.name === 'E' && seatNum <= 4
          const isAisle = seatNum === 1 || seatNum === 20
          const isWindow = seatNum === 1 || seatNum === 20
          const hasExtraLegroom = row === 1 || row === 10
          
          seats.push({
            id: `${section.name}-${row}-${seatNum}`,
            row: row.toString(),
            number: seatNum.toString(),
            section: section.name,
            status: Math.random() > 0.3 ? 'available' : 'occupied',
            price: section.price,
            type: section.type as any,
            category: section.category as any,
            isWheelchairAccessible: isWheelchair,
            hasExtraLegroom,
            isAisleSeat: isAisle,
            isWindowSeat: isWindow
          })
        }
      }
    })
    
    return seats
  }

  const handleSeatClick = useCallback((seat: Seat) => {
    if (seat.status !== 'available') {
      toast({
        title: "Asiento no disponible",
        description: "Este asiento no está disponible para selección",
        variant: "destructive"
      })
      return
    }

    setSelectedSeats(prev => {
      const isSelected = prev.find(s => s.id === seat.id)
      if (isSelected) {
        // Deseleccionar asiento
        toast({
          title: "Asiento deseleccionado",
          description: `Asiento ${seat.section}-${seat.row}-${seat.number} deseleccionado`,
        })
        return prev.filter(s => s.id !== seat.id)
      } else {
        // Seleccionar asiento (si no excede la cantidad necesaria)
        if (prev.length < maxSeatsToSelect) {
          toast({
            title: "Asiento seleccionado",
            description: `Asiento ${seat.section}-${seat.row}-${seat.number} seleccionado`,
          })
          return [...prev, seat]
        } else {
          toast({
            title: "Límite alcanzado",
            description: `Puedes seleccionar máximo ${maxSeatsToSelect} asientos`,
            variant: "destructive"
          })
          return prev
        }
      }
    })
  }, [maxSeatsToSelect, toast])

  const getSeatColor = (seat: Seat) => {
    if (selectedSeats.find(s => s.id === seat.id)) {
      return 'bg-green-500 text-white hover:bg-green-600'
    }
    
    switch (seat.status) {
      case 'available':
        return 'bg-gray-200 text-gray-800 hover:bg-gray-300'
      case 'occupied':
        return 'bg-red-500 text-white'
      case 'reserved':
        return 'bg-yellow-500 text-white'
      case 'blocked':
        return 'bg-gray-400 text-white'
      default:
        return 'bg-gray-200 text-gray-800'
    }
  }

  const getSeatIcon = (seat: Seat) => {
    if (seat.isWheelchairAccessible) return <Users className="w-3 h-3" />
    if (seat.type === 'vip') return <Crown className="w-3 h-3" />
    if (seat.type === 'premium') return <Star className="w-3 h-3" />
    if (seat.hasExtraLegroom) return <Users className="w-3 h-3" />
    return null
  }



  const calculateTotalPrice = () => {
    const ticketPrice = Object.entries(selectedTickets).reduce((total, [ticketTypeId, quantity]) => {
      const ticketType = event.ticketTypes?.find(t => t.id === ticketTypeId)
      return total + (ticketType ? quantity * ticketType.price : 0)
    }, 0)
    
    const seatPrice = selectedSeats.reduce((total, seat) => total + (seat.price || 0), 0)
    
    return ticketPrice + seatPrice
  }

  const handleContinue = () => {
    if (selectedSeats.length === 0) return

    // Calcular el precio total de los asientos
    const seatPrice = selectedSeats.reduce((total, seat) => total + (seat.price || 0), 0)
    
    // Calcular el precio total de los tickets
    const ticketPrice = Object.entries(selectedTickets).reduce((total, [ticketTypeId, quantity]) => {
      const ticketType = event.ticketTypes?.find(t => t.id === ticketTypeId)
      return total + (ticketType ? quantity * ticketType.price : 0)
    }, 0)

    // Crear item del carrito con la estructura correcta
    const cartItem = {
      eventId: event.id,
      eventTitle: event.title,
      eventSlug: event.slug,
      eventImage: event.image_url,
      ticketTypeId: 'seat-selection', // ID único para selección de asientos
      ticketTypeName: 'Selección de Asientos',
      quantity: selectedSeats.length,
      price: (seatPrice + ticketPrice) / selectedSeats.length, // Precio promedio por asiento
      eventDate: event.date,
      eventLocation: event.location,
      selectedSeats: selectedSeats.map(seat => ({
        id: seat.id,
        section: seat.section,
        row: seat.row,
        number: seat.number,
        price: seat.price || 0,
        type: seat.type,
        category: seat.category
      })),
      totalPrice: seatPrice + ticketPrice
    }

    // Buscar si ya existe un item para este evento en el carrito
    const existingItemIndex = cart.items.findIndex((item: any) => item.eventId === event.id)
    
    if (existingItemIndex >= 0) {
      // Actualizar item existente
      updateCartItem(existingItemIndex, cartItem)
    } else {
      // Agregar nuevo item
      addToCart(cartItem)
    }

    // Redirigir al carrito
    router.push('/carrito')
  }

  const handleZoomIn = () => {
    setZoom(prev => Math.min(prev + 0.2, 3))
  }

  const handleZoomOut = () => {
    setZoom(prev => Math.max(prev - 0.2, 0.5))
  }

  const handleReset = () => {
    setZoom(1)
    setPan({ x: 0, y: 0 })
  }

  const handleMouseDown = (e: React.MouseEvent) => {
    setIsDragging(true)
    setDragStart({ x: e.clientX - pan.x, y: e.clientY - pan.y })
  }

  const handleMouseMove = (e: React.MouseEvent) => {
    if (isDragging) {
      setPan({
        x: e.clientX - dragStart.x,
        y: e.clientY - dragStart.y
      })
    }
  }

  const handleMouseUp = () => {
    setIsDragging(false)
  }

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600 mx-auto"></div>
          <p className="mt-4 text-gray-600">Cargando mapa de asientos...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="min-h-screen bg-gray-50 flex items-center justify-center">
        <div className="text-center">
          <p className="text-red-600 mb-4">{error}</p>
          <Button onClick={loadSeats}>Reintentar</Button>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <div className="bg-white border-b">
        <div className="max-w-7xl mx-auto px-4 py-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-4">
              <Link href={`/evento/${event.slug}`}>
                <Button variant="ghost" size="sm">
                  <ArrowLeft className="h-4 w-4 mr-2" />
                  Volver
                </Button>
              </Link>
              <div>
                <h1 className="text-xl font-semibold">{event.title}</h1>
                <p className="text-sm text-gray-500">Selección de asientos</p>
              </div>
            </div>
            <div className="text-right">
              <p className="text-sm text-gray-500">Asientos seleccionados</p>
              <p className="text-lg font-semibold">
                {selectedSeats.length} / {maxSeatsToSelect}
              </p>
            </div>
          </div>
        </div>
      </div>


      <div className="max-w-7xl mx-auto px-4 py-8">
        <div className="grid grid-cols-1 lg:grid-cols-4 gap-8">
          {/* Mapa de asientos - Contenedor principal mejorado */}
          <div className="lg:col-span-3">
            <Card>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="flex items-center gap-2">
                    <MapPin className="h-5 w-5" />
                    Mapa de Asientos
                  </CardTitle>
                  
                  {/* Controles de zoom y navegación */}
                  <div className="flex items-center gap-2">
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={handleZoomOut}
                      disabled={zoom <= 0.5}
                    >
                      <ZoomOut className="h-4 w-4" />
                    </Button>
                    <span className="text-sm font-medium min-w-[60px] text-center">
                      {Math.round(zoom * 100)}%
                    </span>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={handleZoomIn}
                      disabled={zoom >= 3}
                    >
                      <ZoomIn className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={handleReset}
                    >
                      <RotateCcw className="h-4 w-4" />
                    </Button>
                  </div>
                </div>
              </CardHeader>
              <CardContent>
                {/* Contenedor del mapa con scroll y zoom */}
                <div 
                  className="relative overflow-auto bg-gray-100 rounded-lg border-2 border-gray-300"
                  style={{ 
                    height: '600px',
                    cursor: isDragging ? 'grabbing' : 'grab'
                  }}
                  onMouseDown={handleMouseDown}
                  onMouseMove={handleMouseMove}
                  onMouseUp={handleMouseUp}
                  onMouseLeave={handleMouseUp}
                >
                  {/* Lienzo del mapa con transformaciones */}
                  <div 
                    className="relative p-8"
                    style={{
                      transform: `scale(${zoom}) translate(${pan.x / zoom}px, ${pan.y / zoom}px)`,
                      transformOrigin: 'center',
                      minWidth: '100%',
                      minHeight: '100%'
                    }}
                  >
                    {/* Escenario mejorado */}
                    <div className="text-center mb-8">
                      <div className="bg-gradient-to-r from-gray-800 to-gray-900 text-white py-6 px-12 rounded-lg inline-block shadow-lg">
                        <p className="font-bold text-lg">ESCENARIO</p>
                        <p className="text-sm text-gray-300 mt-1">PALCO PRINCIPAL</p>
                      </div>
                    </div>

                    {/* Asientos reales del evento */}
                    <div className="space-y-8">
                      {seats.length > 0 ? (
                        // Agrupar asientos por sección
                        Object.entries(
                          seats.reduce((acc, seat) => {
                            if (!acc[seat.section]) {
                              acc[seat.section] = []
                            }
                            acc[seat.section].push(seat)
                            return acc
                          }, {} as { [key: string]: Seat[] })
                        ).map(([sectionName, sectionSeats]) => (
                          <div key={sectionName} className="space-y-4">
                            <div className="text-center">
                              <h3 className="font-bold text-lg bg-blue-100 py-2 px-4 rounded-lg inline-block">
                                {sectionName}
                              </h3>
                            </div>
                            
                            {/* Renderizar asientos individuales */}
                            <div className="flex flex-wrap gap-2 justify-center max-w-4xl mx-auto">
                              {sectionSeats.map(seat => {
                                const isSelected = selectedSeats.find(s => s.id === seat.id)
                                
                                return (
                                  <div key={seat.id} className="relative">
                                    <button
                                      onClick={() => handleSeatClick(seat)}
                                      disabled={seat.status !== 'available'}
                                      className={`w-12 h-12 rounded-lg text-sm font-bold transition-all duration-200 shadow-md hover:shadow-lg ${getSeatColor(seat)} ${
                                        seat.status === 'available' ? 'cursor-pointer hover:scale-105' : 'cursor-not-allowed'
                                      } relative`}
                                      title={`${seat.section} - Fila ${seat.row}, Asiento ${seat.number} - $${seat.price?.toLocaleString() || 'N/A'}`}
                                    >
                                      {seat.number}
                                      {getSeatIcon(seat)}
                                    </button>
                                    
                                  </div>
                                )
                              })}
                            </div>
                          </div>
                        ))
                      ) : (
                        <div className="text-center py-8">
                          <p className="text-gray-500">Cargando asientos...</p>
                        </div>
                      )}
                    </div>

                    {/* Leyenda mejorada */}
                    <div className="flex justify-center gap-8 text-sm mt-8 bg-white p-4 rounded-lg shadow-md">
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-gray-200 rounded-lg shadow-sm"></div>
                        <span className="font-medium">Disponible</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-green-500 rounded-lg shadow-sm"></div>
                        <span className="font-medium">Seleccionado</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-red-500 rounded-lg shadow-sm"></div>
                        <span className="font-medium">Ocupado</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-yellow-500 rounded-lg shadow-sm"></div>
                        <span className="font-medium">Reservado</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-purple-500 rounded-lg shadow-sm flex items-center justify-center">
                          <Crown className="w-3 h-3 text-white" />
                        </div>
                        <span className="font-medium">VIP</span>
                      </div>
                      <div className="flex items-center gap-2">
                        <div className="w-6 h-6 bg-orange-500 rounded-lg shadow-sm flex items-center justify-center">
                          <Users className="w-3 h-3 text-white" />
                        </div>
                        <span className="font-medium">Accesible</span>
                      </div>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          {/* Sidebar - Resumen */}
          <div className="space-y-6">
            <Card className="sticky top-6">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <ShoppingCart className="h-5 w-5" />
                  Resumen de Compra
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                {/* Boletas seleccionadas */}
                <div className="space-y-3">
                  {Object.entries(selectedTickets).map(([ticketTypeId, quantity]) => {
                    if (quantity === 0) return null
                    const ticketType = event.ticketTypes?.find(t => t.id === ticketTypeId)
                    if (!ticketType) return null
                    
                    return (
                      <div key={ticketTypeId} className="flex justify-between items-center text-sm">
                        <div>
                          <p className="font-medium">{ticketType.name}</p>
                          <p className="text-gray-500">{quantity} boletas</p>
                        </div>
                        <p className="font-semibold">
                          ${(quantity * ticketType.price).toLocaleString()}
                        </p>
                      </div>
                    )
                  })}
                </div>

                <Separator />

                {/* Asientos seleccionados */}
                {selectedSeats.length > 0 && (
                  <>
                    <div>
                      <p className="font-medium mb-2">Asientos seleccionados:</p>
                      <div className="space-y-1">
                        {selectedSeats.map(seat => {
                          return (
                            <div key={seat.id} className="flex items-center justify-between text-sm">
                              <div className="flex items-center gap-2">
                                <Check className="h-3 w-3 text-green-500" />
                                <span>{seat.section}{seat.row}-{seat.number}</span>
                                {seat.type === 'vip' && <Crown className="w-3 h-3 text-purple-500" />}
                                {seat.type === 'premium' && <Star className="w-3 h-3 text-yellow-500" />}
                                {seat.isWheelchairAccessible && <Wheelchair className="w-3 h-3 text-orange-500" />}
                              </div>
                              <div className="text-right">
                                <span className="text-gray-500">${seat.price?.toLocaleString()}</span>
                              </div>
                            </div>
                          )
                        })}
                      </div>
                    </div>
                    <Separator />
                  </>
                )}

                {/* Total */}
                <div className="flex justify-between items-center text-lg font-bold">
                  <span>Total:</span>
                  <span className="text-green-600">${calculateTotalPrice().toLocaleString()}</span>
                </div>

                {/* Información de reserva */}
                {selectedSeats.length > 0 && (
                  <div className="bg-blue-50 p-3 rounded-lg">
                    <div className="flex items-center gap-2 text-sm text-blue-700">
                      <Clock className="w-4 h-4" />
                      <span>Tienes 15 minutos para completar tu compra</span>
                    </div>
                  </div>
                )}

                {/* Botón continuar */}
                <Button 
                  className="w-full" 
                  size="lg"
                  disabled={selectedSeats.length === 0}
                  onClick={handleContinue}
                >
                  {selectedSeats.length > 0 
                    ? 'Continuar al Pago' 
                    : 'Selecciona al menos un asiento'
                  }
                </Button>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  )
}

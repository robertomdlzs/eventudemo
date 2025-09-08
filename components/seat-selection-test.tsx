"use client"

import { useState } from 'react'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { toast } from '@/hooks/use-toast'

interface Seat {
  id: string
  row: string
  number: string
  section: string
  status: 'available' | 'occupied' | 'reserved'
  price: number
}

export function SeatSelectionTest() {
  const [selectedSeats, setSelectedSeats] = useState<Seat[]>([])
  const [seats] = useState<Seat[]>([
    { id: 'A-1', row: 'A', number: '1', section: 'VIP', status: 'available', price: 100000 },
    { id: 'A-2', row: 'A', number: '2', section: 'VIP', status: 'available', price: 100000 },
    { id: 'A-3', row: 'A', number: '3', section: 'VIP', status: 'occupied', price: 100000 },
    { id: 'B-1', row: 'B', number: '1', section: 'General', status: 'available', price: 50000 },
    { id: 'B-2', row: 'B', number: '2', section: 'General', status: 'available', price: 50000 },
    { id: 'B-3', row: 'B', number: '3', section: 'General', status: 'reserved', price: 50000 },
  ])

  const handleSeatClick = (seat: Seat) => {
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
        toast({
          title: "Asiento deseleccionado",
          description: `Asiento ${seat.section}-${seat.row}-${seat.number} deseleccionado`,
        })
        return prev.filter(s => s.id !== seat.id)
      } else {
        if (prev.length >= 4) {
          toast({
            title: "Límite alcanzado",
            description: "Puedes seleccionar máximo 4 asientos",
            variant: "destructive"
          })
          return prev
        }
        toast({
          title: "Asiento seleccionado",
          description: `Asiento ${seat.section}-${seat.row}-${seat.number} seleccionado`,
        })
        return [...prev, seat]
      }
    })
  }

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
      default:
        return 'bg-gray-200 text-gray-800'
    }
  }

  const totalPrice = selectedSeats.reduce((sum, seat) => sum + seat.price, 0)

  return (
    <div className="max-w-4xl mx-auto p-6 space-y-6">
      <Card>
        <CardHeader>
          <CardTitle>Prueba de Selección de Asientos</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="space-y-4">
            {/* Leyenda */}
            <div className="flex gap-4 text-sm">
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-gray-200 rounded"></div>
                <span>Disponible</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-green-500 rounded"></div>
                <span>Seleccionado</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-red-500 rounded"></div>
                <span>Ocupado</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 bg-yellow-500 rounded"></div>
                <span>Reservado</span>
              </div>
            </div>

            {/* Mapa de asientos */}
            <div className="grid grid-cols-6 gap-2 max-w-md">
              {seats.map(seat => (
                <button
                  key={seat.id}
                  onClick={() => handleSeatClick(seat)}
                  disabled={seat.status !== 'available'}
                  className={`w-12 h-12 rounded text-xs font-bold transition-colors ${getSeatColor(seat)}`}
                >
                  {seat.row}-{seat.number}
                </button>
              ))}
            </div>

            {/* Resumen de selección */}
            {selectedSeats.length > 0 && (
              <div className="mt-6 p-4 bg-gray-50 rounded-lg">
                <h3 className="font-semibold mb-2">Asientos Seleccionados:</h3>
                <div className="space-y-1">
                  {selectedSeats.map(seat => (
                    <div key={seat.id} className="flex justify-between text-sm">
                      <span>{seat.section} - Fila {seat.row}, Asiento {seat.number}</span>
                      <span>${seat.price.toLocaleString('es-CO')}</span>
                    </div>
                  ))}
                </div>
                <div className="mt-2 pt-2 border-t font-semibold flex justify-between">
                  <span>Total:</span>
                  <span>${totalPrice.toLocaleString('es-CO')}</span>
                </div>
              </div>
            )}

            {/* Botón de continuar */}
            <Button 
              className="w-full" 
              disabled={selectedSeats.length === 0}
              onClick={() => {
                toast({
                  title: "¡Perfecto!",
                  description: `Has seleccionado ${selectedSeats.length} asientos por un total de $${totalPrice.toLocaleString('es-CO')}`,
                })
              }}
            >
              Continuar con {selectedSeats.length} asiento{selectedSeats.length !== 1 ? 's' : ''}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}


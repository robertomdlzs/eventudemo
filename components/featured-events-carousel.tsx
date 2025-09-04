"use client"

import { useState, useEffect } from "react"
import { ChevronLeft, ChevronRight, Calendar, MapPin, Users } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import Link from "next/link"
import Image from "next/image"
import type { EventData } from "@/lib/events-data"

interface FeaturedEventsCarouselProps {
  events?: EventData[]
}

export { FeaturedEventsCarousel }
export default FeaturedEventsCarousel

function FeaturedEventsCarousel({ events = [] }: FeaturedEventsCarouselProps) {
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    if (events.length === 0) return

    const timer = setInterval(() => {
      setCurrentIndex((prevIndex) => (prevIndex + 1) % events.length)
    }, 5000)

    return () => clearInterval(timer)
  }, [events.length])

  const nextSlide = () => {
    setCurrentIndex((prevIndex) => (prevIndex + 1) % events.length)
  }

  const prevSlide = () => {
    setCurrentIndex((prevIndex) => (prevIndex - 1 + events.length) % events.length)
  }

  const goToSlide = (index: number) => {
    setCurrentIndex(index)
  }

  if (events.length === 0) {
    return (
      <div className="text-center py-12">
        <h2 className="text-3xl md:text-4xl font-bold mb-4">Próximos Eventos</h2>
        <p className="text-white/80 mb-8">No hay eventos destacados disponibles en este momento</p>
      </div>
    )
  }

  const currentEvent = events[currentIndex]

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat("es-CO", {
      style: "currency",
      currency: "COP",
      minimumFractionDigits: 0,
    }).format(price)
  }

  return (
    <div className="relative">
      <div className="text-center mb-8">
        <h2 className="text-3xl md:text-4xl font-bold mb-4">Próximos Eventos</h2>
        <p className="text-white/80 mb-8">Descubre los eventos más esperados</p>
      </div>

      <div className="relative overflow-hidden rounded-2xl bg-white/10 backdrop-blur-sm border border-white/20">
        <div className="grid md:grid-cols-2 gap-0 min-h-[400px]">
          {/* Imagen del evento */}
          <div className="relative overflow-hidden">
            <Image
              src={currentEvent.image || "/placeholder.svg"}
              alt={currentEvent.title}
              width={600}
              height={400}
              className="w-full h-full object-cover"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />

            {/* Badge de categoría */}
            <div className="absolute top-4 left-4">
              <Badge className="bg-white/20 backdrop-blur-sm text-white border-white/30">
                {currentEvent.categoryDisplay}
              </Badge>
            </div>

            {/* Indicadores de precio */}
            <div className="absolute bottom-4 left-4">
              <div className="bg-white/20 backdrop-blur-sm rounded-lg px-3 py-2">
                <span className="text-white font-bold text-lg">Desde {formatPrice(currentEvent.price)}</span>
              </div>
            </div>
          </div>

          {/* Información del evento */}
          <div className="p-8 flex flex-col justify-center">
            <div className="space-y-4">
              <div>
                <h3 className="text-2xl md:text-3xl font-bold text-white mb-2">{currentEvent.title}</h3>
                <p className="text-white/80 text-lg leading-relaxed">{currentEvent.description}</p>
              </div>

              <div className="space-y-3">
                <div className="flex items-center text-white/90">
                  <Calendar className="h-5 w-5 mr-3 text-amber-400" />
                  <span className="font-medium">{currentEvent.date}</span>
                </div>
                <div className="flex items-center text-white/90">
                  <MapPin className="h-5 w-5 mr-3 text-amber-400" />
                  <span className="font-medium">{currentEvent.locationDisplay}</span>
                </div>
                {currentEvent.capacity && (
                  <div className="flex items-center text-white/90">
                    <Users className="h-5 w-5 mr-3 text-amber-400" />
                    <span className="font-medium">
                      {currentEvent.soldTickets || 0} / {currentEvent.capacity} asistentes
                    </span>
                  </div>
                )}
              </div>

              <div className="flex gap-3 pt-4">
                <Link href={`/evento/${currentEvent.slug}`}>
                  <Button className="bg-white text-neutral-900 hover:bg-white/90 font-bold px-6">Ver Detalles</Button>
                </Link>
                <Link href={`/evento/${currentEvent.slug}/comprar`}>
                  <Button
                    variant="outline"
                    className="border-white/30 text-white hover:bg-white/10 font-bold px-6 bg-transparent"
                  >
                    Comprar Ahora
                  </Button>
                </Link>
              </div>
            </div>
          </div>
        </div>

        {/* Controles de navegación */}
        {events.length > 1 && (
          <>
            <Button
              variant="ghost"
              size="icon"
              className="absolute left-4 top-1/2 -translate-y-1/2 bg-white/20 backdrop-blur-sm hover:bg-white/30 text-white border-white/30"
              onClick={prevSlide}
            >
              <ChevronLeft className="h-6 w-6" />
            </Button>
            <Button
              variant="ghost"
              size="icon"
              className="absolute right-4 top-1/2 -translate-y-1/2 bg-white/20 backdrop-blur-sm hover:bg-white/30 text-white border-white/30"
              onClick={nextSlide}
            >
              <ChevronRight className="h-6 w-6" />
            </Button>
          </>
        )}
      </div>

      {/* Indicadores de puntos */}
      {events.length > 1 && (
        <div className="flex justify-center mt-6 space-x-2">
          {events.map((_, index) => (
            <button
              key={index}
              className={`w-3 h-3 rounded-full transition-all duration-300 ${
                index === currentIndex ? "bg-white scale-110" : "bg-white/40 hover:bg-white/60"
              }`}
              onClick={() => goToSlide(index)}
            />
          ))}
        </div>
      )}
    </div>
  )
}

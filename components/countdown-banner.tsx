"use client"

import Link from "next/link"
import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Clock, MapPin } from "lucide-react"

interface CountdownBannerProps {
  title: string
  date: string
  location: string
  daysLeft: number
  imageUrl: string
}

export function CountdownBanner({ title, date, location, daysLeft, imageUrl }: CountdownBannerProps) {
  const [remainingDays, setRemainingDays] = useState(daysLeft)

  useEffect(() => {
    const countdownInterval = setInterval(
      () => {
        setRemainingDays((prevDays) => prevDays - 1)
      },
      24 * 60 * 60 * 1000,
    ) // Update every day

    return () => clearInterval(countdownInterval)
  }, [])

  return (
    <div className="relative bg-gradient-to-r from-neutral-900 via-neutral-800 to-neutral-900 overflow-hidden">
      <div
        className="absolute inset-0 opacity-30 bg-cover bg-center"
        style={{ backgroundImage: `url(${imageUrl})` }}
      ></div>

      {/* Overlay con gradiente mejorado */}
      <div className="absolute inset-0 bg-gradient-to-r from-primary-900/80 via-secondary-900/60 to-primary-900/80"></div>

      <div className="container mx-auto px-4 relative z-10 py-6">
        <div className="flex flex-col lg:flex-row items-center justify-between gap-6">
          <div className="flex-1 text-center lg:text-left text-white">
            <div className="flex items-center justify-center lg:justify-start mb-2">
              <Clock className="h-5 w-5 mr-2 text-amber-400" />
              <span className="text-amber-400 font-semibold text-sm uppercase tracking-wide">Evento Próximo</span>
            </div>
            <h3 className="text-2xl lg:text-3xl font-bold mb-2 bg-gradient-to-r from-white to-neutral-200 bg-clip-text text-transparent">
              {title}
            </h3>
            <div className="flex items-center justify-center lg:justify-start text-neutral-300">
              <MapPin className="h-4 w-4 mr-2" />
              <span className="text-sm">
                {date} | {location}
              </span>
            </div>
          </div>

          <div className="flex items-center gap-6">
            {/* Contador mejorado */}
            <div className="bg-gradient-to-r from-amber-400 to-amber-500 text-neutral-900 font-bold px-6 py-4 rounded-xl shadow-glow flex items-center gap-3 border-2 border-amber-300">
              <div className="text-center">
                <div className="text-xs uppercase tracking-wide opacity-80">Faltan</div>
                <div className="text-3xl font-black">{remainingDays}</div>
                <div className="text-xs uppercase tracking-wide opacity-80">Días</div>
              </div>
              <div className="w-px h-12 bg-neutral-900/20"></div>
              <div className="text-lg font-bold">
                ¡No te lo
                <br />
                pierdas!
              </div>
            </div>

            {/* Botón mejorado */}
            <Link href={`/evento/${title.toLowerCase().replace(/ /g, "-")}`}>
              <Button className="bg-gradient-to-r from-primary-500 to-primary-600 hover:from-primary-600 hover:to-primary-700 text-white font-bold px-8 py-4 rounded-xl shadow-glow transition-all duration-300 hover:scale-105 border-2 border-primary-400">
                <span className="flex items-center gap-2">🎫 COMPRAR ENTRADAS</span>
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  )
}

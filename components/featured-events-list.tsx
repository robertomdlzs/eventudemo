import EventCard from "@/components/event-card"
import { Button } from "@/components/ui/button"
import Link from "next/link"
import { ArrowRight } from "lucide-react"
import type { EventData } from "@/lib/events-data"

interface FeaturedEventsListProps {
  events?: EventData[]
}

export function FeaturedEventsList({ events = [] }: FeaturedEventsListProps) {
  // Tomar solo los primeros 3 eventos
  const eventsToDisplay = events.slice(0, 3)

  if (eventsToDisplay.length === 0) {
    return (
      <section className="py-12 md:py-20 bg-gray-50">
        <div className="container mx-auto px-4">
          <div className="text-center">
            <h2 className="text-3xl md:text-4xl font-bold text-neutral-800 mb-4">Eventos Destacados</h2>
            <p className="text-neutral-600">No hay eventos destacados disponibles en este momento</p>
          </div>
        </div>
      </section>
    )
  }

  return (
    <section className="py-12 md:py-20 bg-gray-50">
      <div className="container mx-auto px-4">
        <div className="flex justify-between items-center mb-8">
          <h2 className="text-3xl md:text-4xl font-bold text-neutral-800">Eventos Destacados</h2>
          <Link href="/eventos">
            <Button variant="ghost" className="text-primary-600 hover:text-primary-700 group">
              Ver todos los eventos
              <ArrowRight className="ml-2 h-5 w-5 group-hover:translate-x-1 transition-transform" />
            </Button>
          </Link>
        </div>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {eventsToDisplay.map((event) => (
            <EventCard
              key={event.id}
              title={event.title}
              image={event.image}
              date={event.date}
              location={event.locationDisplay}
              category={event.categoryDisplay}
              slug={event.slug}
              featured={event.featured}
            />
          ))}
        </div>
      </div>
    </section>
  )
}

import { Suspense } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import FeaturedEventsCarousel from "@/components/featured-events-carousel"
import { EventsExplorer } from "@/components/events-explorer"
import { CountdownBanner } from "@/components/countdown-banner"
import { getAllEvents, getFeaturedEvents } from "@/lib/events-data"

async function FeaturedEventsSection() {
  const featuredEvents = await getFeaturedEvents()
  return <FeaturedEventsCarousel events={featuredEvents} />
}

async function EventsExplorerSection() {
  const allEvents = await getAllEvents()
  return <EventsExplorer events={allEvents} />
}

export default function Home() {
  return (
    <div className="min-h-screen bg-neutral-50">
      {/* Header is now handled by app/layout.tsx */}

      <main className="flex-1">
        <section className="py-20 bg-gradient-to-br from-primary-600 via-secondary-600 to-primary-700 text-white relative overflow-hidden">
          <div className="absolute inset-0 bg-[url('/placeholder.svg?height=800&width=1200&text=Pattern')] opacity-5"></div>
          <div className="absolute inset-0 bg-gradient-to-r from-primary-900/20 to-secondary-900/20"></div>
          <div className="container mx-auto px-4 relative z-10">
            <Suspense
              fallback={
                <div className="text-center py-16">
                  <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-white mx-auto mb-8"></div>
                  <h3 className="text-2xl font-bold mb-4">Cargando eventos destacados...</h3>
                  <p className="text-neutral-200 text-lg">Preparando los mejores eventos para ti</p>
                </div>
              }
            >
              <FeaturedEventsSection />
            </Suspense>
          </div>
        </section>

        <div className="relative -mt-4 z-10">
          <CountdownBanner
            title="PANACA VIAJERO BARRANQUILLA"
            date="20 DE JUNIO 2025"
            location="PARQUE NORTE - BARRANQUILLA"
            daysLeft={15}
            imageUrl="/placeholder.svg?height=200&width=1200&text=PANACA+VIAJERO+BARRANQUILLA"
          />
        </div>

        <div className="bg-gradient-to-b from-white to-neutral-50 py-8">
          <Suspense
            fallback={
              <div className="text-center py-20">
                <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-primary-600 mx-auto mb-8"></div>
                <h3 className="text-2xl font-bold text-neutral-700 mb-4">Cargando eventos...</h3>
                <p className="text-neutral-500 text-lg">Explorando los mejores eventos disponibles</p>
              </div>
            }
          >
            <EventsExplorerSection />
          </Suspense>
        </div>

        <section className="py-24 bg-gradient-to-r from-neutral-900 via-neutral-800 to-neutral-900 text-white relative overflow-hidden">
          <div className="absolute inset-0 bg-gradient-to-r from-primary-900/20 to-secondary-900/20"></div>
          <div className="absolute inset-0 bg-[url('/placeholder.svg?height=400&width=1200&text=Newsletter+Pattern')] opacity-5"></div>
          <div className="container mx-auto px-4 relative z-10">
            <div className="max-w-2xl mx-auto text-center">
              <h2 className="text-5xl font-bold mb-8 bg-gradient-to-r from-white via-neutral-100 to-neutral-200 bg-clip-text text-transparent">
                Suscríbete a nuestro boletín
              </h2>
              <p className="text-neutral-300 mb-10 text-xl leading-relaxed">
                Recibe información sobre los próximos eventos y ofertas especiales directamente en tu correo
              </p>
              <div className="flex flex-col sm:flex-row gap-4 max-w-lg mx-auto">
                <Input
                  type="email"
                  placeholder="Tu correo electrónico"
                  className="bg-white/10 backdrop-blur-sm border-white/20 text-white placeholder:text-neutral-400 focus:bg-white/20 focus:border-white/40 transition-all duration-300 h-14 text-lg rounded-xl"
                />
                <Button className="bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-600 hover:to-amber-700 text-neutral-900 font-bold whitespace-nowrap px-10 h-14 shadow-2xl hover:shadow-amber-500/25 transition-all duration-300 hover:scale-105 transform rounded-xl">
                  Suscribirse
                </Button>
              </div>
              <p className="text-neutral-400 text-sm mt-6">
                No spam, solo los mejores eventos. Puedes cancelar en cualquier momento.
              </p>
            </div>
          </div>
        </section>
      </main>
      {/* Footer is now handled by app/layout.tsx */}
    </div>
  )
}

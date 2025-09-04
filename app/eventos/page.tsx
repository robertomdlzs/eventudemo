import { Suspense } from "react"
import SearchBar from "@/components/search-bar"
import { FeaturedEventsCarousel } from "@/components/featured-events-carousel"
import CategoriesGrid from "@/components/categories-grid"
import { EventsExplorer } from "@/components/events-explorer"
import { CountdownBanner } from "@/components/countdown-banner"
import { FeaturedEventsList } from "@/components/featured-events-list"
import { getAllEvents, getFeaturedEvents } from "@/lib/events-data"

async function FeaturedEventsSection() {
  const featuredEvents = await getFeaturedEvents()
  return <FeaturedEventsCarousel events={featuredEvents} />
}

async function AllEventsSection() {
  const allEvents = await getAllEvents()
  return <EventsExplorer events={allEvents} />
}

async function UpcomingEventsSection() {
  const allEvents = await getAllEvents()
  const upcomingEvents = allEvents.filter((event) => {
    const eventDate = new Date(event.startDate || event.date)
    return eventDate > new Date()
  })
  return <FeaturedEventsList events={upcomingEvents} />
}

export default function EventsPage() {
  return (
    <div className="flex flex-col min-h-screen">
      <main className="flex-1">
        <section className="w-full py-12 md:py-24 lg:py-32 bg-gradient-to-r from-pink-500 to-purple-600 text-white">
          <div className="container px-4 md:px-6 text-center">
            <h1 className="text-4xl md:text-5xl font-bold tracking-tighter mb-4">Encuentra tu Próximo Evento</h1>
            <p className="max-w-[700px] mx-auto text-lg md:text-xl mb-8">
              Explora conciertos, festivales, deportes y más.
            </p>
            <div className="max-w-2xl mx-auto">
              <SearchBar />
            </div>
          </div>
        </section>

        <section className="w-full py-12 md:py-24 lg:py-32 bg-gray-100">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl md:text-4xl font-bold text-center mb-10">Eventos Destacados</h2>
            <Suspense
              fallback={
                <div className="text-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600 mx-auto mb-4"></div>
                  <p>Cargando eventos destacados...</p>
                </div>
              }
            >
              <FeaturedEventsSection />
            </Suspense>
          </div>
        </section>

        <section className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl md:text-4xl font-bold text-center mb-10">Explora por Categoría</h2>
            <CategoriesGrid />
          </div>
        </section>

        <section className="w-full py-12 md:py-24 lg:py-32 bg-gray-100">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl md:text-4xl font-bold text-center mb-10">Próximos Eventos</h2>
            <Suspense
              fallback={
                <div className="text-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600 mx-auto mb-4"></div>
                  <p>Cargando próximos eventos...</p>
                </div>
              }
            >
              <UpcomingEventsSection />
            </Suspense>
          </div>
        </section>

        <section className="w-full py-12 md:py-24 lg:py-32">
          <div className="container px-4 md:px-6">
            <h2 className="text-3xl md:text-4xl font-bold text-center mb-10">Todos los Eventos</h2>
            <Suspense
              fallback={
                <div className="text-center py-8">
                  <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600 mx-auto mb-4"></div>
                  <p>Cargando todos los eventos...</p>
                </div>
              }
            >
              <AllEventsSection />
            </Suspense>
          </div>
        </section>

        <CountdownBanner
          title="PANACA VIAJERO BARRANQUILLA"
          date="20 DE JUNIO 2025"
          location="PARQUE NORTE - BARRANQUILLA"
          daysLeft={15}
          imageUrl="/placeholder.svg?height=200&width=1200&text=PANACA+VIAJERO+BARRANQUILLA"
        />
      </main>
    </div>
  )
}

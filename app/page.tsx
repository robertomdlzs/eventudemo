import { Suspense } from 'react'
import { FeaturedEventsList } from '@/components/featured-events-list'
import { EventsExplorer } from '@/components/events-explorer'
import { apiClient } from '@/lib/api-client'

// Deshabilitar prerenderizado para esta página
export const dynamic = 'force-dynamic'
export const revalidate = 0

export default async function HomePage() {
  // Obtener eventos destacados del backend
  let featuredEvents = []
  let allEvents = []
  
         try {
           const featuredResponse = await apiClient.getEvents({ featured: true, limit: 3 })
           if (featuredResponse.success && featuredResponse.data) {
             featuredEvents = featuredResponse.data
           }

           const allResponse = await apiClient.getEvents()
           if (allResponse.success && allResponse.data) {
             allEvents = allResponse.data
           }
         } catch (error) {
           console.error('Error fetching events:', error)
         }
  return (
    <div className="w-full">
      

      {/* Featured Events - Fondo extendido a toda la página */}
      <FeaturedEventsList events={featuredEvents} />

      {/* Events Explorer */}
      <section className="py-12">
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-8">Explora Todos los Eventos</h2>
          <EventsExplorer events={allEvents} />
        </div>
      </section>
    </div>
  )
}
import { Suspense } from 'react'
import { FeaturedEventsList } from '@/components/featured-events-list'
import { EventsExplorer } from '@/components/events-explorer'
import MainHeader from '@/components/main-header'
import { Footer } from '@/components/footer'

// Deshabilitar prerenderizado para esta página
export const dynamic = 'force-dynamic'
export const revalidate = 0

export default function HomePage() {
  return (
    <div className="min-h-screen bg-background">
      <MainHeader />
      
      <main className="container mx-auto px-4 py-8">
        {/* Hero Section */}
        <section className="text-center py-16">
          <h1 className="text-4xl md:text-6xl font-bold text-foreground mb-6">
            Descubre Eventos
            <span className="text-primary block">Increíbles</span>
          </h1>
          <p className="text-xl text-muted-foreground mb-8 max-w-2xl mx-auto">
            Encuentra, compra y disfruta de los mejores eventos en tu ciudad. 
            Desde conciertos hasta conferencias, todo en un solo lugar.
          </p>
        </section>

        {/* Featured Events */}
        <section className="py-12">
          <h2 className="text-3xl font-bold text-center mb-8">Eventos Destacados</h2>
          <Suspense fallback={
            <div className="flex justify-center items-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
          }>
            <FeaturedEventsList />
          </Suspense>
        </section>

        {/* Events Explorer */}
        <section className="py-12">
          <h2 className="text-3xl font-bold text-center mb-8">Explora Todos los Eventos</h2>
          <Suspense fallback={
            <div className="flex justify-center items-center py-12">
              <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
            </div>
          }>
            <EventsExplorer />
          </Suspense>
        </section>
      </main>

      <Footer />
    </div>
  )
}
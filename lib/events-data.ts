export interface Ticket {
  id: string
  name: string
  price: number
  description: string
  available: number
  total: number
  benefits?: string[]
}

export interface EventData {
  id: number
  title: string
  slug: string
  description: string
  longDescription?: string
  image: string
  date: string
  startDate?: string
  time?: string
  venue?: string
  location: string
  locationDisplay: string
  category: string
  categoryDisplay: string
  organizer?: string
  capacity?: number
  soldTickets?: number
  price?: number
  featured?: boolean
  status?: string
  rating?: number
  reviews?: number
  tags?: string[]
  hasSeatMap?: boolean
  tickets?: Ticket[]
}

import { apiClient } from "./api-client"

export async function getAllEvents(): Promise<EventData[]> {
  try {
    const response = await apiClient.getEvents()
    if (response.success && response.data) {
      return response.data.map(transformBackendEvent)
    }
  } catch (error) {
    console.warn("Failed to fetch events from API:", error)
  }

  return []
}

export async function getEventBySlug(slug: string): Promise<EventData | null> {
  try {
    const response = await apiClient.getEvents()
    if (response.success && response.data) {
      const event = response.data.find((e: any) => e.slug === slug)
      return event ? transformBackendEvent(event) : null
    }
  } catch (error) {
    console.warn("Failed to fetch event from API:", error)
  }

  return null
}

// Función para obtener evento con interfaz Event original
export async function getEventBySlugOriginal(slug: string): Promise<any> {
  try {
    const response = await apiClient.getEvents()
    console.log('API Response:', response) // Debug log
    
    if (response.success && response.data) {
      const event = response.data.find((e: any) => e.slug === slug)
      console.log('Found event:', event) // Debug log
      
      if (!event) {
        console.log('Event not found for slug:', slug) // Debug log
        return null
      }
      
      // Obtener categoría
      let categoryName = "General"
      try {
        const categoryResponse = await apiClient.getCategories()
        if (categoryResponse.success && categoryResponse.data) {
          const category = categoryResponse.data.find((c: any) => c.id === event.category_id)
          if (category) {
            categoryName = category.name
          }
        }
      } catch (error) {
        console.warn("Failed to fetch category:", error)
      }
      
      // Transformar a la interfaz Event original
      const transformedEvent = {
        id: event.id.toString(),
        title: event.title,
        description: event.description,
        long_description: event.long_description,
        category: {
          id: event.category_id?.toString() || "1",
          name: categoryName
        },
        date: event.date,
        time: event.time || new Date(event.date).toLocaleTimeString("es-CO", {
          hour: "2-digit",
          minute: "2-digit",
        }),
        venue: event.venue,
        location: event.location || "Bogotá",
        price: parseFloat(event.price) || 0,
        total_capacity: event.total_capacity || 0,
        sold: event.sold_tickets || 0,
        status: event.status || "active",
        image_url: event.image_url || getEventImage(event.title),
        image: event.image_url || getEventImage(event.title),
        video_url: event.video_url || getEventVideo(event.title),
        gallery_images: event.gallery_images || getEventGallery(event.title),
        organizer: {
          id: event.organizer_id?.toString() || "1",
          name: "Eventu"
        },
        tags: [], // Array vacío por defecto
        ticketTypes: [], // Array vacío por defecto - se pueden agregar tipos de boletos después
        seatMapId: event.seat_map_id ? event.seat_map_id.toString() : null,
        featured: event.featured || false,
        slug: event.slug, // Agregar el slug que falta
      }
      
      console.log('Transformed event:', transformedEvent) // Debug log
      return transformedEvent
    } else {
      console.log('API response not successful:', response) // Debug log
    }
  } catch (error) {
    console.error("Failed to fetch event from API:", error) // Cambiar a console.error
  }

  return null
}

export async function getEventById(id: number): Promise<EventData | null> {
  try {
    const response = await apiClient.getEvent(id)
    if (response.success && response.data) {
      return transformBackendEvent(response.data)
    }
  } catch (error) {
    console.warn("Failed to fetch event from API:", error)
  }

  return null
}

export async function getFeaturedEvents(): Promise<EventData[]> {
  try {
    const response = await apiClient.getFeaturedEvents()
    if (response.success && response.data) {
      return response.data.map(transformBackendEvent)
    }
  } catch (error) {
    console.warn("Failed to fetch featured events from API:", error)
  }

  return []
}

export async function getEventsByCategory(category: string): Promise<EventData[]> {
  try {
    const response = await apiClient.getEvents({ category })
    if (response.success && response.data) {
      return response.data.map(transformBackendEvent)
    }
  } catch (error) {
    console.warn("Failed to fetch events by category from API:", error)
  }

  return []
}

function transformBackendEvent(backendEvent: any): EventData {
  return {
    id: backendEvent.id,
    title: backendEvent.title,
    slug: backendEvent.slug || backendEvent.title.toLowerCase().replace(/\s+/g, "-"),
    description: backendEvent.description,
    longDescription: backendEvent.long_description || backendEvent.description,
    image:
      backendEvent.image_url ||
      `/placeholder.svg`,
    date: new Date(backendEvent.date).toLocaleDateString("es-CO", {
      day: "numeric",
      month: "long",
      year: "numeric",
    }),
    startDate: backendEvent.date,
    time:
      backendEvent.time ||
      new Date(backendEvent.date).toLocaleTimeString("es-CO", {
        hour: "2-digit",
        minute: "2-digit",
      }),
    venue: backendEvent.venue,
    location: backendEvent.location || "bogota",
    locationDisplay: backendEvent.location_display || backendEvent.location || "Bogotá, Colombia",
    category: backendEvent.category || "general",
    categoryDisplay: backendEvent.category_display || backendEvent.category || "General",
    organizer: backendEvent.organizer,
    capacity: backendEvent.total_capacity,
    soldTickets: backendEvent.sold_tickets || 0,
    price: backendEvent.price,
    featured: backendEvent.featured || false,
    status: backendEvent.status || "published",
    rating: backendEvent.rating || 4.5,
    reviews: backendEvent.reviews || 0,
    tags: backendEvent.tags || [],
    hasSeatMap: backendEvent.seat_map_id ? true : false,
    tickets: backendEvent.tickets || [],
  }
}

// Funciones para obtener imágenes y videos de ejemplo
function getEventImage(eventTitle: string): string {
  const images = {
    'Romeo y Julieta': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop',
    'Concierto de Rock': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=600&fit=crop',
    'Festival de Jazz': 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800&h=600&fit=crop',
    'Partido de Fútbol': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800&h=600&fit=crop',
    'Conferencia Tech': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&h=600&fit=crop',
    'Festival de Música': 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=800&h=600&fit=crop',
    'Obra de Teatro': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=600&fit=crop',
    'Concierto Clásico': 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800&h=600&fit=crop',
    'Exposición de Arte': 'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=800&h=600&fit=crop',
    'Workshop de Cocina': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800&h=600&fit=crop'
  }
  
  return images[eventTitle as keyof typeof images] || 'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=800&h=600&fit=crop'
}

function getEventVideo(eventTitle: string): string {
  const videos = {
    'Romeo y Julieta': 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    'Concierto de Rock': 'https://www.youtube.com/embed/9bZkp7q19f0',
    'Festival de Jazz': 'https://www.youtube.com/embed/kJQP7kiw5Fk',
    'Partido de Fútbol': 'https://www.youtube.com/embed/9bZkp7q19f0',
    'Conferencia Tech': 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    'Festival de Música': 'https://www.youtube.com/embed/kJQP7kiw5Fk',
    'Obra de Teatro': 'https://www.youtube.com/embed/9bZkp7q19f0',
    'Concierto Clásico': 'https://www.youtube.com/embed/dQw4w9WgXcQ',
    'Exposición de Arte': 'https://www.youtube.com/embed/kJQP7kiw5Fk',
    'Workshop de Cocina': 'https://www.youtube.com/embed/9bZkp7q19f0'
  }
  
  return videos[eventTitle as keyof typeof videos] || 'https://www.youtube.com/embed/dQw4w9WgXcQ'
}

function getEventGallery(eventTitle: string): string[] {
  const galleries = {
    'Romeo y Julieta': [
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop'
    ],
    'Concierto de Rock': [
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=300&fit=crop'
    ],
    'Festival de Jazz': [
      'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=300&fit=crop',
      'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=400&h=300&fit=crop'
    ]
  }
  
  return galleries[eventTitle as keyof typeof galleries] || [
    'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1541961017774-22349e4a1262?w=400&h=300&fit=crop'
  ]
}

// Datos mock temporales para el build de Netlify
// En producción, estos datos vendrán del backend

export interface EventData {
  id: string
  title: string
  slug: string
  description: string
  longDescription?: string
  date: string
  startDate?: string
  time: string
  venue: string
  location: string
  category: {
    id: string
    name: string
  }
  organizer: {
    id: string
    name: string
  }
  totalCapacity: number
  total_capacity: number // Alias para compatibilidad
  capacity: number // Alias para compatibilidad
  sold: number
  soldTickets: number // Alias para compatibilidad
  price: number
  status: "cancelled" | "active" | "inactive"
  featured: boolean
  imageUrl?: string
  image: string // Alias para compatibilidad
  youtubeUrl?: string
  tags: string[]
  rating: number
  locationDisplay: string
  categoryDisplay: string
}

// Datos mock de eventos
const mockEvents: EventData[] = [
  {
    id: "1",
    title: "Rock en la Noche 2025",
    slug: "rock-en-la-noche-2025",
    description: "Festival internacional de rock con las mejores bandas del mundo",
    longDescription: "Un festival épico que reúne a las mejores bandas de rock internacionales en un evento único.",
    date: "2025-06-15",
    startDate: "2025-06-15",
    time: "20:00",
    venue: "Autódromo Hermanos Rodríguez",
    location: "Ciudad de México, México",
    category: {
      id: "1",
      name: "Música"
    },
    organizer: {
      id: "1",
      name: "María González"
    },
    totalCapacity: 50000,
    total_capacity: 50000,
    capacity: 50000,
    sold: 25000,
    soldTickets: 25000,
    price: 1500,
    status: "active",
    featured: true,
    imageUrl: "/placeholder.jpg",
    image: "/placeholder.jpg",
    tags: ["rock", "música", "festival"],
    rating: 4.8,
    locationDisplay: "Ciudad de México, México",
    categoryDisplay: "Música"
  },
  {
    id: "2",
    title: "Tech Summit México 2025",
    slug: "tech-summit-mexico-2025",
    description: "Conferencia de tecnología más importante de México",
    longDescription: "Únete a los líderes de la industria tecnológica en esta conferencia única.",
    date: "2025-07-20",
    startDate: "2025-07-20",
    time: "09:00",
    venue: "Cintermex",
    location: "Monterrey, México",
    category: {
      id: "2",
      name: "Tecnología"
    },
    organizer: {
      id: "2",
      name: "Carlos Rodríguez"
    },
    totalCapacity: 2000,
    total_capacity: 2000,
    capacity: 2000,
    sold: 800,
    soldTickets: 800,
    price: 2500,
    status: "active",
    featured: true,
    imageUrl: "/placeholder.jpg",
    image: "/placeholder.jpg",
    tags: ["tecnología", "conferencia", "innovación"],
    rating: 4.5,
    locationDisplay: "Monterrey, México",
    categoryDisplay: "Tecnología"
  },
  {
    id: "3",
    title: "Clásico Nacional 2025",
    slug: "clasico-nacional-2025",
    description: "América vs Chivas - El clásico más esperado",
    longDescription: "No te pierdas el clásico más importante del fútbol mexicano.",
    date: "2025-08-10",
    startDate: "2025-08-10",
    time: "19:00",
    venue: "Estadio Azteca",
    location: "Ciudad de México, México",
    category: {
      id: "3",
      name: "Deportes"
    },
    organizer: {
      id: "3",
      name: "Ana Martínez"
    },
    totalCapacity: 87000,
    total_capacity: 87000,
    capacity: 87000,
    sold: 45000,
    soldTickets: 45000,
    price: 800,
    status: "active",
    featured: false,
    imageUrl: "/placeholder.jpg",
    image: "/placeholder.jpg",
    tags: ["fútbol", "deportes", "clásico"],
    rating: 4.9,
    locationDisplay: "Ciudad de México, México",
    categoryDisplay: "Deportes"
  }
]

export async function getAllEvents(): Promise<EventData[]> {
  try {
    // Llamada a la API de Vercel
    const response = await fetch('/api/events', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    })
    
    if (!response.ok) {
      throw new Error('Failed to fetch events')
    }
    
    const result = await response.json()
    return result.success ? result.data : mockEvents
  } catch (error) {
    console.warn('Failed to fetch events from API, using mock data:', error)
    return mockEvents
  }
}

export async function getFeaturedEvents(): Promise<EventData[]> {
  try {
    // Llamada a la API de Vercel
    const response = await fetch('/api/events?featured=true', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    })
    
    if (!response.ok) {
      throw new Error('Failed to fetch featured events')
    }
    
    const result = await response.json()
    return result.success ? result.data : mockEvents.filter(event => event.featured)
  } catch (error) {
    console.warn('Failed to fetch featured events from API, using mock data:', error)
    return mockEvents.filter(event => event.featured)
  }
}

export async function getEventBySlug(slug: string): Promise<EventData | null> {
  // En producción, esto haría una llamada al API
  // Por ahora buscamos en los datos mock
  const event = mockEvents.find(event => event.slug === slug)
  return event || null
}

export async function getEventBySlugOriginal(slug: string): Promise<EventData | null> {
  // Alias para compatibilidad
  return getEventBySlug(slug)
}

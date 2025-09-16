import { NextRequest, NextResponse } from 'next/server'

// Datos mock de eventos para la API
const mockEvents = [
  {
    id: "1",
    title: "Rock en la Noche 2025",
    slug: "rock-en-la-noche-2025",
    description: "Festival internacional de rock con las mejores bandas del mundo",
    date: "2025-06-15",
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
    sold: 25000,
    price: 1500,
    status: "active",
    featured: true,
    image: "/placeholder.jpg",
    tags: ["rock", "música", "festival"],
    rating: 4.8
  },
  {
    id: "2",
    title: "Tech Summit México 2025",
    slug: "tech-summit-mexico-2025",
    description: "Conferencia de tecnología más importante de México",
    date: "2025-07-20",
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
    sold: 800,
    price: 2500,
    status: "active",
    featured: true,
    image: "/placeholder.jpg",
    tags: ["tecnología", "conferencia", "innovación"],
    rating: 4.5
  }
]

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url)
    const featured = searchParams.get('featured')
    
    let events = mockEvents
    
    if (featured === 'true') {
      events = mockEvents.filter(event => event.featured)
    }
    
    return NextResponse.json({
      success: true,
      data: events,
      count: events.length
    })
  } catch (error) {
    return NextResponse.json(
      { 
        success: false, 
        error: 'Error fetching events' 
      },
      { status: 500 }
    )
  }
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()
    
    // Simular creación de evento
    const newEvent = {
      id: Date.now().toString(),
      ...body,
      status: "active",
      sold: 0,
      rating: 0,
      createdAt: new Date().toISOString()
    }
    
    return NextResponse.json({
      success: true,
      message: "Event created successfully",
      data: newEvent
    }, { status: 201 })
  } catch (error) {
    return NextResponse.json(
      { 
        success: false, 
        error: 'Error creating event' 
      },
      { status: 500 }
    )
  }
}

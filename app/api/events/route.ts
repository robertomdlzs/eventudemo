import { NextRequest, NextResponse } from 'next/server';

// Mock de eventos para demo
const events = [
  {
    id: 1,
    title: 'Concierto de Rock',
    slug: 'concierto-rock-2024',
    description: 'Un increíble concierto de rock con las mejores bandas del país',
    date: '2024-12-25',
    time: '20:00',
    venue: 'Estadio El Campín',
    location: 'Bogotá, Colombia',
    category: { id: 1, name: 'Música' },
    organizer: { id: 1, name: 'Rock Productions' },
    total_capacity: 50000,
    sold: 25000,
    price: 150000,
    status: 'active',
    featured: true,
    image: '/images/rock-concert.jpg',
    locationDisplay: 'Bogotá, Colombia',
    categoryDisplay: 'Música'
  },
  {
    id: 2,
    title: 'Festival de Comida',
    slug: 'festival-comida-2024',
    description: 'Disfruta de la mejor gastronomía local e internacional',
    date: '2024-12-30',
    time: '12:00',
    venue: 'Parque Simón Bolívar',
    location: 'Bogotá, Colombia',
    category: { id: 2, name: 'Gastronomía' },
    organizer: { id: 2, name: 'Food Events' },
    total_capacity: 10000,
    sold: 5000,
    price: 50000,
    status: 'active',
    featured: true,
    image: '/images/food-festival.jpg',
    locationDisplay: 'Bogotá, Colombia',
    categoryDisplay: 'Gastronomía'
  },
  {
    id: 3,
    title: 'Conferencia de Tecnología',
    slug: 'conferencia-tecnologia-2024',
    description: 'Las últimas tendencias en tecnología y desarrollo',
    date: '2025-01-15',
    time: '09:00',
    venue: 'Centro de Convenciones',
    location: 'Medellín, Colombia',
    category: { id: 3, name: 'Tecnología' },
    organizer: { id: 3, name: 'Tech Events' },
    total_capacity: 2000,
    sold: 800,
    price: 200000,
    status: 'active',
    featured: false,
    image: '/images/tech-conference.jpg',
    locationDisplay: 'Medellín, Colombia',
    categoryDisplay: 'Tecnología'
  }
];

export async function GET(request: NextRequest) {
  try {
    const { searchParams } = new URL(request.url);
    const featured = searchParams.get('featured');
    const limit = searchParams.get('limit');

    let filteredEvents = events;

    // Filtrar eventos destacados
    if (featured === 'true') {
      filteredEvents = events.filter(event => event.featured);
    }

    // Limitar resultados
    if (limit) {
      const limitNum = parseInt(limit);
      filteredEvents = filteredEvents.slice(0, limitNum);
    }

    return NextResponse.json({
      success: true,
      data: filteredEvents,
      total: filteredEvents.length
    });

  } catch (error) {
    console.error('Events API error:', error);
    return NextResponse.json(
      { success: false, message: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}

export async function POST(request: NextRequest) {
  try {
    const eventData = await request.json();

    // Validar datos requeridos
    if (!eventData.title || !eventData.date || !eventData.venue) {
      return NextResponse.json(
        { success: false, message: 'Datos requeridos faltantes' },
        { status: 400 }
      );
    }

    // Crear nuevo evento
    const newEvent = {
      id: events.length + 1,
      ...eventData,
      slug: eventData.title.toLowerCase().replace(/\s+/g, '-'),
      status: 'active',
      featured: false,
      sold: 0,
      created_at: new Date().toISOString()
    };

    events.push(newEvent);

    return NextResponse.json({
      success: true,
      message: 'Evento creado exitosamente',
      data: newEvent
    }, { status: 201 });

  } catch (error) {
    console.error('Create event error:', error);
    return NextResponse.json(
      { success: false, message: 'Error interno del servidor' },
      { status: 500 }
    );
  }
}
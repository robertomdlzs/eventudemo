import type { SeatMapConfig, Seat, SeatMapTemplate } from "./seat-map-types"

// Mock seat map configurations for different venue types
export const mockSeatMaps: SeatMapConfig[] = [
  {
    id: "seat-map-1",
    eventId: "1",
    name: "Teatro Principal - Configuración Estándar",
    venueType: "theater",
    totalCapacity: 450,
    sections: [
      {
        id: "platea-central",
        name: "Platea Central",
        type: "seats",
        x: 200,
        y: 150,
        width: 400,
        height: 200,
        capacity: 200,
        price: 85000,
        color: "#10b981",
        rows: 10,
        seatsPerRow: 20,
        seats: generateSeats("platea-central", 10, 20, 200, 150, 85000),
      },
      {
        id: "palco-izquierdo",
        name: "Palco Izquierdo",
        type: "boxes",
        x: 50,
        y: 120,
        width: 120,
        height: 100,
        capacity: 40,
        price: 120000,
        color: "#f59e0b",
        rows: 4,
        seatsPerRow: 10,
        seats: generateSeats("palco-izquierdo", 4, 10, 50, 120, 120000, "vip"),
      },
      {
        id: "palco-derecho",
        name: "Palco Derecho",
        type: "boxes",
        x: 630,
        y: 120,
        width: 120,
        height: 100,
        capacity: 40,
        price: 120000,
        color: "#f59e0b",
        rows: 4,
        seatsPerRow: 10,
        seats: generateSeats("palco-derecho", 4, 10, 630, 120, 120000, "vip"),
      },
      {
        id: "balcon",
        name: "Balcón",
        type: "seats",
        x: 150,
        y: 80,
        width: 500,
        height: 60,
        capacity: 120,
        price: 65000,
        color: "#6366f1",
        rows: 3,
        seatsPerRow: 40,
        seats: generateSeats("balcon", 3, 40, 150, 80, 65000),
      },
      {
        id: "general",
        name: "Área General",
        type: "general",
        x: 100,
        y: 380,
        width: 600,
        height: 80,
        capacity: 50,
        price: 45000,
        color: "#6b7280",
        rows: 0,
        seatsPerRow: 0,
        seats: [],
      },
    ],
    createdAt: new Date("2024-01-15"),
    updatedAt: new Date("2024-01-20"),
    isPublished: true,
    version: 1,
    metadata: {
      author: "Admin",
      description: "Configuración estándar para teatro con capacidad media",
      tags: ["teatro", "clásico", "estándar"],
    },
  },
  {
    id: "seat-map-2",
    eventId: "2",
    name: "Estadio - Concierto Masivo",
    venueType: "stadium",
    totalCapacity: 2500,
    sections: [
      {
        id: "campo-general",
        name: "Campo General",
        type: "general",
        x: 200,
        y: 200,
        width: 400,
        height: 200,
        capacity: 1000,
        price: 150000,
        color: "#ef4444",
        rows: 0,
        seatsPerRow: 0,
        seats: [],
      },
      {
        id: "tribuna-norte",
        name: "Tribuna Norte",
        type: "seats",
        x: 150,
        y: 100,
        width: 500,
        height: 80,
        capacity: 400,
        price: 120000,
        color: "#3b82f6",
        rows: 5,
        seatsPerRow: 80,
        seats: generateSeats("tribuna-norte", 5, 80, 150, 100, 120000),
      },
      {
        id: "tribuna-sur",
        name: "Tribuna Sur",
        type: "seats",
        x: 150,
        y: 420,
        width: 500,
        height: 80,
        capacity: 400,
        price: 120000,
        color: "#3b82f6",
        rows: 5,
        seatsPerRow: 80,
        seats: generateSeats("tribuna-sur", 5, 80, 150, 420, 120000),
      },
      {
        id: "tribuna-oriental",
        name: "Tribuna Oriental",
        type: "seats",
        x: 720,
        y: 150,
        width: 80,
        height: 300,
        capacity: 350,
        price: 100000,
        color: "#10b981",
        rows: 10,
        seatsPerRow: 35,
        seats: generateSeats("tribuna-oriental", 10, 35, 720, 150, 100000),
      },
      {
        id: "tribuna-occidental",
        name: "Tribuna Occidental",
        type: "seats",
        x: 50,
        y: 150,
        width: 80,
        height: 300,
        capacity: 350,
        price: 100000,
        color: "#10b981",
        rows: 10,
        seatsPerRow: 35,
        seats: generateSeats("tribuna-occidental", 10, 35, 50, 150, 100000),
      },
    ],
    createdAt: new Date("2024-01-10"),
    updatedAt: new Date("2024-01-25"),
    isPublished: true,
    version: 2,
    metadata: {
      author: "Admin",
      description: "Configuración para conciertos masivos en estadio",
      tags: ["estadio", "concierto", "masivo"],
    },
  },
  {
    id: "seat-map-3",
    eventId: "3",
    name: "Salón de Eventos - Cena Gala",
    venueType: "conference",
    totalCapacity: 200,
    sections: [
      {
        id: "mesas-vip",
        name: "Mesas VIP",
        type: "tables",
        x: 100,
        y: 100,
        width: 300,
        height: 150,
        capacity: 80,
        price: 250000,
        color: "#8b5cf6",
        rows: 4,
        seatsPerRow: 5,
        seats: generateSeats("mesas-vip", 4, 5, 100, 100, 250000, "table-unit"),
      },
      {
        id: "mesas-regulares",
        name: "Mesas Regulares",
        type: "tables",
        x: 450,
        y: 100,
        width: 300,
        height: 200,
        capacity: 120,
        price: 180000,
        color: "#8b5cf6",
        rows: 5,
        seatsPerRow: 6,
        seats: generateSeats("mesas-regulares", 5, 6, 450, 100, 180000, "table-unit"),
      },
    ],
    createdAt: new Date("2024-01-12"),
    updatedAt: new Date("2024-01-18"),
    isPublished: true,
    version: 1,
    metadata: {
      author: "Organizer",
      description: "Configuración para cenas de gala y eventos corporativos",
      tags: ["gala", "corporativo", "mesas"],
    },
  },
]

// Mock seat map templates
export const mockSeatMapTemplates: SeatMapTemplate[] = [
  {
    id: "template-theater-small",
    name: "Teatro Pequeño",
    description: "Configuración estándar para teatros de hasta 300 personas",
    category: "theater",
    thumbnail: "/images/template-theater-small.png",
    config: {
      name: "Teatro Pequeño - Plantilla",
      venueType: "theater",
      totalCapacity: 280,
      sections: [
        {
          id: "platea",
          name: "Platea",
          type: "seats",
          x: 150,
          y: 150,
          width: 350,
          height: 160,
          capacity: 160,
          price: 75000,
          color: "#10b981",
          rows: 8,
          seatsPerRow: 20,
          seats: generateSeats("platea", 8, 20, 150, 150, 75000),
        },
        {
          id: "balcon",
          name: "Balcón",
          type: "seats",
          x: 100,
          y: 80,
          width: 450,
          height: 60,
          capacity: 120,
          price: 55000,
          color: "#6366f1",
          rows: 3,
          seatsPerRow: 40,
          seats: generateSeats("balcon", 3, 40, 100, 80, 55000),
        },
      ],
      createdAt: new Date(),
      updatedAt: new Date(),
      isPublished: false,
      version: 1,
    },
  },
  {
    id: "template-concert-hall",
    name: "Sala de Conciertos",
    description: "Configuración para salas de conciertos medianas",
    category: "concert",
    thumbnail: "/images/template-concert-hall.png",
    config: {
      name: "Sala de Conciertos - Plantilla",
      venueType: "concert",
      totalCapacity: 800,
      sections: [
        {
          id: "piso-principal",
          name: "Piso Principal",
          type: "seats",
          x: 100,
          y: 200,
          width: 600,
          height: 200,
          capacity: 500,
          price: 120000,
          color: "#ef4444",
          rows: 20,
          seatsPerRow: 25,
          seats: generateSeats("piso-principal", 20, 25, 100, 200, 120000),
        },
        {
          id: "balcon-superior",
          name: "Balcón Superior",
          type: "seats",
          x: 150,
          y: 100,
          width: 500,
          height: 80,
          capacity: 200,
          price: 90000,
          color: "#3b82f6",
          rows: 5,
          seatsPerRow: 40,
          seats: generateSeats("balcon-superior", 5, 40, 150, 100, 90000),
        },
        {
          id: "palcos-laterales",
          name: "Palcos Laterales",
          type: "boxes",
          x: 50,
          y: 150,
          width: 100,
          height: 100,
          capacity: 100,
          price: 200000,
          color: "#f59e0b",
          rows: 5,
          seatsPerRow: 10,
          seats: generateSeats("palcos-laterales", 5, 10, 50, 150, 200000, "vip"),
        },
      ],
      createdAt: new Date(),
      updatedAt: new Date(),
      isPublished: false,
      version: 1,
    },
  },
  {
    id: "template-conference-room",
    name: "Sala de Conferencias",
    description: "Configuración para eventos corporativos y conferencias",
    category: "conference",
    thumbnail: "/images/template-conference.png",
    config: {
      name: "Sala de Conferencias - Plantilla",
      venueType: "conference",
      totalCapacity: 150,
      sections: [
        {
          id: "mesas-principales",
          name: "Mesas Principales",
          type: "tables",
          x: 100,
          y: 150,
          width: 400,
          height: 200,
          capacity: 120,
          price: 150000,
          color: "#8b5cf6",
          rows: 6,
          seatsPerRow: 5,
          seats: generateSeats("mesas-principales", 6, 5, 100, 150, 150000, "table-unit"),
        },
        {
          id: "area-networking",
          name: "Área de Networking",
          type: "general",
          x: 550,
          y: 150,
          width: 150,
          height: 200,
          capacity: 30,
          price: 80000,
          color: "#6b7280",
          rows: 0,
          seatsPerRow: 0,
          seats: [],
        },
      ],
      createdAt: new Date(),
      updatedAt: new Date(),
      isPublished: false,
      version: 1,
    },
  },
]

// Helper function to generate seats for a section
function generateSeats(
  sectionId: string,
  rows: number,
  seatsPerRow: number,
  startX: number,
  startY: number,
  price: number,
  type: "regular" | "vip" | "accessible" | "table-unit" = "regular",
): Seat[] {
  const seats: Seat[] = []
  const seatSize = 16
  const seatSpacing = 8
  const rowSpacing = 24
  const tableUnitSize = 32
  const tableUnitSpacing = 40

  for (let row = 0; row < rows; row++) {
    const rowLetter = String.fromCharCode(65 + row) // A, B, C, etc.

    for (let seatNum = 1; seatNum <= seatsPerRow; seatNum++) {
      let x: number, y: number

      if (type === "table-unit") {
        x = startX + (seatNum - 1) * tableUnitSpacing
        y = startY + row * tableUnitSpacing
      } else if (type === "vip") {
        x = startX + (seatNum - 1) * (seatSize * 1.5 + seatSpacing)
        y = startY + row * (seatSize * 1.5 + rowSpacing)
      } else {
        x = startX + (seatNum - 1) * (seatSize + seatSpacing)
        y = startY + row * (seatSize + rowSpacing)
      }

      const seat: Seat = {
        id: `${sectionId}_${rowLetter}${seatNum}`,
        row: rowLetter,
        number: seatNum,
        x,
        y,
        status: Math.random() > 0.8 ? "occupied" : Math.random() > 0.9 ? "reserved" : "available",
        price,
        type,
        sectionId,
      }

      seats.push(seat)
    }
  }

  return seats
}

// API-like functions for accessing mock data
export async function getAllSeatMaps(): Promise<SeatMapConfig[]> {
  // Simulate API delay
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMaps
}

export async function getSeatMapById(id: string): Promise<SeatMapConfig | null> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMaps.find((map) => map.id === id) || null
}

export async function getSeatMapByEventId(eventId: string): Promise<SeatMapConfig | null> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMaps.find((map) => map.eventId === eventId) || null
}

export async function getAllSeatMapTemplates(): Promise<SeatMapTemplate[]> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMapTemplates
}

export async function getSeatMapTemplateById(id: string): Promise<SeatMapTemplate | null> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMapTemplates.find((template) => template.id === id) || null
}

export async function getSeatMapTemplatesByCategory(category: string): Promise<SeatMapTemplate[]> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  return mockSeatMapTemplates.filter((template) => template.category === category)
}

// Helper function to get available seats for an event
export async function getAvailableSeats(eventId: string): Promise<Seat[]> {
  await new Promise((resolve) => setTimeout(resolve, 100))
  const seatMap = await getSeatMapByEventId(eventId)
  if (!seatMap) return []

  const availableSeats: Seat[] = []
  seatMap.sections.forEach((section) => {
    section.seats.forEach((seat) => {
      if (seat.status === "available") {
        availableSeats.push(seat)
      }
    })
  })

  return availableSeats
}

// Helper function to get seat statistics
export async function getSeatMapStatistics(eventId: string) {
  await new Promise((resolve) => setTimeout(resolve, 100))
  const seatMap = await getSeatMapByEventId(eventId)
  if (!seatMap) return null

  let totalSeats = 0
  let availableSeats = 0
  let occupiedSeats = 0
  let reservedSeats = 0
  let totalRevenue = 0

  seatMap.sections.forEach((section) => {
    section.seats.forEach((seat) => {
      totalSeats++
      switch (seat.status) {
        case "available":
          availableSeats++
          break
        case "occupied":
          occupiedSeats++
          totalRevenue += seat.price
          break
        case "reserved":
          reservedSeats++
          break
      }
    })
  })

  return {
    totalSeats,
    availableSeats,
    occupiedSeats,
    reservedSeats,
    totalRevenue,
    occupancyRate: totalSeats > 0 ? (occupiedSeats / totalSeats) * 100 : 0,
  }
}

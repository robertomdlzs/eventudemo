import type { SeatMapTemplate } from "./seat-map-types"

// Mock seat map templates for different venue types
export const mockSeatMaps: SeatMapTemplate[] = [
  {
    id: "seat-map-1",
    name: "Teatro Principal - Configuración Estándar",
    description: "Configuración estándar para teatro principal",
    category: "theater",
    thumbnail: "/images/theater-thumb.jpg",
    popularity: 85,
    tags: ["theater", "standard", "popular"],
    config: {},
    sections: []
  },
  {
    id: "seat-map-2",
    name: "Estadio - Concierto Masivo",
    description: "Configuración para concierto masivo en estadio",
    category: "stadium",
    thumbnail: "/images/stadium-thumb.jpg",
    popularity: 95,
    tags: ["stadium", "concert", "massive"],
    config: {},
    sections: []
  },
  {
    id: "seat-map-3",
    name: "Arena - Evento Deportivo",
    description: "Configuración para evento deportivo en arena",
    category: "arena",
    thumbnail: "/images/arena-thumb.jpg",
    popularity: 75,
    tags: ["arena", "sports", "event"],
    config: {},
    sections: []
  }
]
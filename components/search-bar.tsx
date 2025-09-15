"use client"

import type React from "react"
import { useState, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Search, Calendar, MapPin, X } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import EventCard from "@/components/event-card"
import { apiClient } from "@/lib/api-client"

interface SearchEvent {
  id: number
  title: string
  image_url?: string
  date: string
  location: string
  locationDisplay: string
  category: string
  categoryDisplay: string
  price: number
  slug: string
}

export default function SearchBar() {
  const [searchQuery, setSearchQuery] = useState("")
  const [location, setLocation] = useState("all")
  const [category, setCategory] = useState("all")
  const [showResults, setShowResults] = useState(false)
  const [filteredEvents, setFilteredEvents] = useState<SearchEvent[]>([])
  const [allEvents, setAllEvents] = useState<SearchEvent[]>([])
  const [isSearching, setIsSearching] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()

  // Load events from API
  useEffect(() => {
    const loadEvents = async () => {
      setIsLoading(true)
      try {
        const response = await apiClient.getEvents()
        if (response.success && response.data) {
          const events = response.data.map((event: any) => ({
            id: event.id,
            title: event.title,
            image_url: event.image_url,
            date: event.date,
            location: event.location?.toLowerCase() || "bogota",
            locationDisplay: event.location || "BOGOTÁ",
            category: (typeof event.category === 'object' ? event.category.name : event.category)?.toLowerCase() || "general",
            categoryDisplay: typeof event.category === 'object' ? event.category.name : event.category || "General",
            price: event.price,
            slug: event.slug,
          }))
          setAllEvents(events)
        }
      } catch (error) {
        console.error("Error loading events:", error)
      } finally {
        setIsLoading(false)
      }
    }

    loadEvents()
  }, [])

  // Filter events based on search criteria
  useEffect(() => {
    const hasActiveFilters = searchQuery.trim() !== "" || location !== "all" || category !== "all"

    if (!hasActiveFilters) {
      setShowResults(false)
      setIsSearching(false)
      return
    }

    setIsSearching(true)

    const filtered = allEvents.filter((event) => {
      const matchesSearch =
        event.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        event.categoryDisplay.toLowerCase().includes(searchQuery.toLowerCase())
      const matchesCategory = category === "all" || event.category === category
      const matchesLocation = location === "all" || event.location === location

      return matchesSearch && matchesCategory && matchesLocation
    })

    setFilteredEvents(filtered)
    setShowResults(true)
    setIsSearching(false)
  }, [searchQuery, location, category, allEvents])

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault()
    if (searchQuery.trim()) {
      router.push(`/eventos?search=${encodeURIComponent(searchQuery)}`)
    }
  }

  const handleEventClick = (event: SearchEvent) => {
    router.push(`/evento/${event.slug}`)
    setShowResults(false)
  }

  const clearSearch = () => {
    setSearchQuery("")
    setLocation("all")
    setCategory("all")
    setShowResults(false)
  }

  const getUniqueLocations = () => {
    const locations = Array.from(new Set(allEvents.map((event) => event.location)))
    return locations.sort()
  }

  const getUniqueCategories = () => {
    const categories = Array.from(new Set(allEvents.map((event) => 
      typeof event.category === 'object' && event.category && 'name' in event.category 
        ? (event.category as any).name 
        : event.category
    )))
    return categories.sort()
  }

  if (isLoading) {
    return (
      <div className="w-full max-w-4xl mx-auto p-4">
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="animate-pulse">
            <div className="h-12 bg-gray-200 rounded-lg mb-4"></div>
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div className="h-10 bg-gray-200 rounded"></div>
              <div className="h-10 bg-gray-200 rounded"></div>
              <div className="h-10 bg-gray-200 rounded"></div>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="w-full max-w-4xl mx-auto p-4">
      <form onSubmit={handleSearch} className="bg-white rounded-2xl shadow-lg p-6">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
          {/* Search Input */}
          <div className="md:col-span-2 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
            <Input
              type="text"
              placeholder="Buscar eventos..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10"
            />
          </div>

          {/* Location Filter */}
          <Select value={location} onValueChange={setLocation}>
            <SelectTrigger>
              <MapPin className="h-4 w-4 mr-2" />
              <SelectValue placeholder="Ubicación" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todas las ubicaciones</SelectItem>
              {getUniqueLocations().map((loc) => (
                <SelectItem key={loc} value={loc}>
                  {loc.toUpperCase()}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>

          {/* Category Filter */}
          <Select value={category} onValueChange={setCategory}>
            <SelectTrigger>
              <Calendar className="h-4 w-4 mr-2" />
              <SelectValue placeholder="Categoría" />
            </SelectTrigger>
            <SelectContent>
              <SelectItem value="all">Todas las categorías</SelectItem>
              {getUniqueCategories().map((cat) => (
                <SelectItem key={cat} value={cat}>
                  {cat.charAt(0).toUpperCase() + cat.slice(1)}
                </SelectItem>
              ))}
            </SelectContent>
          </Select>
        </div>

        {/* Search Results */}
        {showResults && (
          <div className="mt-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-semibold text-gray-900">
                {isSearching ? "Buscando..." : `${filteredEvents.length} eventos encontrados`}
              </h3>
              <Button
                type="button"
                variant="outline"
                size="sm"
                onClick={clearSearch}
                className="flex items-center gap-2"
              >
                <X className="h-4 w-4" />
                Limpiar
              </Button>
            </div>

            {filteredEvents.length > 0 ? (
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {filteredEvents.slice(0, 6).map((event) => (
                  <div
                    key={event.id}
                    className="bg-gray-50 rounded-lg p-4 cursor-pointer hover:bg-gray-100 transition-colors"
                    onClick={() => handleEventClick(event)}
                  >
                    <div className="aspect-video bg-gray-200 rounded-lg mb-3 flex items-center justify-center">
                      {event.image_url ? (
                        <img
                          src={event.image_url}
                          alt={event.title}
                          className="w-full h-full object-cover rounded-lg"
                        />
                      ) : (
                        <div className="text-gray-500 text-sm text-center">
                          Sin imagen
                        </div>
                      )}
                    </div>
                    <h4 className="font-semibold text-gray-900 mb-1 line-clamp-2">{event.title}</h4>
                    <p className="text-sm text-gray-600 mb-2">{event.locationDisplay}</p>
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-gray-500">{event.categoryDisplay}</span>
                      <span className="font-semibold text-green-600">
                        ${event.price?.toLocaleString() || "Gratis"}
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="text-center py-8">
                <p className="text-gray-500">No se encontraron eventos con los filtros seleccionados</p>
              </div>
            )}
          </div>
        )}
      </form>
    </div>
  )
}


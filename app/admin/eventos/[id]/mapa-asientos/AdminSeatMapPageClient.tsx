"use client"

import type React from "react"
import { useState, useRef, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Separator } from "@/components/ui/separator"
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from "@/components/ui/tooltip"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { Progress } from "@/components/ui/progress"
import { useToast } from "@/hooks/use-toast"
import { Switch } from "@/components/ui/switch"
import {
  MousePointer,
  Move,
  ZoomIn,
  ZoomOut,
  Eye,
  Users,
  MapPin,
  RotateCcw,
  Clock,
  RockingChairIcon as Chair,
  Box,
  Table,
  Edit3,
  Theater,
  Grid3X3,
  RectangleVerticalIcon as Rectangle,
  Pen,
  Hand,
  Maximize,
  DollarSign,
  Calculator,
  Settings,
  Save,
  Trash2,
  Undo,
  Redo,
  BarChart3,
  TrendingUp,
  Layers,
  Palette,
  Zap,
  Target,
  Sparkles,
  Info,
  HelpCircle,
  Keyboard,
  MousePointer2,
  Music,
  Star,
  Crown,
  Tag,
  Shield,
} from "lucide-react"
import { SeatMapManager } from "@/lib/seat-map-manager"
import type { SeatSection, Seat, SeatMapData, SavedTemplate } from "@/lib/seat-map-storage"
import { SeatMapStorage } from "@/lib/seat-map-storage"

interface AdminSeatMapPageClientProps {
  eventId: string
}

type Tool =
  | "select"
  | "move"
  | "draw-single-seat"
  | "draw-seats-area"
  | "draw-stage"
  | "delete"
  | "price-editor"
  | "zoom-in"
  | "zoom-out"
  | "pan"
  | "draw-aisle"

type DrawingMode = "rectangle" | "circle" | "freehand" | "grid" | "curve" | "stadium" | "theater" | "arena"

interface StageConfig {
  x: number
  y: number
  width: number
  height: number
  label: string
  rotation: number
  type: "theater" | "stadium" | "arena" | "concert" | "conference" | "custom"
  shape: "rectangle" | "circle" | "oval" | "trapezoid" | "polygon"
  hasCurtain: boolean
  hasBackdrop: boolean
  hasWings: boolean
  depth: number
  elevation: number
}

interface DrawingState {
  isDrawing: boolean
  startPoint: { x: number; y: number }
  currentPoint: { x: number; y: number }
  previewShape: any
}

interface PricingRule {
  id: string
  name: string
  type: "time-based" | "demand-based" | "hybrid"
  isActive: boolean
  conditions: {
    daysBeforeEvent?: number
    demandThreshold?: number
    timeOfDay?: string
  }
  adjustments: {
    percentage?: number
    fixedAmount?: number
  }
}

export default function AdminSeatMapPageClient({ eventId }: AdminSeatMapPageClientProps) {
  // Estados básicos
  const [selectedTool, setSelectedTool] = useState<Tool>("select")
  const [activeTab, setActiveTab] = useState("tools")
  const [sections, setSections] = useState<SeatSection[]>([])
  const [selectedSection, setSelectedSection] = useState<SeatSection | null>(null)
  const [selectedSeat, setSelectedSeat] = useState<Seat | null>(null)
  const [selectedSeats, setSelectedSeats] = useState<string[]>([])
  const [isStageSelected, setIsStageSelected] = useState(false)
  const [hasUnsavedChanges, setHasUnsavedChanges] = useState(false)
  const [isAutoSaving, setIsAutoSaving] = useState(false)
  const [lastSaved, setLastSaved] = useState<Date | null>(null)
  const [isPublished, setIsPublished] = useState(false)
  const [showShortcuts, setShowShortcuts] = useState(false)
  const [isPreviewMode, setIsPreviewMode] = useState(false)
  const [showGrid, setShowGrid] = useState(true)
  const [showLabels, setShowLabels] = useState(true)
  const [showPrices, setShowPrices] = useState(true)
  const [dynamicPricingEnabled, setDynamicPricingEnabled] = useState(false)
  const [pricingRules, setPricingRules] = useState<PricingRule[]>([])
  const [zoom, setZoom] = useState(1)
  const [pan, setPan] = useState({ x: 0, y: 0 })
  const [gridSize, setGridSize] = useState(20)
  const [strictValidation, setStrictValidation] = useState(false) // Toggle para validación estricta
  const canvasRef = useRef<SVGSVGElement>(null)
  
  // Estado para el dibujo en el lienzo
  const [drawingState, setDrawingState] = useState<DrawingState>({
    isDrawing: false,
    startPoint: { x: 0, y: 0 },
    currentPoint: { x: 0, y: 0 },
    previewShape: null
  })
  const [seatMapManager] = useState(() => new SeatMapManager())
  const [seatMapStorage] = useState(() => new SeatMapStorage())
  const [savedMaps, setSavedMaps] = useState<SeatMapData[]>([])
  const [templates, setTemplates] = useState<SavedTemplate[]>([])
  
  // Templates predefinidos para diferentes tipos de eventos
  const predefinedTemplates = [
    {
      id: "theater-classic",
      name: "Teatro Clásico",
      description: "Teatro tradicional con platea, palcos y balcón",
      type: "theater",
      icon: Theater,
      sections: [
        { name: "Platea", type: "theater-seats", rows: 15, seatsPerRow: 20, price: 80000, color: "#059669" },
        { name: "Palcos Laterales", type: "premium-boxes", rows: 8, seatsPerRow: 4, price: 120000, color: "#EA580C" },
        { name: "Balcón", type: "balcony", rows: 12, seatsPerRow: 18, price: 60000, color: "#7C3AED" },
        { name: "Orquesta", type: "orchestra", rows: 6, seatsPerRow: 16, price: 100000, color: "#7C2D12" }
      ]
    }
  ]
  const [history, setHistory] = useState<any[]>([])
  const [historyIndex, setHistoryIndex] = useState(-1)

  // Stage configuration state
  const [stageConfig, setStageConfig] = useState<StageConfig>({
    x: 300,
    y: 50,
    width: 200,
    height: 40,
    label: "ESCENARIO",
    rotation: 0,
    type: "theater",
    shape: "rectangle",
    hasCurtain: true,
    hasBackdrop: false,
    hasWings: false,
    depth: 20,
    elevation: 0,
  })

  const [formData, setFormData] = useState({
    name: "",
    type: "seats" as "seats" | "boxes" | "tables" | "general",
    capacity: 50,
    price: 50000,
    color: "#3B82F6",
    rows: 5,
    seatsPerRow: 10,
  })

  // Advanced tools configuration with better organization
  const toolCategories = {
    selection: [
      {
        id: "select",
        name: "Seleccionar",
        icon: MousePointer2,
        cursor: "default",
        shortcut: "V",
        description: "Selecciona y edita elementos",
      },
      {
        id: "move",
        name: "Mover",
        icon: Move,
        cursor: "move",
        shortcut: "M",
        description: "Mueve elementos por el lienzo",
      },
    ],
    navigation: [
      {
        id: "pan",
        name: "Navegar",
        icon: Hand,
        cursor: "grab",
        shortcut: "H",
        description: "Navega por el lienzo",
      },
      {
        id: "zoom-in",
        name: "Acercar",
        icon: ZoomIn,
        cursor: "zoom-in",
        shortcut: "+",
        description: "Acerca la vista",
      },
      {
        id: "zoom-out",
        name: "Alejar",
        icon: ZoomOut,
        cursor: "zoom-out",
        shortcut: "-",
        description: "Aleja la vista",
      },
    ],
    drawing: [
      {
        id: "draw-single-seat",
        name: "Asiento Individual",
        icon: Chair,
        cursor: "crosshair",
        shortcut: "S",
        description: "Dibuja asientos individuales",
      },
      {
        id: "draw-seats-area",
        name: "Área de Asientos",
        icon: Grid3X3,
        cursor: "crosshair",
        shortcut: "A",
        description: "Crea múltiples asientos en área",
      },
      {
        id: "draw-stage",
        name: "Escenario",
        icon: Theater,
        cursor: "crosshair",
        shortcut: "T",
        description: "Dibuja el escenario",
      },
      {
        id: "draw-aisle",
        name: "Pasillo",
        icon: Layers,
        cursor: "crosshair",
        shortcut: "P",
        description: "Crea pasillos",
      },
    ],
    editing: [
      {
        id: "delete",
        name: "Eliminar",
        icon: Trash2,
        cursor: "crosshair",
        shortcut: "D",
        description: "Elimina elementos seleccionados",
      },
      {
        id: "price-editor",
        name: "Precios",
        icon: DollarSign,
        cursor: "crosshair",
        shortcut: "P",
        description: "Edita precios de asientos",
      },
    ],
  }

  const sectionTypes = [
    {
      value: "theater-seats",
      label: "Butacas de Teatro",
      icon: Chair,
      color: "#059669",
      description: "Butacas acolchadas con respaldo alto",
      seatShape: "theater-chair",
      spacing: { row: 24, seat: 18 },
    },
    {
      value: "stadium-seats",
      label: "Gradas de Estadio",
      icon: Chair,
      color: "#DC2626",
      description: "Asientos plegables en gradas",
      seatShape: "stadium-seat",
      spacing: { row: 20, seat: 16 },
    },
    {
      value: "premium-boxes",
      label: "Palcos Premium",
      icon: Box,
      color: "#EA580C",
      description: "Palcos exclusivos con servicios premium",
      seatShape: "premium-box",
      spacing: { row: 30, seat: 25 },
    },
    {
      value: "dining-tables",
      label: "Mesas de Cena",
      icon: Table,
      color: "#7C3AED",
      description: "Mesas para eventos gastronómicos",
      seatShape: "dining-chair",
      spacing: { row: 35, seat: 30 },
    },
    {
      value: "accessible-seats",
      label: "Asientos Accesibles",
      icon: Users,
      color: "#0891B2",
      description: "Asientos para personas con movilidad reducida",
      seatShape: "accessible-seat",
      spacing: { row: 40, seat: 35 },
    },
    {
      value: "standing-area",
      label: "Área de Pie",
      icon: Users,
      color: "#4B5563",
      description: "Área de pie sin asientos asignados",
      seatShape: "standing",
      spacing: { row: 0, seat: 0 },
    },
    {
      value: "balcony",
      label: "Balcón",
      icon: Rectangle,
      color: "#059669",
      description: "Balcón elevado con vista panorámica",
      seatShape: "balcony-seat",
      spacing: { row: 22, seat: 18 },
    },
    {
      value: "orchestra",
      label: "Orquesta",
      icon: Chair,
      color: "#7C2D12",
      description: "Área de orquesta con asientos especiales",
      seatShape: "orchestra-seat",
      spacing: { row: 20, seat: 16 },
    },
  ]

  const { toast } = useToast()

  // Funciones de manejo del lienzo
  const handleMouseDown = (e: React.MouseEvent<SVGSVGElement>) => {
    const rect = e.currentTarget.getBoundingClientRect()
    const x = (e.clientX - rect.left) / zoom
    const y = (e.clientY - rect.top) / zoom
    
    switch (selectedTool) {
      case "select":
        handleSelectClick(x, y)
        return
      case "delete":
        handleDeleteClick(x, y)
        return
      case "move":
        handleMoveStart(x, y)
        return
      case "pan":
        handlePanStart(x, y)
        return
      case "draw-single-seat":
      case "draw-seats-area":
      case "draw-stage":
      case "draw-aisle":
        setDrawingState({
          isDrawing: true,
          startPoint: { x, y },
          currentPoint: { x, y },
          previewShape: null
        })
        break
      default:
        return
    }
  }

  const handleMouseMove = (e: React.MouseEvent<SVGSVGElement>) => {
    if (!drawingState.isDrawing) return
    
    const rect = e.currentTarget.getBoundingClientRect()
    const x = (e.clientX - rect.left) / zoom
    const y = (e.clientY - rect.top) / zoom
    
    switch (selectedTool) {
      case "move":
        handleMoveUpdate(x, y)
        break
      case "pan":
        handlePanUpdate(x, y)
        break
      case "draw-single-seat":
      case "draw-seats-area":
      case "draw-stage":
      case "draw-aisle":
        setDrawingState(prev => ({
          ...prev,
          currentPoint: { x, y },
          previewShape: generatePreviewShape(prev.startPoint, { x, y })
        }))
        break
    }
  }

  const handleMouseUp = (e: React.MouseEvent<SVGSVGElement>) => {
    if (!drawingState.isDrawing) return
    
    const rect = e.currentTarget.getBoundingClientRect()
    const x = (e.clientX - rect.left) / zoom
    const y = (e.clientY - rect.top) / zoom
    
    handleDrawingComplete(drawingState.startPoint, { x, y })
    setDrawingState({
      isDrawing: false,
      startPoint: { x: 0, y: 0 },
      currentPoint: { x: 0, y: 0 },
      previewShape: null
    })
  }

  const handleWheel = (e: React.WheelEvent<SVGSVGElement>) => {
    e.preventDefault()
    const delta = e.deltaY > 0 ? 0.9 : 1.1
    setZoom(prev => Math.min(Math.max(prev * delta, 0.3), 3))
  }

  // Atajos de teclado
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === 'Delete' || e.key === 'Backspace') {
        e.preventDefault()
        if (selectedSeat) {
          // Eliminar asiento seleccionado
          setSections(prev => prev.map(section => 
            section.id === selectedSeat.sectionId
              ? { ...section, seats: section.seats?.filter(s => s.id !== selectedSeat.id) || [] }
              : section
          ))
          setSelectedSeat(null)
          setHasUnsavedChanges(true)
          toast({
            title: "Asiento eliminado",
            description: `Asiento ${selectedSeat.number} eliminado`,
            variant: "destructive"
          })
        } else if (selectedSection && selectedSection.id !== "general") {
          // Eliminar sección seleccionada
          setSections(prev => prev.filter(s => s.id !== selectedSection.id))
          setSelectedSection(null)
          setHasUnsavedChanges(true)
          toast({
            title: "Sección eliminada",
            description: `Sección "${selectedSection.name}" eliminada`,
            variant: "destructive"
          })
        }
      }
    }

    window.addEventListener('keydown', handleKeyDown)
    return () => window.removeEventListener('keydown', handleKeyDown)
  }, [selectedSeat, selectedSection, toast])

  const handleZoomIn = () => {
    setZoom(prev => Math.min(prev * 1.2, 3))
  }

  const handleZoomOut = () => {
    setZoom(prev => Math.max(prev / 1.2, 0.3))
  }

  const generatePreviewShape = (start: { x: number; y: number }, current: { x: number; y: number }) => {
    const width = Math.abs(current.x - start.x)
    const height = Math.abs(current.y - start.y)
    const x = Math.min(start.x, current.x)
    const y = Math.min(start.y, current.y)

    switch (selectedTool) {
      case "draw-single-seat":
        return (
          <rect
            x={x}
            y={y}
            width={20}
            height={20}
            fill="rgba(16, 185, 129, 0.8)"
            stroke="#10B981"
            strokeWidth="2"
            rx="3"
          />
        )
      case "draw-seats-area":
        return (
          <rect
            x={x}
            y={y}
            width={width}
            height={height}
            fill="rgba(16, 185, 129, 0.3)"
            stroke="#10B981"
            strokeWidth="2"
            strokeDasharray="5,5"
            rx="3"
          />
        )
      case "draw-stage":
        return (
          <rect
            x={x}
            y={y}
            width={width}
            height={height}
            fill="rgba(30, 41, 59, 0.3)"
            stroke="#1E293B"
            strokeWidth="2"
            strokeDasharray="5,5"
            rx="8"
          />
        )
      case "draw-aisle":
        return (
          <rect
            x={x}
            y={y}
            width={width}
            height={height}
            fill="rgba(156, 163, 175, 0.3)"
            stroke="#9CA3AF"
            strokeWidth="2"
            strokeDasharray="10,5"
            rx="2"
          />
        )
      default:
        return null
    }
  }

  const handleDrawingComplete = (start: { x: number; y: number }, end: { x: number; y: number }) => {
    const width = Math.abs(end.x - start.x)
    const height = Math.abs(end.y - start.y)
    const x = Math.min(start.x, end.x)
    const y = Math.min(start.y, end.y)

    // Validación opcional según preferencia del usuario
    if (strictValidation) {
      let minSize = 10 // Tamaño mínimo por defecto
      
      switch (selectedTool) {
        case "draw-aisle":
          minSize = 5 // Los pasillos pueden ser muy delgados
          break
        case "draw-curve":
          minSize = 8 // Las curvas pueden ser pequeñas
          break
        case "draw-pattern":
          minSize = 15 // Los patrones necesitan un poco más de espacio
          break
        default:
          minSize = 10 // Para secciones y asientos
      }
      
      if (width < minSize || height < minSize) {
        toast({
          title: "Dimensión muy pequeña",
          description: `El área debe ser al menos de ${minSize}x${minSize} píxeles para ${selectedTool}`,
          variant: "destructive"
        })
        return
      }
    }

    switch (selectedTool) {
      case "draw-single-seat":
        createSingleSeat(x, y)
        break
      case "draw-seats-area":
        createSeatsArea(x, y, width, height)
        break
      case "draw-stage":
        updateStageConfig(x, y, width, height)
        break
      case "draw-aisle":
        createAisle(x, y, width, height)
        break
    }
  }

  const createSection = (x: number, y: number, width: number, height: number) => {
    const newSection: SeatSection = {
      id: `section-${Date.now()}`,
      name: `Sección ${sections.length + 1}`,
      type: formData.type,
      position: { x, y },
      dimensions: { width, height },
      capacity: formData.capacity,
      price: formData.price,
      color: formData.color,
      seats: [],
      isSelected: false
    }
    
    setSections(prev => [...prev, newSection])
    setSelectedSection(newSection)
    setHasUnsavedChanges(true)
    
    toast({
      title: "Sección creada",
      description: `Sección "${newSection.name}" creada exitosamente`,
    })
  }

  const createSingleSeat = (x: number, y: number) => {
    // Crear un asiento individual directamente en el lienzo
    const newSeat: Seat = {
      id: `seat-${Date.now()}`,
      row: "1",
      number: (sections.reduce((total, s) => total + (s.seats?.length || 0), 0) + 1).toString(),
      type: "regular",
      status: "available",
      price: formData.price,
      position: { x, y },
      sectionId: "general"
    }
    
    // Crear una sección general si no existe
    let generalSection = sections.find(s => s.id === "general")
    if (!generalSection) {
      generalSection = {
        id: "general",
        name: "Asientos Generales",
        type: "seats",
        position: { x: 0, y: 0 },
        dimensions: { width: 1000, height: 1000 },
        capacity: 1000,
        price: formData.price,
        color: "#6B7280",
        seats: [],
        isSelected: false
      }
      setSections(prev => [...prev, generalSection!])
    }
    
    // Agregar el asiento a la sección general
    setSections(prev => prev.map(s => 
      s.id === "general" 
        ? { ...s, seats: [...(s.seats || []), newSeat] }
        : s
    ))
    
    setHasUnsavedChanges(true)
    toast({
      title: "Asiento creado",
      description: `Asiento individual creado en posición (${Math.round(x)}, ${Math.round(y)})`,
    })
  }

  const createSeatsArea = (x: number, y: number, width: number, height: number) => {
    // Crear una sección general si no existe
    let generalSection = sections.find(s => s.id === "general")
    if (!generalSection) {
      generalSection = {
        id: "general",
        name: "Asientos Generales",
        type: "seats",
        position: { x: 0, y: 0 },
        dimensions: { width: 1000, height: 1000 },
        capacity: 1000,
        price: formData.price,
        color: "#6B7280",
        seats: [],
        isSelected: false
      }
      setSections(prev => [...prev, generalSection!])
    }

    const seatSize = 16
    const spacing = 4
    const rows = Math.floor(height / (seatSize + spacing))
    const seatsPerRow = Math.floor(width / (seatSize + spacing))
    
    const newSeats: Seat[] = []
    let seatNumber = 1
    
    for (let row = 0; row < rows; row++) {
      for (let col = 0; col < seatsPerRow; col++) {
        const seat: Seat = {
          id: `seat-${Date.now()}-${seatNumber}`,
          row: (row + 1).toString(),
          number: seatNumber.toString(),
          type: "regular",
          status: "available",
          price: formData.price,
          position: {
            x: x + col * (seatSize + spacing),
            y: y + row * (seatSize + spacing)
          },
          sectionId: "general"
        }
        newSeats.push(seat)
        seatNumber++
      }
    }

    // Agregar asientos a la sección general
    setSections(prev => prev.map(s => 
      s.id === "general" 
        ? { ...s, seats: [...(s.seats || []), ...newSeats] }
        : s
    ))
    
    setHasUnsavedChanges(true)
    toast({
      title: "Asientos creados",
      description: `${newSeats.length} asientos creados en área`,
    })
  }

  const updateStageConfig = (x: number, y: number, width: number, height: number) => {
    setStageConfig(prev => ({
      ...prev,
      x,
      y,
      width,
      height
    }))
    setHasUnsavedChanges(true)
    toast({
      title: "Escenario actualizado",
      description: "Configuración del escenario actualizada",
    })
  }

  const createCurvedSection = (x: number, y: number, width: number, height: number) => {
    const newSection: SeatSection = {
      id: `curve-${Date.now()}`,
      name: `Curva ${sections.length + 1}`,
      type: "seats",
      position: { x, y },
      dimensions: { width, height },
      color: "#7C3AED",
      price: formData.price,
      capacity: Math.floor((width * height) / 400),
      seats: [],
      isSelected: false
    }
    
    setSections(prev => [...prev, newSection])
    setSelectedSection(newSection)
    setHasUnsavedChanges(true)
    
    toast({
      title: "Sección curva creada",
      description: `Sección curva "${newSection.name}" creada exitosamente`,
    })
  }

  const createAisle = (x: number, y: number, width: number, height: number) => {
    // Crear un pasillo como elemento visual
    const newAisle = {
      id: `aisle-${Date.now()}`,
      x,
      y,
      width,
      height,
      type: "aisle"
    }
    
    // Agregar el pasillo a la lista de elementos del lienzo
    setSections(prev => {
      const generalSection = prev.find(s => s.id === "general")
      if (generalSection) {
        return prev.map(s => 
          s.id === "general" 
            ? { ...s, aisles: [...(s.aisles || []), newAisle] }
            : s
        )
      }
      return prev
    })
    
    setHasUnsavedChanges(true)
    toast({
      title: "Pasillo creado",
      description: "Pasillo agregado al lienzo",
    })
  }

  const createPatternSection = (x: number, y: number, width: number, height: number) => {
    const newSection: SeatSection = {
      id: `pattern-${Date.now()}`,
      name: `Patrón ${sections.length + 1}`,
      type: "seats",
      position: { x, y },
      dimensions: { width, height },
      color: "#F59E0B",
      price: formData.price,
      capacity: Math.floor((width * height) / 400),
      seats: [],
      isSelected: false
    }
    
    setSections(prev => [...prev, newSection])
    setSelectedSection(newSection)
    setHasUnsavedChanges(true)
    
    toast({
      title: "Sección con patrón creada",
      description: `Sección con patrón "${newSection.name}" creada exitosamente`,
    })
  }

  const handleSectionClick = (section: SeatSection) => {
    setSelectedSection(section)
    setFormData({
      name: section.name,
      type: section.type,
      capacity: section.capacity,
      price: section.price,
      color: section.color,
      rows: 5,
      seatsPerRow: 10
    })
  }

  const handleStageClick = () => {
    setIsStageSelected(true)
    setSelectedSection(null)
  }

  // Funciones para herramientas de selección y navegación
  const handleSelectClick = (x: number, y: number) => {
    // Buscar si se hizo click en una sección
    const clickedSection = sections.find(section => 
      x >= section.position.x && x <= section.position.x + section.dimensions.width &&
      y >= section.position.y && y <= section.position.y + section.dimensions.height
    )
    
    if (clickedSection) {
      handleSectionClick(clickedSection)
    } else {
      // Deseleccionar todo
      setSelectedSection(null)
      setSelectedSeat(null)
      setIsStageSelected(false)
    }
  }

  const handleDeleteClick = (x: number, y: number) => {
    console.log("🔴 handleDeleteClick llamado con:", { x, y })
    console.log("🔴 Herramienta seleccionada:", selectedTool)
    console.log("🔴 Secciones disponibles:", sections)
    console.log("🔴 Coordenadas del click:", { x, y })
    
    // Buscar si se hizo click en un asiento
    const clickedSeat = sections.flatMap(section => 
      section.seats?.map(seat => ({ ...seat, sectionId: section.id })) || []
    ).find(seat => 
      x >= seat.position.x && x <= seat.position.x + 16 &&
      y >= seat.position.y && y <= seat.position.y + 16
    )
    
    console.log("🔴 Asiento encontrado:", clickedSeat)
    
    if (clickedSeat) {
      console.log("🔴 Eliminando asiento:", clickedSeat)
      // Eliminar el asiento
      setSections(prev => prev.map(section => 
        section.id === clickedSeat.sectionId
          ? { ...section, seats: section.seats?.filter(s => s.id !== clickedSeat.id) || [] }
          : section
      ))
      
      setHasUnsavedChanges(true)
      toast({
        title: "Asiento eliminado",
        description: `Asiento ${clickedSeat.number} eliminado`,
        variant: "destructive"
      })
    } else {
      // Buscar si se hizo click en una sección
      console.log("🔴 Buscando sección en coordenadas:", { x, y })
      
      // Mejorar la detección de secciones con un margen de tolerancia
      const clickedSection = sections.find(section => {
        const sectionBounds = {
          left: section.position.x,
          right: section.position.x + section.dimensions.width,
          top: section.position.y,
          bottom: section.position.y + section.dimensions.height
        }
        
        const isInside = x >= sectionBounds.left && x <= sectionBounds.right &&
                        y >= sectionBounds.top && y <= sectionBounds.bottom
        
        console.log("🔴 Verificando sección:", section.name, {
          bounds: sectionBounds,
          click: { x, y },
          isInside,
          isGeneral: section.id === "general"
        })
        
        return isInside
      })
      
      console.log("🔴 Sección encontrada:", clickedSection)
      
      if (clickedSection && clickedSection.id !== "general") {
        console.log("🔴 Eliminando sección:", clickedSection)
        // Eliminar la sección (excepto la general)
        setSections(prev => {
          const newSections = prev.filter(s => s.id !== clickedSection.id)
          console.log("🔴 Secciones después de eliminar:", newSections)
          return newSections
        })
        setSelectedSection(null)
        setHasUnsavedChanges(true)
        
        toast({
          title: "Sección eliminada",
          description: `Sección "${clickedSection.name}" eliminada`,
          variant: "destructive"
        })
      } else if (clickedSection && clickedSection.id === "general") {
        console.log("🔴 No se puede eliminar la sección general")
        toast({
          title: "Sección protegida",
          description: "La sección 'General' no se puede eliminar",
          variant: "destructive"
        })
      } else {
        console.log("🔴 Nada para eliminar en coordenadas:", { x, y })
        toast({
          title: "Nada para eliminar",
          description: "Click en un asiento o sección para eliminarlo",
          variant: "destructive"
        })
      }
    }
  }

  const handleMoveStart = (x: number, y: number) => {
    if (selectedSection || selectedSeat) {
      setDrawingState({
        isDrawing: true,
        startPoint: { x, y },
        currentPoint: { x, y },
        previewShape: null
      })
    } else {
      toast({
        title: "Nada seleccionado",
        description: "Selecciona un elemento antes de moverlo",
        variant: "destructive"
      })
    }
  }

  const handlePanStart = (x: number, y: number) => {
    setDrawingState({
      isDrawing: true,
      startPoint: { x, y },
      currentPoint: { x, y },
      previewShape: null
    })
  }

  const handleMoveUpdate = (x: number, y: number) => {
    if (selectedSection) {
      const deltaX = x - drawingState.startPoint.x
      const deltaY = y - drawingState.startPoint.y
      
      setSections(prev => prev.map(s => 
        s.id === selectedSection.id 
          ? { 
              ...s, 
              position: { 
                x: s.position.x + deltaX, 
                y: s.position.y + deltaY 
              } 
            }
          : s
      ))
      
      setDrawingState(prev => ({
        ...prev,
        startPoint: { x, y },
        currentPoint: { x, y }
      }))
    }
  }

  const handlePanUpdate = (x: number, y: number) => {
    const deltaX = x - drawingState.startPoint.x
    const deltaY = y - drawingState.startPoint.y
    
    setPan(prev => ({
      x: prev.x + deltaX,
      y: prev.y + deltaY
    }))
    
    setDrawingState(prev => ({
      ...prev,
      startPoint: { x, y },
      currentPoint: { x, y }
    }))
  }

  // Función para renderizar asientos
  const renderSeat = (seat: Seat, section: SeatSection) => {
    const seatSize = 16
    const fill = seat.status === "available" ? section.color : "#94A3B8"
    const stroke = selectedSeat?.id === seat.id ? "#EF4444" : "#1E293B"
    const strokeWidth = selectedSeat?.id === seat.id ? "3" : "1"
    const className = "cursor-pointer hover:opacity-80 transition-all duration-200"
    const title = `${section.name} - Fila ${seat.row} Asiento ${seat.number} - ${formatPrice(seat.price)}`

    return (
      <g key={seat.id} onClick={(e) => handleSeatClick(seat, section, e)}>
        <rect
          x={seat.position.x}
          y={seat.position.y}
          width={seatSize}
          height={seatSize}
          fill={fill}
          stroke={stroke}
          strokeWidth={strokeWidth}
          rx="3"
          className={className}
          filter="url(#seatShadow)"
        >
          <title>{title}</title>
        </rect>
        <text
          x={seat.position.x + seatSize / 2}
          y={seat.position.y + seatSize / 2 + 4}
          textAnchor="middle"
          fontSize="10"
          fill="white"
          fontWeight="bold"
          className="pointer-events-none"
        >
          {seat.number}
        </text>
      </g>
    )
  }

  const handleSeatClick = (seat: Seat, section: SeatSection, e: React.MouseEvent) => {
    e.stopPropagation()
    setSelectedSeat(seat)
    setSelectedSection(section)
  }

  // Funciones básicas
  const handleSave = async () => {
    try {
      await seatMapManager.save()
      setLastSaved(new Date())
      setHasUnsavedChanges(false)
      toast({
        title: "Éxito",
        description: "Mapa guardado exitosamente",
      })
    } catch (error) {
      toast({
        title: "Error",
        description: "Error al guardar el mapa",
        variant: "destructive",
      })
    }
  }

  const applyTemplate = (template: any) => {
    if (confirm(`¿Aplicar template "${template.name}"? Esto reemplazará el mapa actual.`)) {
      toast({
        title: "Template aplicado",
        description: `El template "${template.name}" ha sido aplicado exitosamente.`,
      })
    }
  }

  const undo = () => {
    // Implementar lógica de deshacer
  }

  const redo = () => {
    // Implementar lógica de rehacer
  }

  const handleZoom = (direction: "in" | "out") => {
    if (direction === "in") {
      setZoom(prev => Math.min(prev * 1.2, 3))
    } else {
      setZoom(prev => Math.max(prev / 1.2, 0.3))
    }
  }

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat("es-CO", {
      style: "currency",
      currency: "COP",
      minimumFractionDigits: 0,
    }).format(price)
  }

  const getCompletionPercentage = () => {
    return Math.min(100, sections.length * 20 + 30)
  }

  return (
    <TooltipProvider>
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50">
        {/* Header */}
        <div className="bg-white/80 backdrop-blur-sm border-b border-slate-200/60 sticky top-0 z-50">
          <div className="px-6 py-2">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-xl flex items-center justify-center">
                    <MapPin className="h-5 w-5 text-white" />
                  </div>
                  <div>
                    <h1 className="text-2xl font-bold bg-gradient-to-r from-slate-900 to-slate-700 bg-clip-text text-transparent">
                      Editor de Mapas de Asientos
                    </h1>
                    <p className="text-sm text-slate-600">
                      Herramienta profesional para diseñar mapas y gestionar precios
                    </p>
                  </div>
                </div>
              </div>

              <div className="flex items-center gap-3">
                <Button onClick={handleSave} size="sm" className="bg-blue-600 hover:bg-blue-700">
                  <Save className="h-4 w-4 mr-2" />
                  Guardar
                </Button>
              </div>
            </div>
          </div>
        </div>

        {/* Barra de Herramientas Superior */}
        <div className="bg-white/95 backdrop-blur-sm border-b border-slate-200/60 shadow-sm">
          <div className="px-6 py-3">
            <div className="flex items-center justify-between">
              <Tabs value={activeTab} onValueChange={setActiveTab} className="w-full">
                <TabsList className="grid w-full grid-cols-4 mb-0">
                  <TabsTrigger value="tools" className="text-sm">
                    <MousePointer className="h-4 w-4 mr-2" />
                    Herramientas
                  </TabsTrigger>
                  <TabsTrigger value="pricing" className="text-sm">
                    <DollarSign className="h-4 w-4 mr-2" />
                    Precios
                  </TabsTrigger>
                  <TabsTrigger value="view" className="text-sm">
                    <Eye className="h-4 w-4 mr-2" />
                    Vista
                  </TabsTrigger>
                  <TabsTrigger value="stats" className="text-sm">
                    <BarChart3 className="h-4 w-4 mr-2" />
                    Stats
                  </TabsTrigger>
                </TabsList>

                <div className="mt-4">
                  <TabsContent value="tools" className="space-y-0">
                    <div className="flex flex-wrap gap-2">
                      {/* Herramientas de Selección */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Selección:</span>
                        {toolCategories.selection.map((tool) => {
                          const Icon = tool.icon
                          return (
                            <Button
                              key={tool.id}
                              variant={selectedTool === tool.id ? "default" : "ghost"}
                              size="sm"
                              className={`h-8 px-3 transition-all duration-200 ${
                                selectedTool === tool.id ? "bg-blue-600 text-white shadow-md" : "hover:bg-slate-100"
                              }`}
                              onClick={() => setSelectedTool(tool.id as Tool)}
                            >
                              <Icon className="h-4 w-4 mr-1" />
                              <span className="text-xs">{tool.name}</span>
                            </Button>
                          )
                        })}
                      </div>

                      {/* Herramientas de Navegación */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Navegación:</span>
                        {toolCategories.navigation.map((tool) => {
                          const Icon = tool.icon
                          if (tool.id === "zoom-in") {
                            return (
                              <Button
                                key={tool.id}
                                variant="ghost"
                                size="sm"
                                className="h-8 px-3 transition-all duration-200 hover:bg-slate-100"
                                onClick={handleZoomIn}
                              >
                                <Icon className="h-4 w-4 mr-1" />
                                <span className="text-xs">{tool.name}</span>
                              </Button>
                            )
                          } else if (tool.id === "zoom-out") {
                            return (
                              <Button
                                key={tool.id}
                                variant="ghost"
                                size="sm"
                                className="h-8 px-3 transition-all duration-200 hover:bg-slate-100"
                                onClick={handleZoomOut}
                              >
                                <Icon className="h-4 w-4 mr-1" />
                                <span className="text-xs">{tool.name}</span>
                              </Button>
                            )
                          } else {
                            return (
                              <Button
                                key={tool.id}
                                variant={selectedTool === tool.id ? "default" : "ghost"}
                                size="sm"
                                className={`h-8 px-3 transition-all duration-200 ${
                                  selectedTool === tool.id ? "bg-green-600 text-white shadow-md" : "hover:bg-slate-100"
                                }`}
                                onClick={() => setSelectedTool(tool.id as Tool)}
                              >
                                <Icon className="h-4 w-4 mr-1" />
                                <span className="text-xs">{tool.name}</span>
                              </Button>
                            )
                          }
                        })}
                      </div>

                      {/* Herramientas de Dibujo */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Dibujo:</span>
                        {toolCategories.drawing.map((tool) => {
                          const Icon = tool.icon
                          return (
                            <Button
                              key={tool.id}
                              variant={selectedTool === tool.id ? "default" : "ghost"}
                              size="sm"
                              className={`h-8 px-3 transition-all duration-200 ${
                                selectedTool === tool.id ? "bg-purple-600 text-white shadow-md" : "hover:bg-slate-100"
                              }`}
                              onClick={() => setSelectedTool(tool.id as Tool)}
                            >
                              <Icon className="h-4 w-4 mr-1" />
                              <span className="text-xs">{tool.name}</span>
                            </Button>
                          )
                        })}
                      </div>

                      {/* Herramientas de Edición */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Edición:</span>
                        {toolCategories.editing.map((tool) => {
                          const Icon = tool.icon
                          return (
                            <Button
                              key={tool.id}
                              variant={selectedTool === tool.id ? "default" : "ghost"}
                              size="sm"
                              className={`h-8 px-3 transition-all duration-200 ${
                                selectedTool === tool.id ? "bg-orange-600 text-white shadow-md" : "hover:bg-slate-100"
                              }`}
                              onClick={() => setSelectedTool(tool.id as Tool)}
                            >
                              <Icon className="h-4 w-4 mr-1" />
                              <span className="text-xs">{tool.name}</span>
                            </Button>
                          )
                        })}
                      </div>

                      {/* Botón de Prueba de Eliminación */}
                      <div className="flex items-center gap-2 bg-red-50 rounded-lg p-2 border border-red-200">
                        <span className="text-xs font-medium text-red-600 mr-2">Prueba:</span>
                        <Button
                          variant="destructive"
                          size="sm"
                          className="h-8 px-3"
                          onClick={() => {
                            console.log("🧪 Botón de prueba de eliminación clickeado")
                            console.log("🧪 Secciones actuales:", sections)
                            console.log("🧪 Herramienta seleccionada:", selectedTool)
                            
                            // Crear una sección de prueba si no hay ninguna
                            if (sections.length === 0) {
                              console.log("🧪 Creando sección de prueba...")
                              const testSection: SeatSection = {
                                id: "test-section-1",
                                name: "Sección de Prueba",
                                type: "seats",
                                position: { x: 100, y: 100 },
                                dimensions: { width: 200, height: 150 },
                                color: "#EF4444",
                                price: 75000,
                                capacity: 50,
                                seats: [],
                                isSelected: false
                              }
                              
                              setSections([testSection])
                              
                              toast({
                                title: "Sección de prueba creada",
                                description: "Se creó una sección de prueba para probar la eliminación",
                                variant: "default"
                              })
                            } else if (sections.length === 1 && sections[0].id === "general" && (!sections[0].seats || sections[0].seats.length === 0)) {
                              // Si solo hay la sección general sin asientos, crear una sección adicional
                              console.log("🧪 Creando sección adicional de prueba...")
                              const testSection: SeatSection = {
                                id: "test-section-2",
                                name: "Sección Adicional",
                                type: "seats",
                                position: { x: 350, y: 100 },
                                dimensions: { width: 200, height: 150 },
                                color: "#10B981",
                                price: 85000,
                                capacity: 40,
                                seats: [],
                                isSelected: false
                              }
                              
                              setSections([...sections, testSection])
                              
                              toast({
                                title: "Sección adicional creada",
                                description: "Se creó una sección adicional para probar la eliminación",
                                variant: "default"
                              })
                            } else {
                              // Eliminar la primera sección que no sea "general"
                              const sectionToDelete = sections.find(s => s.id !== "general")
                              if (sectionToDelete) {
                                console.log("🧪 Eliminando sección de prueba:", sectionToDelete)
                                
                                setSections(prev => prev.filter(s => s.id !== sectionToDelete.id))
                                
                                setHasUnsavedChanges(true)
                                toast({
                                  title: "Sección de prueba eliminada",
                                  description: `Sección "${sectionToDelete.name}" eliminada`,
                                  variant: "destructive"
                                })
                              } else {
                                toast({
                                  title: "No hay secciones para eliminar",
                                  description: "Solo queda la sección general que no se puede eliminar",
                                  variant: "destructive"
                                })
                              }
                            }
                          }}
                        >
                          <Trash2 className="h-4 w-4 mr-1" />
                          <span className="text-xs">
                            {sections.length === 0 
                              ? "Crear Test" 
                              : sections.length === 1 && sections[0].id === "general"
                              ? "Crear + Test"
                              : "Eliminar Test"
                            }
                          </span>
                        </Button>
                      </div>

                      {/* Configuración de Validación */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Validación:</span>
                        <Button
                          variant={strictValidation ? "default" : "ghost"}
                          size="sm"
                          className={`h-8 px-3 transition-all duration-200 ${
                            strictValidation ? "bg-orange-600 text-white shadow-md" : "hover:bg-slate-100"
                          }`}
                          onClick={() => setStrictValidation(!strictValidation)}
                        >
                          <Shield className="h-4 w-4 mr-1" />
                          <span className="text-xs">
                            {strictValidation ? "Estricta" : "Flexible"}
                          </span>
                        </Button>
                      </div>

                      {/* Acciones de Elementos Seleccionados */}
                      {(selectedSeat || selectedSection) && (
                        <div className="flex items-center gap-2 bg-red-50 rounded-lg p-2 border border-red-200">
                          <span className="text-xs font-medium text-red-600 mr-2">Acciones:</span>
                          <Button
                            variant="destructive"
                            size="sm"
                            className="h-8 px-3"
                            onClick={() => {
                              if (selectedSeat) {
                                setSections(prev => prev.map(section => 
                                  section.id === selectedSeat.sectionId
                                    ? { ...section, seats: section.seats?.filter(s => s.id !== selectedSeat.id) || [] }
                                    : section
                                ))
                                setSelectedSeat(null)
                                setHasUnsavedChanges(true)
                                toast({
                                  title: "Asiento eliminado",
                                  description: `Asiento ${selectedSeat.number} eliminado`,
                                  variant: "destructive"
                                })
                              } else if (selectedSection && selectedSection.id !== "general") {
                                setSections(prev => prev.filter(s => s.id !== selectedSection.id))
                                setSelectedSection(null)
                                setHasUnsavedChanges(true)
                                toast({
                                  title: "Sección eliminada",
                                  description: `Sección "${selectedSection.name}" eliminada`,
                                  variant: "destructive"
                                })
                              }
                            }}
                          >
                            <Trash2 className="h-4 w-4 mr-1" />
                            <span className="text-xs">
                              Eliminar {selectedSeat ? "Asiento" : "Sección"}
                            </span>
                          </Button>
                        </div>
                      )}

                      {/* Controles de Historial */}
                      <div className="flex items-center gap-2 bg-slate-50 rounded-lg p-2 border border-slate-200">
                        <span className="text-xs font-medium text-slate-600 mr-2">Historial:</span>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={undo}
                          disabled={historyIndex <= 0}
                          className="h-8 px-3"
                        >
                          <Undo className="h-4 w-4 mr-1" />
                          <span className="text-xs">Deshacer</span>
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={redo}
                          disabled={historyIndex >= history.length - 1}
                          className="h-8 px-3"
                        >
                          <Redo className="h-4 w-4 mr-1" />
                          <span className="text-xs">Rehacer</span>
                        </Button>
                      </div>

                      {/* Configuración Rápida */}
                      {(selectedTool === "draw-seats" || selectedTool === "draw-section") && (
                        <div className="flex items-center gap-2 bg-blue-50 rounded-lg p-2 border border-blue-200">
                          <span className="text-xs font-medium text-blue-600 mr-2">Precio:</span>
                          <Input
                            type="number"
                            min="0"
                            step="1000"
                            value={formData.price}
                            onChange={(e) => setFormData({ ...formData, price: Number(e.target.value) || 0 })}
                            className="h-8 w-24 text-xs"
                            placeholder="Precio"
                          />
                          <span className="text-xs text-blue-600">{formatPrice(formData.price)}</span>
                        </div>
                      )}
                    </div>
                  </TabsContent>

                  <TabsContent value="pricing" className="space-y-0">
                    <div className="text-sm text-slate-600">
                      Herramientas de precios y configuración económica
                    </div>
                  </TabsContent>

                  <TabsContent value="view" className="space-y-0">
                    <div className="text-sm text-slate-600">
                      Configuración de vista y visualización
                    </div>
                  </TabsContent>

                  <TabsContent value="stats" className="space-y-0">
                    <div className="text-sm text-slate-600">
                      Estadísticas y análisis del mapa
                    </div>
                  </TabsContent>
                </div>
              </Tabs>
            </div>
          </div>
        </div>

        <div className="flex h-[calc(100vh-200px)]">
          {/* Sidebar Derecho */}
          <div className="w-64 bg-white/95 backdrop-blur-sm border-r border-slate-200/60 overflow-y-auto shadow-lg">
            <div className="p-4">
              {/* Templates */}
              <Card className="border-slate-200/60 mb-4">
                <CardHeader className="pb-3">
                  <CardTitle className="flex items-center gap-2 text-sm font-semibold text-slate-700">
                    <Star className="h-4 w-4 text-yellow-600" />
                    Templates
                  </CardTitle>
                </CardHeader>
                <CardContent className="space-y-2">
                  {predefinedTemplates.map((template) => {
                    const Icon = template.icon
                    return (
                      <Button
                        key={template.id}
                        variant="outline"
                        size="sm"
                        className="w-full justify-start transition-all duration-200 hover:bg-yellow-50 hover:border-yellow-300"
                        onClick={() => applyTemplate(template)}
                      >
                        <Icon className="h-4 w-4 mr-2" />
                        <div className="text-left">
                          <div className="font-medium text-sm">{template.name}</div>
                          <div className="text-xs text-slate-500">{template.description}</div>
                        </div>
                      </Button>
                    )
                  })}
                </CardContent>
              </Card>
            </div>
          </div>

          {/* Área Principal */}
          <div className="flex-1 flex flex-col">
            <Card className="flex-1 m-2 border-slate-200/60 shadow-xl">
              <CardHeader className="pb-2 bg-gradient-to-r from-slate-50 to-slate-100 border-b border-slate-200/60">
                <CardTitle className="flex items-center gap-2">
                  <div className="w-5 h-5 bg-gradient-to-br from-blue-600 to-indigo-600 rounded-lg flex items-center justify-center">
                    <MapPin className="h-3 w-3 text-white" />
                  </div>
                  <div>
                    <div className="text-sm font-bold text-slate-800">Lienzo de Diseño</div>
                    <div className="text-xs text-slate-600">Diseña tu mapa de asientos profesional</div>
                  </div>
                </CardTitle>
              </CardHeader>
              <CardContent className="flex-1 p-0 relative">
                <div className="relative w-full h-full overflow-hidden bg-gradient-to-br from-slate-50 via-blue-50/30 to-indigo-50/30" style={{ minHeight: '600px' }}>
                  {/* Lienzo SVG Interactivo */}
                  <svg
                    ref={canvasRef}
                    className="w-full h-full cursor-crosshair"
                    viewBox="0 0 1200 800"
                    onMouseDown={handleMouseDown}
                    onMouseMove={handleMouseMove}
                    onMouseUp={handleMouseUp}
                    onWheel={handleWheel}
                  >
                    {/* Definiciones de filtros y patrones */}
                    <defs>
                      <filter id="seatShadow" x="-20%" y="-20%" width="140%" height="140%">
                        <feDropShadow dx="2" dy="2" stdDeviation="2" floodColor="rgba(0,0,0,0.3)" />
                      </filter>
                      <filter id="sectionShadow" x="-20%" y="-20%" width="140%" height="140%">
                        <feDropShadow dx="3" dy="3" stdDeviation="3" floodColor="rgba(0,0,0,0.4)" />
                      </filter>
                      <filter id="stageShadow" x="-20%" y="-20%" width="140%" height="140%">
                        <feDropShadow dx="4" dy="4" stdDeviation="4" floodColor="rgba(0,0,0,0.5)" />
                      </filter>
                      
                      {/* Patrones para diferentes tipos de asientos */}
                      <pattern id="theaterPattern" patternUnits="userSpaceOnUse" width="16" height="16">
                        <rect width="16" height="16" fill="#059669" opacity="0.1" />
                        <circle cx="8" cy="8" r="2" fill="#059669" opacity="0.3" />
                      </pattern>
                      <pattern id="premiumPattern" patternUnits="userSpaceOnUse" width="32" height="32">
                        <rect width="32" height="32" fill="#EA580C" opacity="0.1" />
                        <polygon points="16,4 28,16 16,28 4,16" fill="#EA580C" opacity="0.3" />
                      </pattern>
                      <pattern id="stadiumPattern" patternUnits="userSpaceOnUse" width="16" height="16">
                        <rect width="16" height="16" fill="#DC2626" opacity="0.1" />
                        <rect x="4" y="4" width="8" height="8" fill="#DC2626" opacity="0.3" />
                      </pattern>
                    </defs>

                    {/* Cuadrícula de fondo */}
                    {showGrid && (
                      <g className="grid-lines">
                        {Array.from({ length: 60 }, (_, i) => (
                          <line
                            key={`v${i}`}
                            x1={i * 20}
                            y1="0"
                            x2={i * 20}
                            y2="800"
                            stroke="#E2E8F0"
                            strokeWidth="0.5"
                            opacity="0.3"
                          />
                        ))}
                        {Array.from({ length: 40 }, (_, i) => (
                          <line
                            key={`h${i}`}
                            x1="0"
                            y1={i * 20}
                            x2="1200"
                            y2={i * 20}
                            stroke="#E2E8F0"
                            strokeWidth="0.5"
                            opacity="0.3"
                          />
                        ))}
                      </g>
                    )}

                    {/* Escenario */}
                    <g className="stage" filter="url(#stageShadow)">
                      <rect
                        x={stageConfig.x}
                        y={stageConfig.y}
                        width={stageConfig.width}
                        height={stageConfig.height}
                        fill="#1E293B"
                        stroke="#475569"
                        strokeWidth="2"
                        rx="8"
                        className="cursor-pointer hover:opacity-80 transition-opacity"
                        onClick={() => handleStageClick()}
                      />
                      <text
                        x={stageConfig.x + stageConfig.width / 2}
                        y={stageConfig.y + stageConfig.height / 2 + 4}
                        textAnchor="middle"
                        fontSize="12"
                        fill="white"
                        fontWeight="bold"
                        className="pointer-events-none"
                      >
                        {stageConfig.label}
                      </text>
                      
                      {/* Elementos del escenario */}
                      {stageConfig.hasCurtain && (
                        <rect
                          x={stageConfig.x - 10}
                          y={stageConfig.y - 15}
                          width={stageConfig.width + 20}
                          height="15"
                          fill="#DC2626"
                          stroke="#991B1B"
                          strokeWidth="1"
                          rx="3"
                        />
                      )}
                      {stageConfig.hasBackdrop && (
                        <rect
                          x={stageConfig.x + 5}
                          y={stageConfig.y + stageConfig.height + 5}
                          width={stageConfig.width - 10}
                          height="20"
                          fill="#7C3AED"
                          stroke="#5B21B6"
                          strokeWidth="1"
                          rx="3"
                        />
                      )}
                    </g>

                    {/* Secciones existentes */}
                    {sections.map((section) => (
                      <g key={section.id} className="section">
                        <rect
                          x={section.position.x}
                          y={section.position.y}
                          width={section.dimensions.width}
                          height={section.dimensions.height}
                          fill={section.color}
                          stroke={selectedSection?.id === section.id ? "#EF4444" : "#1E293B"}
                          strokeWidth={selectedSection?.id === section.id ? "3" : "2"}
                          rx="6"
                          className="cursor-pointer hover:opacity-80 transition-opacity"
                          onClick={() => handleSectionClick(section)}
                        />
                        
                        {/* Etiqueta de la sección */}
                        <text
                          x={section.position.x + section.dimensions.width / 2}
                          y={section.position.y + section.dimensions.height / 2 + 4}
                          textAnchor="middle"
                          fontSize="11"
                          fill="white"
                          fontWeight="bold"
                          className="pointer-events-none"
                        >
                          {section.name}
                        </text>
                        
                        {/* Precio de la sección */}
                        <text
                          x={section.position.x + section.dimensions.width / 2}
                          y={section.position.y + section.dimensions.height / 2 + 18}
                          textAnchor="middle"
                          fontSize="9"
                          fill="white"
                          opacity="0.8"
                          className="pointer-events-none"
                        >
                          {formatPrice(section.price)}
                        </text>
                      </g>
                    ))}

                    {/* Asientos existentes */}
                    {sections.flatMap(section => 
                      section.seats?.map(seat => renderSeat(seat, section)) || []
                    )}

                    {/* Vista previa de dibujo */}
                    {drawingState.isDrawing && drawingState.previewShape && (
                      <g className="drawing-preview">
                        {drawingState.previewShape}
                      </g>
                    )}

                    {/* Indicadores de zoom y navegación */}
                    <g className="zoom-indicators" opacity="0.7">
                      <text x="20" y="30" fontSize="12" fill="#64748B" className="pointer-events-none">
                        Zoom: {Math.round(zoom * 100)}%
                      </text>
                      <text x="20" y="50" fontSize="12" fill="#64748B" className="pointer-events-none">
                        Herramienta: {toolCategories.drawing.find(t => t.id === selectedTool)?.name || selectedTool}
                      </text>
                    </g>

                    {/* Mensaje de ayuda cuando no hay contenido */}
                    {sections.length === 0 && !drawingState.isDrawing && (
                      <g className="help-message">
                        <rect
                          x="400"
                          y="300"
                          width="400"
                          height="200"
                          fill="rgba(255,255,255,0.9)"
                          stroke="#E2E8F0"
                          strokeWidth="1"
                          rx="12"
                          className="pointer-events-none"
                        />
                        <text
                          x="600"
                          y="350"
                          textAnchor="middle"
                          fontSize="16"
                          fill="#475569"
                          fontWeight="bold"
                          className="pointer-events-none"
                        >
                          Bienvenido al Editor de Mapas
                        </text>
                        <text
                          x="600"
                          y="380"
                          textAnchor="middle"
                          fontSize="12"
                          fill="#64748B"
                          className="pointer-events-none"
                        >
                          • Selecciona "Sección" para crear áreas de asientos
                        </text>
                        <text
                          x="600"
                          y="400"
                          textAnchor="middle"
                          fontSize="12"
                          fill="#64748B"
                          className="pointer-events-none"
                        >
                          • Usa "Asientos" para dibujar filas automáticamente
                        </text>
                        <text
                          x="600"
                          y="420"
                          textAnchor="middle"
                          fontSize="12"
                          fill="#64748B"
                          className="pointer-events-none"
                        >
                          • Aplica templates predefinidos desde el sidebar
                        </text>
                        <text
                          x="600"
                          y="440"
                          textAnchor="middle"
                          fontSize="12"
                          fill="#64748B"
                          className="pointer-events-none"
                        >
                          • Configura precios y personaliza colores
                        </text>
                      </g>
                    )}
                  </svg>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </TooltipProvider>
  )
}

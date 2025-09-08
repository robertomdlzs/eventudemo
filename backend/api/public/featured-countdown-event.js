const express = require('express')
const router = express.Router()
const { Pool } = require('pg')

// Configuración de la base de datos
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:password@localhost:5432/eventu_db'
})

// GET - Obtener evento próximo activo (público)
router.get('/', async (req, res) => {
  try {
    console.log('📋 Obteniendo evento próximo destacado (público)...')
    
    const query = `
      SELECT 
        id,
        title,
        date,
        location,
        image_url,
        event_slug,
        redirect_url,
        is_active,
        created_at,
        updated_at
      FROM featured_countdown_event 
      WHERE is_active = TRUE 
      ORDER BY updated_at DESC 
      LIMIT 1
    `
    
    const result = await pool.query(query)
    
    if (result.rows.length === 0) {
      // Retornar evento por defecto si no hay ninguno activo
      const defaultEvent = {
        id: null,
        title: "PANACA VIAJERO BARRANQUILLA",
        date: "20 DE JUNIO 2025",
        location: "PARQUE NORTE - BARRANQUILLA",
        image_url: "/placeholder.jpg",
        event_slug: "panaca-viajero-barranquilla",
        redirect_url: "",
        is_active: true,
        daysLeft: 15 // Días calculados dinámicamente
      }
      
      return res.json({
        success: true,
        data: defaultEvent,
        message: 'Evento por defecto retornado'
      })
    }
    
    const event = result.rows[0]
    
    // Calcular días restantes (simplificado)
    const eventDate = new Date('2025-06-20') // Fecha del evento PANACA
    const today = new Date()
    const timeDiff = eventDate.getTime() - today.getTime()
    const daysLeft = Math.ceil(timeDiff / (1000 * 3600 * 24))
    
    const eventWithCountdown = {
      ...event,
      daysLeft: Math.max(0, daysLeft)
    }
    
    console.log('✅ Evento próximo obtenido (público):', event.title, '- Días restantes:', daysLeft)
    
    res.json({
      success: true,
      data: eventWithCountdown,
      message: 'Evento próximo obtenido correctamente'
    })
    
  } catch (error) {
    console.error('❌ Error obteniendo evento próximo (público):', error)
    
    // En caso de error, retornar evento por defecto
    const defaultEvent = {
      id: null,
      title: "PANACA VIAJERO BARRANQUILLA",
      date: "20 DE JUNIO 2025",
      location: "PARQUE NORTE - BARRANQUILLA",
      image_url: "/placeholder.jpg",
      event_slug: "panaca-viajero-barranquilla",
      redirect_url: "",
      is_active: true,
      daysLeft: 15
    }
    
    res.json({
      success: true,
      data: defaultEvent,
      message: 'Evento por defecto retornado debido a error'
    })
  }
})

// GET - Obtener información básica del evento próximo (para SEO)
router.get('/info', async (req, res) => {
  try {
    console.log('📋 Obteniendo información básica del evento próximo...')
    
    const query = `
      SELECT 
        title,
        date,
        location,
        event_slug,
        redirect_url
      FROM featured_countdown_event 
      WHERE is_active = TRUE 
      ORDER BY updated_at DESC 
      LIMIT 1
    `
    
    const result = await pool.query(query)
    
    if (result.rows.length === 0) {
      return res.json({
        success: true,
        data: {
          title: "PANACA VIAJERO BARRANQUILLA",
          date: "20 DE JUNIO 2025",
          location: "PARQUE NORTE - BARRANQUILLA",
          event_slug: "panaca-viajero-barranquilla",
          redirect_url: ""
        },
        message: 'Información por defecto retornada'
      })
    }
    
    const event = result.rows[0]
    
    console.log('✅ Información básica obtenida:', event.title)
    
    res.json({
      success: true,
      data: event,
      message: 'Información básica obtenida correctamente'
    })
    
  } catch (error) {
    console.error('❌ Error obteniendo información básica:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    })
  }
})

module.exports = router


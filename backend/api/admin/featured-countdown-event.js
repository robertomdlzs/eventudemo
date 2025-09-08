const express = require('express')
const router = express.Router()
const { Pool } = require('pg')

// Configuración de la base de datos
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:password@localhost:5432/eventu_db'
})

// Middleware de autenticación (simplificado para este ejemplo)
const authenticateAdmin = (req, res, next) => {
  // En un entorno real, verificar JWT token aquí
  const token = req.headers.authorization?.replace('Bearer ', '')
  
  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Token de autenticación requerido'
    })
  }
  
  // Por ahora, permitir cualquier token para desarrollo
  next()
}

// GET - Obtener evento próximo activo
router.get('/', async (req, res) => {
  try {
    console.log('📋 Obteniendo evento próximo destacado...')
    
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
        is_active: true
      }
      
      return res.json({
        success: true,
        data: defaultEvent,
        message: 'Evento por defecto retornado'
      })
    }
    
    const event = result.rows[0]
    
    console.log('✅ Evento próximo obtenido:', event.title)
    
    res.json({
      success: true,
      data: event,
      message: 'Evento próximo obtenido correctamente'
    })
    
  } catch (error) {
    console.error('❌ Error obteniendo evento próximo:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    })
  }
})

// POST - Crear o actualizar evento próximo
router.post('/', authenticateAdmin, async (req, res) => {
  try {
    console.log('💾 Guardando evento próximo destacado...')
    console.log('📋 Datos recibidos:', req.body)
    
    const {
      title,
      date,
      location,
      image_url,
      event_slug,
      redirect_url,
      is_active
    } = req.body
    
    // Validaciones
    if (!title || !date || !location) {
      return res.status(400).json({
        success: false,
        message: 'Título, fecha y ubicación son requeridos'
      })
    }
    
    // Verificar si ya existe un evento activo
    const existingQuery = `
      SELECT id FROM featured_countdown_event 
      WHERE is_active = TRUE
    `
    const existingResult = await pool.query(existingQuery)
    
    let result
    
    if (existingResult.rows.length > 0) {
      // Actualizar evento existente
      const updateQuery = `
        UPDATE featured_countdown_event 
        SET 
          title = $1,
          date = $2,
          location = $3,
          image_url = $4,
          event_slug = $5,
          redirect_url = $6,
          is_active = $7,
          updated_at = CURRENT_TIMESTAMP
        WHERE is_active = TRUE
        RETURNING *
      `
      
      result = await pool.query(updateQuery, [
        title,
        date,
        location,
        image_url || '/placeholder.jpg',
        event_slug,
        redirect_url || '',
        is_active !== false
      ])
      
      console.log('✅ Evento próximo actualizado:', result.rows[0].title)
      
    } else {
      // Crear nuevo evento
      const insertQuery = `
        INSERT INTO featured_countdown_event (
          title, date, location, image_url, event_slug, redirect_url, is_active
        ) VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING *
      `
      
      result = await pool.query(insertQuery, [
        title,
        date,
        location,
        image_url || '/placeholder.jpg',
        event_slug,
        redirect_url || '',
        is_active !== false
      ])
      
      console.log('✅ Evento próximo creado:', result.rows[0].title)
    }
    
    res.json({
      success: true,
      data: result.rows[0],
      message: 'Evento próximo guardado correctamente'
    })
    
  } catch (error) {
    console.error('❌ Error guardando evento próximo:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    })
  }
})

// PUT - Actualizar estado del evento
router.put('/toggle', authenticateAdmin, async (req, res) => {
  try {
    console.log('🔄 Cambiando estado del evento próximo...')
    
    const { is_active } = req.body
    
    const query = `
      UPDATE featured_countdown_event 
      SET 
        is_active = $1,
        updated_at = CURRENT_TIMESTAMP
      WHERE id = (
        SELECT id FROM featured_countdown_event 
        ORDER BY updated_at DESC 
        LIMIT 1
      )
      RETURNING *
    `
    
    const result = await pool.query(query, [is_active])
    
    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No se encontró evento próximo para actualizar'
      })
    }
    
    console.log('✅ Estado del evento próximo actualizado:', result.rows[0].is_active)
    
    res.json({
      success: true,
      data: result.rows[0],
      message: `Evento próximo ${is_active ? 'activado' : 'desactivado'} correctamente`
    })
    
  } catch (error) {
    console.error('❌ Error cambiando estado del evento próximo:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    })
  }
})

// GET - Obtener historial de eventos próximos
router.get('/history', authenticateAdmin, async (req, res) => {
  try {
    console.log('📚 Obteniendo historial de eventos próximos...')
    
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
      ORDER BY updated_at DESC
      LIMIT 10
    `
    
    const result = await pool.query(query)
    
    console.log('✅ Historial obtenido:', result.rows.length, 'eventos')
    
    res.json({
      success: true,
      data: result.rows,
      message: 'Historial obtenido correctamente'
    })
    
  } catch (error) {
    console.error('❌ Error obteniendo historial:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor',
      error: error.message
    })
  }
})

module.exports = router


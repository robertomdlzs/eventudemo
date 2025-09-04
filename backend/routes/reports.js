const express = require('express')
const router = express.Router()
const { auth, requireRole } = require('../middleware/auth')
const db = require('../config/database-postgres')

// Middleware para verificar que el usuario es administrador
const requireAdmin = requireRole('admin')

// ===== REPORTES DE VENTAS =====

// GET /api/reports/sales - Reporte de ventas
router.get('/sales', auth, requireAdmin, async (req, res) => {
  try {
    const { startDate, endDate, eventId, categoryId, paymentMethod } = req.query

    let whereClause = 'WHERE 1=1'
    const params = []
    let paramIndex = 1

    if (startDate) {
      whereClause += ` AND s.created_at >= $${paramIndex}`
      params.push(startDate)
      paramIndex++
    }

    if (endDate) {
      whereClause += ` AND s.created_at <= $${paramIndex}`
      params.push(endDate)
      paramIndex++
    }

    if (eventId) {
      whereClause += ` AND s.event_id = $${paramIndex}`
      params.push(eventId)
      paramIndex++
    }

    if (categoryId) {
      whereClause += ` AND e.category_id = $${paramIndex}`
      params.push(categoryId)
      paramIndex++
    }

    if (paymentMethod) {
      whereClause += ` AND s.payment_method = $${paramIndex}`
      params.push(paymentMethod)
      paramIndex++
    }

    // Estadísticas generales de ventas
    const salesStatsQuery = `
      SELECT 
        COUNT(*) as total_sales,
        COALESCE(SUM(total_amount), 0) as total_revenue,
        COALESCE(AVG(total_amount), 0) as average_ticket_price,
        COUNT(DISTINCT user_id) as unique_customers,
        COUNT(DISTINCT event_id) as events_with_sales
      FROM sales s
      LEFT JOIN events e ON s.event_id = e.id
      ${whereClause}
    `
    
    const salesStatsResult = await db.query(salesStatsQuery, params)
    const salesStats = salesStatsResult.rows[0]

    // Ventas por método de pago
    const salesByPaymentMethodQuery = `
      SELECT 
        payment_method,
        COUNT(*) as sales_count,
        COALESCE(SUM(total_amount), 0) as revenue
      FROM sales s
      LEFT JOIN events e ON s.event_id = e.id
      ${whereClause}
      GROUP BY payment_method
      ORDER BY revenue DESC
    `
    
    const salesByPaymentMethodResult = await db.query(salesByPaymentMethodQuery, params)
    const salesByPaymentMethod = salesByPaymentMethodResult.rows

    // Ventas por evento
    const salesByEventQuery = `
      SELECT 
        e.id as event_id,
        e.title as event_name,
        COUNT(s.id) as sales_count,
        COALESCE(SUM(s.total_amount), 0) as revenue,
        e.date as event_date
      FROM events e
      LEFT JOIN sales s ON e.id = s.event_id
      ${whereClause.replace('s.', '')}
      GROUP BY e.id, e.title, e.date
      ORDER BY revenue DESC
      LIMIT 10
    `
    
    const salesByEventResult = await db.query(salesByEventQuery, params)
    const salesByEvent = salesByEventResult.rows

    // Ventas por fecha
    const salesByDateQuery = `
      SELECT 
        DATE(s.created_at) as sale_date,
        COUNT(*) as sales_count,
        COALESCE(SUM(total_amount), 0) as revenue
      FROM sales s
      LEFT JOIN events e ON s.event_id = e.id
      ${whereClause}
      GROUP BY DATE(s.created_at)
      ORDER BY sale_date DESC
      LIMIT 30
    `
    
    const salesByDateResult = await db.query(salesByDateQuery, params)
    const salesByDate = salesByDateResult.rows

    res.json({
      success: true,
      data: {
        stats: {
          totalSales: parseInt(salesStats.total_sales),
          totalRevenue: parseFloat(salesStats.total_revenue),
          averageTicketPrice: parseFloat(salesStats.average_ticket_price),
          uniqueCustomers: parseInt(salesStats.unique_customers),
          eventsWithSales: parseInt(salesStats.events_with_sales)
        },
        salesByPaymentMethod,
        salesByEvent,
        salesByDate
      }
    })
  } catch (error) {
    console.error('Error fetching sales report:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    })
  }
})

// ===== REPORTES DE EVENTOS =====

// GET /api/reports/events - Reporte de eventos
router.get('/events', auth, requireAdmin, async (req, res) => {
  try {
    const { startDate, endDate, categoryId, status, organizerId } = req.query

    let whereClause = 'WHERE 1=1'
    const params = []
    let paramIndex = 1

    if (startDate) {
      whereClause += ` AND e.created_at >= $${paramIndex}`
      params.push(startDate)
      paramIndex++
    }

    if (endDate) {
      whereClause += ` AND e.created_at <= $${paramIndex}`
      params.push(endDate)
      paramIndex++
    }

    if (categoryId) {
      whereClause += ` AND e.category_id = $${paramIndex}`
      params.push(categoryId)
      paramIndex++
    }

    if (status) {
      whereClause += ` AND e.status = $${paramIndex}`
      params.push(status)
      paramIndex++
    }

    if (organizerId) {
      whereClause += ` AND e.organizer_id = $${paramIndex}`
      params.push(organizerId)
      paramIndex++
    }

    // Estadísticas generales de eventos
    const eventsStatsQuery = `
      SELECT 
        COUNT(*) as total_events,
        COUNT(CASE WHEN status = 'published' THEN 1 END) as published_events,
        COUNT(CASE WHEN status = 'draft' THEN 1 END) as draft_events,
        COUNT(CASE WHEN status = 'cancelled' THEN 1 END) as cancelled_events,
        COUNT(DISTINCT organizer_id) as unique_organizers
      FROM events e
      ${whereClause}
    `
    
    const eventsStatsResult = await db.query(eventsStatsQuery, params)
    const eventsStats = eventsStatsResult.rows[0]

    // Eventos por categoría
    const eventsByCategoryQuery = `
      SELECT 
        c.id as category_id,
        c.name as category_name,
        COUNT(e.id) as events_count,
        COUNT(CASE WHEN e.status = 'published' THEN 1 END) as published_count
      FROM categories c
      LEFT JOIN events e ON c.id = e.category_id
      ${whereClause.replace('e.', '')}
      GROUP BY c.id, c.name
      ORDER BY events_count DESC
    `
    
    const eventsByCategoryResult = await db.query(eventsByCategoryQuery, params)
    const eventsByCategory = eventsByCategoryResult.rows

    // Eventos por estado
    const eventsByStatusQuery = `
      SELECT 
        status,
        COUNT(*) as events_count
      FROM events e
      ${whereClause}
      GROUP BY status
      ORDER BY events_count DESC
    `
    
    const eventsByStatusResult = await db.query(eventsByStatusQuery, params)
    const eventsByStatus = eventsByStatusResult.rows

    // Eventos por fecha de creación
    const eventsByDateQuery = `
      SELECT 
        DATE(e.created_at) as creation_date,
        COUNT(*) as events_count
      FROM events e
      ${whereClause}
      GROUP BY DATE(e.created_at)
      ORDER BY creation_date DESC
      LIMIT 30
    `
    
    const eventsByDateResult = await db.query(eventsByDateQuery, params)
    const eventsByDate = eventsByDateResult.rows

    // Top eventos por rendimiento
    const topPerformingEventsQuery = `
      SELECT 
        e.id as event_id,
        e.title as event_name,
        e.date as event_date,
        COUNT(s.id) as tickets_sold,
        COALESCE(SUM(s.total_amount), 0) as revenue,
        e.total_capacity,
        ROUND((COUNT(s.id)::float / NULLIF(e.total_capacity, 0) * 100), 2) as attendance_percentage
      FROM events e
      LEFT JOIN sales s ON e.id = s.event_id
      ${whereClause.replace('e.', '')}
      GROUP BY e.id, e.title, e.date, e.total_capacity
      ORDER BY revenue DESC
      LIMIT 10
    `
    
    const topPerformingEventsResult = await db.query(topPerformingEventsQuery, params)
    const topPerformingEvents = topPerformingEventsResult.rows

    res.json({
      success: true,
      data: {
        stats: {
          totalEvents: parseInt(eventsStats.total_events),
          publishedEvents: parseInt(eventsStats.published_events),
          draftEvents: parseInt(eventsStats.draft_events),
          cancelledEvents: parseInt(eventsStats.cancelled_events),
          uniqueOrganizers: parseInt(eventsStats.unique_organizers)
        },
        eventsByCategory,
        eventsByStatus,
        eventsByDate,
        topPerformingEvents
      }
    })
  } catch (error) {
    console.error('Error fetching events report:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    })
  }
})

// ===== REPORTES DE USUARIOS =====

// GET /api/reports/users - Reporte de usuarios
router.get('/users', auth, requireAdmin, async (req, res) => {
  try {
    const { startDate, endDate, role, status } = req.query

    let whereClause = 'WHERE 1=1'
    const params = []
    let paramIndex = 1

    if (startDate) {
      whereClause += ` AND u.created_at >= $${paramIndex}`
      params.push(startDate)
      paramIndex++
    }

    if (endDate) {
      whereClause += ` AND u.created_at <= $${paramIndex}`
      params.push(endDate)
      paramIndex++
    }

    if (role) {
      whereClause += ` AND u.role = $${paramIndex}`
      params.push(role)
      paramIndex++
    }

    if (status) {
      whereClause += ` AND u.status = $${paramIndex}`
      params.push(status)
      paramIndex++
    }

    // Estadísticas generales de usuarios
    const usersStatsQuery = `
      SELECT 
        COUNT(*) as total_users,
        COUNT(CASE WHEN role = 'admin' THEN 1 END) as admin_users,
        COUNT(CASE WHEN role = 'organizer' THEN 1 END) as organizer_users,
        COUNT(CASE WHEN role = 'user' THEN 1 END) as regular_users,
        COUNT(CASE WHEN status = 'active' THEN 1 END) as active_users,
        COUNT(CASE WHEN last_login >= NOW() - INTERVAL '30 days' THEN 1 END) as active_last_30_days
      FROM users u
      ${whereClause}
    `
    
    const usersStatsResult = await db.query(usersStatsQuery, params)
    const usersStats = usersStatsResult.rows[0]

    // Usuarios por rol
    const usersByRoleQuery = `
      SELECT 
        role,
        COUNT(*) as users_count
      FROM users u
      ${whereClause}
      GROUP BY role
      ORDER BY users_count DESC
    `
    
    const usersByRoleResult = await db.query(usersByRoleQuery, params)
    const usersByRole = usersByRoleResult.rows

    // Usuarios por estado
    const usersByStatusQuery = `
      SELECT 
        status,
        COUNT(*) as users_count
      FROM users u
      ${whereClause}
      GROUP BY status
      ORDER BY users_count DESC
    `
    
    const usersByStatusResult = await db.query(usersByStatusQuery, params)
    const usersByStatus = usersByStatusResult.rows

    // Usuarios por fecha de registro
    const usersByDateQuery = `
      SELECT 
        DATE(u.created_at) as registration_date,
        COUNT(*) as users_count
      FROM users u
      ${whereClause}
      GROUP BY DATE(u.created_at)
      ORDER BY registration_date DESC
      LIMIT 30
    `
    
    const usersByDateResult = await db.query(usersByDateQuery, params)
    const usersByDate = usersByDateResult.rows

    // Top usuarios por actividad
    const topUsersQuery = `
      SELECT 
        u.id as user_id,
        u.first_name,
        u.last_name,
        u.email,
        u.role,
        COUNT(DISTINCT e.id) as events_created,
        COUNT(s.id) as tickets_purchased,
        COALESCE(SUM(s.total_amount), 0) as total_spent
      FROM users u
      LEFT JOIN events e ON u.id = e.organizer_id
      LEFT JOIN sales s ON u.id = s.user_id
      ${whereClause}
      GROUP BY u.id, u.first_name, u.last_name, u.email, u.role
      ORDER BY total_spent DESC, events_created DESC
      LIMIT 10
    `
    
    const topUsersResult = await db.query(topUsersQuery, params)
    const topUsers = topUsersResult.rows

    res.json({
      success: true,
      data: {
        stats: {
          totalUsers: parseInt(usersStats.total_users),
          adminUsers: parseInt(usersStats.admin_users),
          organizerUsers: parseInt(usersStats.organizer_users),
          regularUsers: parseInt(usersStats.regular_users),
          activeUsers: parseInt(usersStats.active_users),
          activeLast30Days: parseInt(usersStats.active_last_30_days)
        },
        usersByRole,
        usersByStatus,
        usersByDate,
        topUsers
      }
    })
  } catch (error) {
    console.error('Error fetching users report:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    })
  }
})

// ===== REPORTES FINANCIEROS =====

// GET /api/reports/financial - Reporte financiero
router.get('/financial', auth, requireAdmin, async (req, res) => {
  try {
    const { startDate, endDate } = req.query

    let whereClause = 'WHERE 1=1'
    const params = []
    let paramIndex = 1

    if (startDate) {
      whereClause += ` AND s.created_at >= $${paramIndex}`
      params.push(startDate)
      paramIndex++
    }

    if (endDate) {
      whereClause += ` AND s.created_at <= $${paramIndex}`
      params.push(endDate)
      paramIndex++
    }

    // Resumen financiero general
    const financialSummaryQuery = `
      SELECT 
        COUNT(*) as total_transactions,
        COALESCE(SUM(total_amount), 0) as total_revenue,
        COALESCE(AVG(total_amount), 0) as average_transaction,
        COUNT(DISTINCT user_id) as unique_customers,
        COUNT(DISTINCT event_id) as events_with_revenue
      FROM sales s
      ${whereClause}
    `
    
    const financialSummaryResult = await db.query(financialSummaryQuery, params)
    const financialSummary = financialSummaryResult.rows[0]

    // Ingresos por mes
    const revenueByMonthQuery = `
      SELECT 
        DATE_TRUNC('month', s.created_at) as month,
        COUNT(*) as transactions,
        COALESCE(SUM(total_amount), 0) as revenue
      FROM sales s
      ${whereClause}
      GROUP BY DATE_TRUNC('month', s.created_at)
      ORDER BY month DESC
      LIMIT 12
    `
    
    const revenueByMonthResult = await db.query(revenueByMonthQuery, params)
    const revenueByMonth = revenueByMonthResult.rows

    // Ingresos por día (últimos 30 días)
    const revenueByDayQuery = `
      SELECT 
        DATE(s.created_at) as day,
        COUNT(*) as transactions,
        COALESCE(SUM(total_amount), 0) as revenue
      FROM sales s
      ${whereClause}
      AND s.created_at >= NOW() - INTERVAL '30 days'
      GROUP BY DATE(s.created_at)
      ORDER BY day DESC
    `
    
    const revenueByDayResult = await db.query(revenueByDayQuery, params)
    const revenueByDay = revenueByDayResult.rows

    // Top eventos por ingresos
    const topEventsByRevenueQuery = `
      SELECT 
        e.id as event_id,
        e.title as event_name,
        e.date as event_date,
        COUNT(s.id) as transactions,
        COALESCE(SUM(s.total_amount), 0) as revenue
      FROM events e
      LEFT JOIN sales s ON e.id = s.event_id
      ${whereClause.replace('s.', '')}
      GROUP BY e.id, e.title, e.date
      ORDER BY revenue DESC
      LIMIT 10
    `
    
    const topEventsByRevenueResult = await db.query(topEventsByRevenueQuery, params)
    const topEventsByRevenue = topEventsByRevenueResult.rows

    res.json({
      success: true,
      data: {
        summary: {
          totalTransactions: parseInt(financialSummary.total_transactions),
          totalRevenue: parseFloat(financialSummary.total_revenue),
          averageTransaction: parseFloat(financialSummary.average_transaction),
          uniqueCustomers: parseInt(financialSummary.unique_customers),
          eventsWithRevenue: parseInt(financialSummary.events_with_revenue)
        },
        revenueByMonth,
        revenueByDay,
        topEventsByRevenue
      }
    })
  } catch (error) {
    console.error('Error fetching financial report:', error)
    res.status(500).json({
      success: false,
      message: 'Error interno del servidor'
    })
  }
})

module.exports = router

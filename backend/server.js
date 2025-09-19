const express = require("express")
const cors = require("cors")
const helmet = require("helmet")
const compression = require("compression")
const rateLimit = require("express-rate-limit")
const winston = require("winston")
const http = require("http")
const path = require("path")
 require("dotenv").config({ path: "./config.env" })

const dbType = process.env.DB_TYPE || "mysql"
const db = dbType === "postgresql" ? require("./config/database-postgres") : require("./config/database")

const authRoutes = require("./routes/auth")
const eventRoutes = require("./routes/events")
const userRoutes = require("./routes/users")
const categoryRoutes = require("./routes/categories")
const ticketTypeRoutes = require("./routes/ticketTypes")
const mediaRoutes = require("./routes/media")
const reportsRoutes = require("./routes/reports")
const analyticsRoutes = require("./routes/analytics")
const exportRoutes = require("./routes/export")
const settingsRoutes = require("./routes/settings")
const organizerRoutes = require("./routes/organizer")
const adminRoutes = require("./routes/admin")
const seatMapRoutes = require("./routes/seatMaps")
const paymentRoutes = require("./routes/payments")
const epaycoRoutes = require("./routes/epayco")
const cobruRoutes = require("./routes/cobru")
const ticketRoutes = require("./routes/tickets")
const salesRoutes = require("./routes/sales")
const passwordResetRoutes = require("./routes/passwordReset")
const auditRoutes = require("./routes/audit")
const adminDataRoutes = require("./routes/admin-data")
const backupRoutes = require("./routes/backup")
const securityRoutes = require("./routes/security")
const wafRoutes = require("./routes/waf")
const { sessionTimeout, updateActivity } = require("./middleware/session-timeout")
const auditMiddleware = require("./middleware/auditMiddleware")
const { require2FA } = require("./middleware/require2FA")
const { securityMonitoringMiddleware } = require("./middleware/securityMonitoring")
const { waf } = require("./middleware/waf")

const app = express()
const server = http.createServer(app)
const PORT = process.env.PORT || 3001

// Logger configuration
const logger = winston.createLogger({
  level: "info",
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json(),
  ),
  defaultMeta: { service: "eventu-backend" },
  transports: [
    new winston.transports.File({ filename: "logs/error.log", level: "error" }),
    new winston.transports.File({ filename: "logs/combined.log" }),
    new winston.transports.Console({
      format: winston.format.simple(),
    }),
  ],
})

// Rate limiting AGRESIVO para seguridad
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // 100 requests por IP (reducido de 5000)
  message: {
    error: "Demasiadas peticiones. Intenta de nuevo en 15 minutos.",
    retryAfter: 15 * 60
  },
  standardHeaders: true,
  legacyHeaders: false,
  skip: (req) => {
    // Saltar rate limiting para peticiones preflight (OPTIONS)
    return req.method === 'OPTIONS'
  }
})

// Rate limiting ESPECÍFICO para autenticación
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutos
  max: 5, // Solo 5 intentos de login por IP
  skipSuccessfulRequests: true,
  message: {
    error: "Demasiados intentos de login. Intenta de nuevo en 15 minutos.",
    retryAfter: 15 * 60
  },
  standardHeaders: true,
  legacyHeaders: false,
  handler: (req, res) => {
    // Log del intento de rate limiting
    console.warn(`🚨 Rate limit exceeded for IP: ${req.ip} on ${req.path}`);
    res.status(429).json({
      error: "Demasiados intentos de login. Intenta de nuevo en 15 minutos.",
      retryAfter: 15 * 60
    });
  }
})

// Middleware con headers de seguridad ESTRICTOS
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      objectSrc: ["'none'"],
      mediaSrc: ["'self'"],
      frameSrc: ["'none'"],
      upgradeInsecureRequests: []
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  },
  noSniff: true,
  xssFilter: true,
  referrerPolicy: { policy: "strict-origin-when-cross-origin" }
}))
app.use(compression())
app.use(generalLimiter)
app.use(
  cors({
    origin: process.env.ALLOWED_ORIGINS?.split(',') || [
      'https://eventu.mnz.dom.my.id',
      'https://www.eventu.mnz.dom.my.id',
      'http://localhost:3000' // Solo para desarrollo
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
    optionsSuccessStatus: 200 // Para compatibilidad con navegadores legacy
  }),
)

// Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path} - ${req.ip}`)
  next()
})

// Web Application Firewall (WAF) - TEMPORALMENTE DESHABILITADO PARA DESARROLLO
// app.use(waf.middleware())

// Security monitoring middleware
app.use(securityMonitoringMiddleware)

// JSON parsing middleware - MUST be before routes
app.use(express.json({ limit: "10mb" }))
app.use(express.urlencoded({ extended: true, limit: "10mb" }))

// Servir archivos estáticos (imágenes, videos, etc.)
app.use('/images', express.static(path.join(__dirname, 'images')))
app.use('/videos', express.static(path.join(__dirname, 'videos')))

// Health check
app.get("/api/health", (req, res) => {
  res.json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    database: dbType,
  })
})

// Test route
app.get("/api/test", (req, res) => {
  res.json({
    success: true,
    message: "API funcionando correctamente",
    timestamp: new Date().toISOString(),
    database: dbType,
    port: PORT
  })
})

// Root API route
app.get("/api", (req, res) => {
  res.json({
    success: true,
    message: "Eventu API v1.0",
    endpoints: [
      "/api/health",
      "/api/test",
      "/api/auth",
      "/api/events",
      "/api/users",
      "/api/organizer",
      "/api/admin"
    ]
  })
})

// Session timeout middleware
app.use(sessionTimeout(15)) // 15 minutos de timeout con advertencia a los 13 minutos
app.use(updateActivity) // Actualizar timestamp de actividad en cada request

// Audit middleware - registrar todas las actividades
app.use(auditMiddleware())

// Routes con rate limiting específico para auth
app.use("/api/auth", authLimiter, authRoutes)
app.use("/api/password-reset", passwordResetRoutes)
app.use("/api/events", eventRoutes)
app.use("/api/users", userRoutes)
app.use("/api/categories", categoryRoutes)
app.use("/api/ticket-types", ticketTypeRoutes)
app.use("/api/media", mediaRoutes)
app.use("/api/reports", reportsRoutes)
app.use("/api/analytics", analyticsRoutes)
app.use("/api/export", exportRoutes)
app.use("/api/settings", settingsRoutes)
app.use("/api/organizer", organizerRoutes)
app.use("/api/admin", adminRoutes)
app.use("/api/backup", require2FA, backupRoutes)
app.use("/api/security", require2FA, securityRoutes)
app.use("/api/waf", require2FA, wafRoutes)
app.use("/api/seat-maps", seatMapRoutes)
app.use("/api/payments", paymentRoutes)
app.use("/api/payments/epayco", epaycoRoutes)
app.use("/api/payments/cobru", cobruRoutes)
app.use("/api/tickets", ticketRoutes)
app.use("/api/sales", salesRoutes)
app.use("/api/audit", auditRoutes)

// Serve uploaded files
app.use('/uploads', express.static(path.join(__dirname, 'uploads')))

// Error handling middleware
app.use((err, req, res, next) => {
  logger.error(err.stack)

  if (err.name === "ValidationError") {
    return res.status(400).json({
      success: false,
      message: "Validation error",
      errors: err.details,
    })
  }

  if (err.name === "UnauthorizedError") {
    return res.status(401).json({
      success: false,
      message: "Unauthorized",
    })
  }

  res.status(500).json({
    success: false,
    message: "Internal server error",
  })
})

// 404 handler
app.use("*", (req, res) => {
  res.status(404).json({
    success: false,
    message: "Route not found",
  })
})

// Initialize WebSocket server
const WebSocketServer = require('./websocket-server')
const wsServer = new WebSocketServer(server)

// Make WebSocket server available globally
global.wsServer = wsServer

// Start server
const HOST = process.env.HOST || '0.0.0.0'
server.listen(PORT, HOST, () => {
  logger.info(`Server running on port ${PORT}`)
  logger.info(`WebSocket server initialized`)
  logger.info(`Using ${dbType} database`)

  const testQuery = dbType === "postgresql" ? "SELECT NOW()" : "SELECT NOW()"

  db.query(testQuery)
    .then((result) => {
      logger.info(`${dbType} database connected successfully`)
    })
    .catch((err) => {
      logger.error(`${dbType} connection failed:`, err)
    })
})

module.exports = app

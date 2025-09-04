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
const ticketRoutes = require("./routes/tickets")
const salesRoutes = require("./routes/sales")
const passwordResetRoutes = require("./routes/passwordReset")

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

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 1000, // limit each IP to 1000 requests per windowMs (increased for testing)
  message: "Too many requests from this IP, please try again later.",
})

// Middleware
app.use(helmet())
app.use(compression())
app.use(limiter)
app.use(
  cors({
    origin: process.env.FRONTEND_URL || "http://localhost:3000",
    credentials: true,
  }),
)

// Request logging
app.use((req, res, next) => {
  logger.info(`${req.method} ${req.path} - ${req.ip}`)
  next()
})

// JSON parsing middleware - MUST be before routes
app.use(express.json({ limit: "10mb" }))
app.use(express.urlencoded({ extended: true, limit: "10mb" }))

// Health check
app.get("/api/health", (req, res) => {
  res.json({
    status: "OK",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    database: dbType,
  })
})

// Routes
app.use("/api/auth", authRoutes)
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
app.use("/api/seat-maps", seatMapRoutes)
app.use("/api/payments", paymentRoutes)
app.use("/api/payments/epayco", epaycoRoutes)
app.use("/api/tickets", ticketRoutes)
app.use("/api/sales", salesRoutes)

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

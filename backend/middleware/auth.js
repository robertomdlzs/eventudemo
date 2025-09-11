const jwt = require("jsonwebtoken")
const User = require("../models/User")

const auth = async (req, res, next) => {
  try {
    const authHeader = req.header("Authorization")

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({
        success: false,
        message: "Access denied. No token provided.",
      })
    }

    const token = authHeader.replace("Bearer ", "")
    const decoded = jwt.verify(token, process.env.JWT_SECRET || "fallback_secret")



    // Verificar timeout de sesión si existe timestamp de actividad
    // Solo verificar timeout si el token tiene lastActivity y ha pasado más de 15 minutos
    if (decoded.lastActivity) {
      const now = Date.now()
      const lastActivity = decoded.lastActivity
      const timeoutMs = 15 * 60 * 1000 // 15 minutos
      
      // Solo rechazar si ha pasado más de 15 minutos de inactividad
      if (now - lastActivity > timeoutMs) {
        console.log(`Session timeout for user ${decoded.userId}: ${Math.round((now - lastActivity) / 1000 / 60)} minutes of inactivity`)
        return res.status(401).json({
          success: false,
          message: "Session expired due to inactivity.",
          code: "SESSION_TIMEOUT",
          details: {
            lastActivity: new Date(lastActivity).toISOString(),
            timeoutMinutes: 15,
            inactiveMinutes: Math.round((now - lastActivity) / 1000 / 60)
          }
        })
      }
    }

    const user = await User.findById(decoded.userId)

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid token. User not found.",
      })
    }

    if (user.status !== "active") {
      return res.status(401).json({
        success: false,
        message: "Account is not active.",
      })
    }

    req.user = {
      userId: user.id,
      email: user.email,
      role: user.role,
      name: user.name,
    }

    next()
  } catch (error) {
    console.error("Auth middleware error:", error)

    if (error.name === "JsonWebTokenError") {
      return res.status(401).json({
        success: false,
        message: "Invalid token.",
      })
    }

    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Token expired.",
      })
    }

    res.status(500).json({
      success: false,
      message: "Internal server error.",
    })
  }
}

const requireRole = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: "Authentication required.",
      })
    }

    const userRoles = Array.isArray(roles) ? roles : [roles]

    if (!userRoles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: "Insufficient permissions.",
      })
    }

    next()
  }
}

module.exports = { auth, requireRole }

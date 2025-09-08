const jwt = require("jsonwebtoken")

// Middleware para verificar timeout de sesión
const sessionTimeout = (timeoutMinutes = 15) => {
  return (req, res, next) => {
    try {
      const authHeader = req.header("Authorization")
      
      if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return next() // Si no hay token, continuar (será manejado por auth middleware)
      }

      const token = authHeader.replace("Bearer ", "")
      const decoded = jwt.verify(token, process.env.JWT_SECRET || "fallback_secret")
      
      // Verificar si el token tiene timestamp de última actividad
      if (decoded.lastActivity) {
        const now = Date.now()
        const lastActivity = decoded.lastActivity
        const timeoutMs = timeoutMinutes * 60 * 1000
        
        // Si ha pasado más tiempo del permitido, rechazar la petición
        if (now - lastActivity > timeoutMs) {
          return res.status(401).json({
            success: false,
            message: "Session expired due to inactivity.",
            code: "SESSION_TIMEOUT"
          })
        }
      }
      
      next()
    } catch (error) {
      // Si hay error en el token, continuar (será manejado por auth middleware)
      next()
    }
  }
}

// Middleware para actualizar timestamp de actividad
const updateActivity = (req, res, next) => {
  try {
    const authHeader = req.header("Authorization")
    
    if (authHeader && authHeader.startsWith("Bearer ")) {
      const token = authHeader.replace("Bearer ", "")
      const decoded = jwt.verify(token, process.env.JWT_SECRET || "fallback_secret")
      
      // Crear nuevo token con timestamp actualizado
      const newToken = jwt.sign(
        {
          ...decoded,
          lastActivity: Date.now()
        },
        process.env.JWT_SECRET || "fallback_secret",
        { expiresIn: "24h" }
      )
      
      // Agregar el nuevo token al header de respuesta
      res.setHeader("X-New-Token", newToken)
    }
    
    next()
  } catch (error) {
    // Si hay error, continuar sin actualizar
    next()
  }
}

module.exports = { sessionTimeout, updateActivity }

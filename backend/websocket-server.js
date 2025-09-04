const { Server } = require('socket.io')
const jwt = require('jsonwebtoken')

class WebSocketServer {
  constructor(server) {
    this.io = new Server(server, {
      cors: {
        origin: process.env.FRONTEND_URL || "http://localhost:3000",
        methods: ["GET", "POST"]
      }
    })
    
    this.connectedUsers = new Map() // userId -> socket
    this.userRooms = new Map() // userId -> room
    
    this.setupMiddleware()
    this.setupEventHandlers()
  }

  setupMiddleware() {
    // Autenticación JWT
    this.io.use((socket, next) => {
      const token = socket.handshake.auth.token || socket.handshake.headers.authorization?.replace('Bearer ', '')
      
      if (!token) {
        return next(new Error('Authentication error'))
      }

      try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET)
        socket.userId = decoded.userId
        socket.userRole = decoded.role
        next()
      } catch (error) {
        next(new Error('Authentication error'))
      }
    })
  }

  setupEventHandlers() {
    this.io.on('connection', (socket) => {
      console.log(`User ${socket.userId} connected`)
      
      // Agregar usuario a la lista de conectados
      this.connectedUsers.set(socket.userId, socket)
      
      // Unirse a sala según el rol
      const room = this.getRoomByRole(socket.userRole)
      socket.join(room)
      this.userRooms.set(socket.userId, room)
      
      // Enviar notificaciones no leídas
      this.sendUnreadNotifications(socket)
      
      // Manejar desconexión
      socket.on('disconnect', () => {
        console.log(`User ${socket.userId} disconnected`)
        this.connectedUsers.delete(socket.userId)
        this.userRooms.delete(socket.userId)
      })
      
      // Marcar notificación como leída
      socket.on('markNotificationRead', (notificationId) => {
        this.markNotificationAsRead(socket.userId, notificationId)
      })
      
      // Marcar todas las notificaciones como leídas
      socket.on('markAllNotificationsRead', () => {
        this.markAllNotificationsAsRead(socket.userId)
      })
    })
  }

  getRoomByRole(role) {
    switch (role) {
      case 'admin':
        return 'admins'
      case 'organizer':
        return 'organizers'
      default:
        return 'users'
    }
  }

  // Enviar notificación a usuarios específicos
  sendNotification(notification) {
    const { target, recipients } = notification
    
    switch (target) {
      case 'all':
        this.io.emit('newNotification', notification)
        break
      case 'admins':
        this.io.to('admins').emit('newNotification', notification)
        break
      case 'organizers':
        this.io.to('organizers').emit('newNotification', notification)
        break
      case 'users':
        this.io.to('users').emit('newNotification', notification)
        break
      case 'specific':
        if (recipients && Array.isArray(recipients)) {
          recipients.forEach(userId => {
            const userSocket = this.connectedUsers.get(userId)
            if (userSocket) {
              userSocket.emit('newNotification', notification)
            }
          })
        }
        break
    }
  }

  // Enviar notificaciones no leídas al usuario
  async sendUnreadNotifications(socket) {
    try {
      const db = require('./config/database-postgres')
      const query = `
        SELECT * FROM notifications 
        WHERE (target = 'all' OR target = $1 OR (target = 'specific' AND recipients @> $2))
        AND NOT (read_by @> $2)
        ORDER BY sent_at DESC
        LIMIT 10
      `
      const result = await db.query(query, [socket.userRole, JSON.stringify([socket.userId])])
      
      if (result.rows.length > 0) {
        socket.emit('unreadNotifications', result.rows)
      }
    } catch (error) {
      console.error('Error fetching unread notifications:', error)
    }
  }

  // Marcar notificación como leída
  async markNotificationAsRead(userId, notificationId) {
    try {
      const db = require('./config/database-postgres')
      const query = `
        UPDATE notifications 
        SET read_by = COALESCE(read_by, '[]'::jsonb) || $1::jsonb
        WHERE id = $2
      `
      await db.query(query, [JSON.stringify([userId]), notificationId])
    } catch (error) {
      console.error('Error marking notification as read:', error)
    }
  }

  // Marcar todas las notificaciones como leídas
  async markAllNotificationsAsRead(userId) {
    try {
      const db = require('./config/database-postgres')
      const query = `
        UPDATE notifications 
        SET read_by = COALESCE(read_by, '[]'::jsonb) || $1::jsonb
        WHERE NOT (read_by @> $1::jsonb)
      `
      await db.query(query, [JSON.stringify([userId])])
    } catch (error) {
      console.error('Error marking all notifications as read:', error)
    }
  }

  // Enviar actualización en tiempo real
  sendRealtimeUpdate(type, data) {
    this.io.emit('realtimeUpdate', { type, data, timestamp: new Date().toISOString() })
  }

  // Enviar actualización específica por rol
  sendRoleUpdate(role, type, data) {
    this.io.to(role).emit('realtimeUpdate', { type, data, timestamp: new Date().toISOString() })
  }

  // Obtener estadísticas de conexiones
  getConnectionStats() {
    return {
      totalConnections: this.connectedUsers.size,
      admins: this.io.sockets.adapter.rooms.get('admins')?.size || 0,
      organizers: this.io.sockets.adapter.rooms.get('organizers')?.size || 0,
      users: this.io.sockets.adapter.rooms.get('users')?.size || 0
    }
  }
}

module.exports = WebSocketServer

import { useEffect, useRef, useState } from 'react'
import { io } from 'socket.io-client'

export const useWebSocket = (token, userRole) => {
  const [socket, setSocket] = useState(null)
  const [connected, setConnected] = useState(false)
  const [error, setError] = useState(null)
  const reconnectTimeoutRef = useRef(null)
  const reconnectAttempts = useRef(0)
  const maxReconnectAttempts = 5

  useEffect(() => {
    if (!token || !userRole) return

    const connect = () => {
      try {
        const newSocket = io('http://localhost:3002', {
          auth: {
            token: token
          },
          transports: ['websocket', 'polling']
        })

        newSocket.on('connect', () => {
          console.log('WebSocket conectado')
          setConnected(true)
          setError(null)
          reconnectAttempts.current = 0
        })

        newSocket.on('disconnect', (reason) => {
          console.log('WebSocket desconectado:', reason)
          setConnected(false)
          
          // Intentar reconectar si no fue una desconexión intencional
          if (reason !== 'io client disconnect' && reconnectAttempts.current < maxReconnectAttempts) {
            reconnectAttempts.current++
            const delay = Math.min(1000 * Math.pow(2, reconnectAttempts.current), 30000)
            
            reconnectTimeoutRef.current = setTimeout(() => {
              console.log(`Intentando reconectar... (${reconnectAttempts.current}/${maxReconnectAttempts})`)
              connect()
            }, delay)
          }
        })

        newSocket.on('connect_error', (error) => {
          console.error('Error de conexión WebSocket:', error)
          setError(error.message)
          setConnected(false)
        })

        setSocket(newSocket)
      } catch (error) {
        console.error('Error al crear WebSocket:', error)
        setError(error.message)
      }
    }

    connect()

    return () => {
      if (reconnectTimeoutRef.current) {
        clearTimeout(reconnectTimeoutRef.current)
      }
      if (socket) {
        socket.disconnect()
      }
    }
  }, [token, userRole])

  return { socket, connected, error }
}

export const useAdminWebSocket = (token) => {
  const { socket, connected, error } = useWebSocket(token, 'admin')
  const [dashboardData, setDashboardData] = useState(null)
  const [connectedAdmins, setConnectedAdmins] = useState([])
  const [adminChanges, setAdminChanges] = useState([])

  useEffect(() => {
    if (!socket || !connected) return

    // Escuchar datos del dashboard
    socket.on('dashboard_data', (data) => {
      console.log('Datos del dashboard recibidos:', data)
      setDashboardData(data)
    })

    // Escuchar actualizaciones del dashboard
    socket.on('dashboard_updated', (data) => {
      console.log('Dashboard actualizado:', data)
      setDashboardData(data)
    })

    // Escuchar administradores conectados
    socket.on('connected_admins', (admins) => {
      console.log('Administradores conectados:', admins)
      setConnectedAdmins(admins)
    })

    // Escuchar cambios importantes
    socket.on('admin_change', (change) => {
      console.log('Cambio importante detectado:', change)
      setAdminChanges(prev => [change, ...prev.slice(0, 9)]) // Mantener solo los últimos 10
    })

    // Escuchar errores del dashboard
    socket.on('dashboard_error', (error) => {
      console.error('Error del dashboard:', error)
    })

    // Solicitar datos iniciales
    socket.emit('request_dashboard_update')

    return () => {
      socket.off('dashboard_data')
      socket.off('dashboard_updated')
      socket.off('connected_admins')
      socket.off('admin_change')
      socket.off('dashboard_error')
    }
  }, [socket, connected])

  const refreshDashboard = () => {
    if (socket && connected) {
      socket.emit('force_dashboard_refresh')
    }
  }

  const requestDashboardUpdate = () => {
    if (socket && connected) {
      socket.emit('request_dashboard_update')
    }
  }

  return {
    socket,
    connected,
    error,
    dashboardData,
    connectedAdmins,
    adminChanges,
    refreshDashboard,
    requestDashboardUpdate
  }
}

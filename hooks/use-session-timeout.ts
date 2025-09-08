"use client"

import { useEffect, useRef, useState } from 'react'
import { useAuth } from './use-auth'
import { useRouter } from 'next/navigation'
import { toast } from './use-toast'

interface UseSessionTimeoutOptions {
  timeoutMinutes?: number
  warningMinutes?: number
  onTimeout?: () => void
  onWarning?: () => void
}

export function useSessionTimeout({
  timeoutMinutes = 15,
  warningMinutes = 2,
  onTimeout,
  onWarning
}: UseSessionTimeoutOptions = {}) {
  const { isAuthenticated, logout, updateToken } = useAuth()
  const router = useRouter()
  const [timeLeft, setTimeLeft] = useState<number>(0)
  const [showWarning, setShowWarning] = useState(false)
  const timeoutRef = useRef<NodeJS.Timeout | null>(null)
  const warningTimeoutRef = useRef<NodeJS.Timeout | null>(null)
  const lastActivityRef = useRef<number>(Date.now())

  const TIMEOUT_MS = timeoutMinutes * 60 * 1000
  const WARNING_MS = warningMinutes * 60 * 1000

  const resetTimer = () => {
    lastActivityRef.current = Date.now()
    setShowWarning(false)
    setTimeLeft(0)
    
    // Limpiar timeouts existentes
    if (timeoutRef.current) {
      clearTimeout(timeoutRef.current)
    }
    if (warningTimeoutRef.current) {
      clearTimeout(warningTimeoutRef.current)
    }

    if (!isAuthenticated) return

    // Configurar timeout de advertencia
    warningTimeoutRef.current = setTimeout(() => {
      setShowWarning(true)
      setTimeLeft(warningMinutes * 60)
      onWarning?.()
      
      toast({
        title: "Sesión por expirar",
        description: `Tu sesión expirará en ${warningMinutes} minutos por inactividad.`,
        variant: "destructive",
        duration: 10000
      })
    }, TIMEOUT_MS - WARNING_MS)

    // Configurar timeout final
    timeoutRef.current = setTimeout(() => {
      handleTimeout()
    }, TIMEOUT_MS)
  }

  const handleTimeout = () => {
    setShowWarning(false)
    setTimeLeft(0)
    
    toast({
      title: "Sesión expirada",
      description: "Tu sesión ha expirado por inactividad. Por favor, inicia sesión nuevamente.",
      variant: "destructive"
    })

    onTimeout?.()
    logout()
    router.push('/login?reason=timeout')
  }

  const extendSession = async () => {
    try {
      const token = localStorage.getItem("auth_token")
      if (!token) return

      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'}/api/auth/update-activity`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        }
      })

      if (response.ok) {
        const data = await response.json()
        if (data.success && data.data.token) {
          updateToken(data.data.token)
        }
      }
    } catch (error) {
      console.error('Error extending session:', error)
    }

    resetTimer()
    setShowWarning(false)
    setTimeLeft(0)
    
    toast({
      title: "Sesión extendida",
      description: "Tu sesión ha sido extendida exitosamente.",
    })
  }

  // Detectar actividad del usuario
  useEffect(() => {
    if (!isAuthenticated) return

    const events = ['mousedown', 'mousemove', 'keypress', 'scroll', 'touchstart', 'click']
    
    const handleActivity = () => {
      const now = Date.now()
      const timeSinceLastActivity = now - lastActivityRef.current
      
      // Solo resetear si han pasado al menos 30 segundos desde la última actividad
      if (timeSinceLastActivity > 30000) {
        resetTimer()
      }
    }

    events.forEach(event => {
      document.addEventListener(event, handleActivity, true)
    })

    // Inicializar timer
    resetTimer()

    return () => {
      events.forEach(event => {
        document.removeEventListener(event, handleActivity, true)
      })
      
      if (timeoutRef.current) {
        clearTimeout(timeoutRef.current)
      }
      if (warningTimeoutRef.current) {
        clearTimeout(warningTimeoutRef.current)
      }
    }
  }, [isAuthenticated])

  // Contador regresivo para la advertencia
  useEffect(() => {
    if (!showWarning || timeLeft <= 0) return

    const interval = setInterval(() => {
      setTimeLeft(prev => {
        if (prev <= 1) {
          setShowWarning(false)
          return 0
        }
        return prev - 1
      })
    }, 1000)

    return () => clearInterval(interval)
  }, [showWarning, timeLeft])

  return {
    timeLeft,
    showWarning,
    extendSession,
    isWarningActive: showWarning && timeLeft > 0
  }
}

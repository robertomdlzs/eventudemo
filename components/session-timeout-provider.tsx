"use client"

import { useSessionTimeout } from '@/hooks/use-session-timeout'
import { SessionTimeoutWarning } from './session-timeout-warning'
import { useState } from 'react'

interface SessionTimeoutProviderProps {
  children: React.ReactNode
}

export function SessionTimeoutProvider({ children }: SessionTimeoutProviderProps) {
  const [showWarning, setShowWarning] = useState(false)
  
  const { updateLastActivity, getMinutesSinceLastActivity } = useSessionTimeout({
    timeoutMinutes: 15,
    onTimeout: () => {
      setShowWarning(false)
    }
  })

  const handleExtendSession = () => {
    updateLastActivity()
    setShowWarning(false)
  }

  const handleCloseWarning = () => {
    setShowWarning(false)
  }

  return (
    <>
      {children}
      {showWarning && <SessionTimeoutWarning />}
    </>
  )
}

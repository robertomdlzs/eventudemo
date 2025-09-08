"use client"

import { useSessionTimeout } from '@/hooks/use-session-timeout'
import { SessionTimeoutWarning } from './session-timeout-warning'
import { useState } from 'react'

interface SessionTimeoutProviderProps {
  children: React.ReactNode
}

export function SessionTimeoutProvider({ children }: SessionTimeoutProviderProps) {
  const [showWarning, setShowWarning] = useState(false)
  
  const { timeLeft, isWarningActive, extendSession } = useSessionTimeout({
    timeoutMinutes: 15,
    warningMinutes: 2,
    onWarning: () => {
      setShowWarning(true)
    },
    onTimeout: () => {
      setShowWarning(false)
    }
  })

  const handleExtendSession = () => {
    extendSession()
    setShowWarning(false)
  }

  const handleCloseWarning = () => {
    setShowWarning(false)
  }

  return (
    <>
      {children}
      <SessionTimeoutWarning
        isOpen={showWarning && isWarningActive}
        timeLeft={timeLeft}
        onExtend={handleExtendSession}
        onClose={handleCloseWarning}
      />
    </>
  )
}

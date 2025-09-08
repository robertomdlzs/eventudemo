"use client"

import { useState } from 'react'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { AlertTriangle, Clock, RefreshCw } from 'lucide-react'
import { useSessionTimeout } from '@/hooks/use-session-timeout'

interface SessionTimeoutWarningProps {
  isOpen: boolean
  timeLeft: number
  onExtend: () => void
  onClose: () => void
}

export function SessionTimeoutWarning({ 
  isOpen, 
  timeLeft, 
  onExtend, 
  onClose 
}: SessionTimeoutWarningProps) {
  const [isExtending, setIsExtending] = useState(false)

  const formatTime = (seconds: number) => {
    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = seconds % 60
    return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`
  }

  const handleExtend = async () => {
    setIsExtending(true)
    try {
      onExtend()
      onClose()
    } finally {
      setIsExtending(false)
    }
  }

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2 text-orange-600">
            <AlertTriangle className="h-5 w-5" />
            Sesión por expirar
          </DialogTitle>
        </DialogHeader>
        
        <div className="space-y-4">
          <div className="text-center">
            <div className="flex items-center justify-center gap-2 mb-2">
              <Clock className="h-6 w-6 text-orange-500" />
              <span className="text-2xl font-bold text-orange-600">
                {formatTime(timeLeft)}
              </span>
            </div>
            <p className="text-sm text-gray-600">
              Tu sesión expirará por inactividad en:
            </p>
          </div>

          <div className="bg-orange-50 border border-orange-200 rounded-lg p-3">
            <p className="text-sm text-orange-800">
              Para mantener tu sesión activa, haz clic en "Extender sesión" o realiza alguna actividad en la página.
            </p>
          </div>

          <div className="flex gap-3">
            <Button
              onClick={handleExtend}
              disabled={isExtending}
              className="flex-1"
            >
              {isExtending ? (
                <>
                  <RefreshCw className="h-4 w-4 mr-2 animate-spin" />
                  Extendiendo...
                </>
              ) : (
                <>
                  <RefreshCw className="h-4 w-4 mr-2" />
                  Extender sesión
                </>
              )}
            </Button>
            <Button
              variant="outline"
              onClick={onClose}
              disabled={isExtending}
            >
              Cerrar
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  )
}

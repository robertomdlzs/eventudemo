import { useState, useEffect } from 'react'

interface User {
  id: number
  name: string
  email: string
  first_name?: string
  last_name?: string
  phone?: string
  role: string
  is_verified: boolean
  created_at: string
}

interface AuthState {
  isAuthenticated: boolean
  user: User | null
  token: string | null
  isLoading: boolean
}

export function useAuth(): AuthState {
  const [authState, setAuthState] = useState<AuthState>({
    isAuthenticated: false,
    user: null,
    token: null,
    isLoading: true
  })

  useEffect(() => {
    const checkAuth = () => {
      if (typeof window === 'undefined') {
        setAuthState(prev => ({ ...prev, isLoading: false }))
        return
      }

      const isAuth = localStorage.getItem("eventu_authenticated") === "true"
      const token = localStorage.getItem("auth_token")
      const userStr = localStorage.getItem("current_user")

      if (isAuth && token && userStr) {
        try {
          const user = JSON.parse(userStr)
          setAuthState({
            isAuthenticated: true,
            user,
            token,
            isLoading: false
          })
        } catch (error) {
          console.error('Error parsing user data:', error)
          setAuthState({
            isAuthenticated: false,
            user: null,
            token: null,
            isLoading: false
          })
        }
      } else {
        setAuthState({
          isAuthenticated: false,
          user: null,
          token: null,
          isLoading: false
        })
      }
    }

    checkAuth()

    // Listen for auth changes
    const handleAuthChange = () => checkAuth()
    window.addEventListener("authStateChanged", handleAuthChange)
    window.addEventListener("storage", handleAuthChange)

    return () => {
      window.removeEventListener("authStateChanged", handleAuthChange)
      window.removeEventListener("storage", handleAuthChange)
    }
  }, [])

  return authState
}

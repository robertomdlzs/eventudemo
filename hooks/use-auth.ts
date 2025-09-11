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

interface AuthActions {
  login: (user: User, token: string) => void
  logout: () => void
  updateToken: (token: string) => void
}

export function useAuth(): AuthState & AuthActions {
  const [authState, setAuthState] = useState<AuthState>({
    isAuthenticated: false,
    user: null,
    token: null,
    isLoading: true
  })

  useEffect(() => {
    const checkAuth = async () => {
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
          
          // Verificar si el token es válido con el backend (con manejo de errores robusto)
          try {
            const response = await fetch('http://localhost:3002/api/auth/verify-token', {
              method: 'GET',
              headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
              },
              // Agregar timeout para evitar que se cuelgue
              signal: AbortSignal.timeout(5000) // 5 segundos timeout
            })

            if (response.ok) {
              // Token válido, mantener la sesión
              setAuthState({
                isAuthenticated: true,
                user,
                token,
                isLoading: false
              })
            } else {
              // Token inválido, verificar si es por timeout de sesión
              const errorData = await response.json().catch(() => ({}))
              if (errorData.code === 'SESSION_TIMEOUT') {
                console.log('Sesión expirada por inactividad')
                // Limpiar localStorage y cerrar sesión
                localStorage.removeItem("eventu_authenticated")
                localStorage.removeItem("auth_token")
                localStorage.removeItem("current_user")
                localStorage.removeItem("userRole")
                localStorage.removeItem("eventu_user_id")
                localStorage.removeItem("redirectUrl")
                localStorage.removeItem("welcomeMessage")
                localStorage.removeItem("eventu_cart")
                localStorage.removeItem("eventu_cart_user_id")
                
                setAuthState({
                  isAuthenticated: false,
                  user: null,
                  token: null,
                  isLoading: false
                })
              } else {
                // Otro error, mantener la sesión local por seguridad
                console.warn('Error verificando token, manteniendo sesión local:', errorData.message)
                setAuthState({
                  isAuthenticated: true,
                  user,
                  token,
                  isLoading: false
                })
              }
            }
          } catch (error) {
            console.warn('Error de conectividad verificando token, manteniendo sesión local:', error)
            // En caso de error de red, mantener la sesión local
            setAuthState({
              isAuthenticated: true,
              user,
              token,
              isLoading: false
            })
          }
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

  const login = (user: User, token: string) => {
    if (typeof window === 'undefined') return
    
    localStorage.setItem("eventu_authenticated", "true")
    localStorage.setItem("auth_token", token)
    localStorage.setItem("current_user", JSON.stringify(user))
    
    setAuthState({
      isAuthenticated: true,
      user,
      token,
      isLoading: false
    })
    
    window.dispatchEvent(new Event("authStateChanged"))
  }

  const logout = () => {
    if (typeof window === 'undefined') return
    
    localStorage.removeItem("eventu_authenticated")
    localStorage.removeItem("auth_token")
    localStorage.removeItem("current_user")
    localStorage.removeItem("eventu_user_id")
    localStorage.removeItem("userRole")
    localStorage.removeItem("redirectUrl")
    localStorage.removeItem("welcomeMessage")
    // Limpiar carrito al hacer logout
    localStorage.removeItem("eventu_cart")
    localStorage.removeItem("eventu_cart_user_id")
    
    setAuthState({
      isAuthenticated: false,
      user: null,
      token: null,
      isLoading: false
    })
    
    window.dispatchEvent(new Event("authStateChanged"))
  }

  const updateToken = (token: string) => {
    if (typeof window === 'undefined') return
    
    localStorage.setItem("auth_token", token)
    
    setAuthState(prev => ({
      ...prev,
      token
    }))
  }

  return {
    ...authState,
    login,
    logout,
    updateToken
  }
}

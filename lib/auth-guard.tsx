"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { useToast } from "@/hooks/use-toast"

interface AuthGuardProps {
  children: React.ReactNode
  requiredRole?: "admin" | "organizer" | "user"
  fallbackUrl?: string
}

export function AuthGuard({ children, requiredRole, fallbackUrl = "/login" }: AuthGuardProps) {
  const [isLoading, setIsLoading] = useState(true)
  const [isAuthorized, setIsAuthorized] = useState(false)
  const router = useRouter()
  const { toast } = useToast()

  useEffect(() => {
    const checkAuth = () => {
      try {
        // Check if user is authenticated
        const isAuthenticated = localStorage.getItem("eventu_authenticated") === "true"
        const currentUser = localStorage.getItem("current_user")
        const userRole = localStorage.getItem("userRole")

        if (!isAuthenticated || !currentUser) {
          toast({
            title: "Acceso denegado",
            description: "Debes iniciar sesión para acceder a esta página.",
            variant: "destructive",
          })
          router.push(fallbackUrl)
          return
        }

        // If no specific role is required, just check authentication
        if (!requiredRole) {
          setIsAuthorized(true)
          setIsLoading(false)
          return
        }

        // Check role authorization
        if (userRole !== requiredRole) {
          toast({
            title: "Acceso denegado",
            description: `No tienes permisos para acceder a esta página. Se requiere rol: ${requiredRole}`,
            variant: "destructive",
          })
          
          // Redirect based on user's actual role
          const redirectUrl = getRedirectUrlByRole(userRole)
          router.push(redirectUrl)
          return
        }

        setIsAuthorized(true)
        setIsLoading(false)
      } catch (error) {
        console.error("Auth guard error:", error)
        toast({
          title: "Error de autenticación",
          description: "Hubo un problema al verificar tu sesión.",
          variant: "destructive",
        })
        router.push(fallbackUrl)
      }
    }

    checkAuth()
  }, [requiredRole, fallbackUrl, router, toast])

  const getRedirectUrlByRole = (role: string | null): string => {
    switch (role) {
      case "admin":
        return "/admin"
      case "organizer":
        return "/organizer"
      case "user":
      default:
        return "/mi-cuenta"
    }
  }

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-pink-600"></div>
      </div>
    )
  }

  if (!isAuthorized) {
    return null
  }

  return <>{children}</>
}

// Hook para verificar autenticación y rol
export function useAuth() {
  const [user, setUser] = useState<any>(null)
  const [role, setRole] = useState<string | null>(null)
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    const checkAuth = () => {
      try {
        const isAuthenticated = localStorage.getItem("eventu_authenticated") === "true"
        const currentUser = localStorage.getItem("current_user")
        const userRole = localStorage.getItem("userRole")

        if (isAuthenticated && currentUser) {
          setUser(JSON.parse(currentUser))
          setRole(userRole)
        }
      } catch (error) {
        console.error("useAuth error:", error)
      } finally {
        setIsLoading(false)
      }
    }

    checkAuth()

    // Listen for auth state changes
    const handleAuthChange = () => {
      checkAuth()
    }

    window.addEventListener("authStateChanged", handleAuthChange)
    return () => window.removeEventListener("authStateChanged", handleAuthChange)
  }, [])

  const logout = () => {
    localStorage.removeItem("auth_token")
    localStorage.removeItem("current_user")
    localStorage.removeItem("eventu_authenticated")
    localStorage.removeItem("redirectUrl")
    localStorage.removeItem("welcomeMessage")
    localStorage.removeItem("userRole")
    setUser(null)
    setRole(null)
    window.dispatchEvent(new Event("authStateChanged"))
  }

  return {
    user,
    role,
    isLoading,
    isAuthenticated: !!user,
    logout,
  }
}

// Componente para mostrar contenido basado en rol
interface RoleBasedContentProps {
  children: React.ReactNode
  roles: ("admin" | "organizer" | "user")[]
  fallback?: React.ReactNode
}

export function RoleBasedContent({ children, roles, fallback }: RoleBasedContentProps) {
  const { role } = useAuth()

  if (!role || !roles.includes(role as any)) {
    return fallback || null
  }

  return <>{children}</>
}

// Hook para verificar si el usuario tiene un rol específico
export function useHasRole(requiredRole: "admin" | "organizer" | "user") {
  const { role } = useAuth()
  return role === requiredRole
}

// Hook para verificar si el usuario tiene permisos de administrador
export function useIsAdmin() {
  return useHasRole("admin")
}

// Hook para verificar si el usuario tiene permisos de organizador
export function useIsOrganizer() {
  return useHasRole("organizer")
}

// Hook para verificar si el usuario es un cliente normal
export function useIsUser() {
  return useHasRole("user")
}

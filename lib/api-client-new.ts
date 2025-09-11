import { resolveBaseUrl } from "./utils"

const API_BASE_URL = resolveBaseUrl()

export interface ApiResponse<T> {
  success: boolean
  data?: T
  message?: string
  error?: string
  errors?: any
}

export interface User {
  id: number
  name: string
  email: string
  phone?: string
  role: string
  is_verified: boolean
  created_at: string
}

export interface LoginResponse {
  success: boolean
  user: User
  token: string
  error?: string
}

export class ApiClient {
  private baseUrl: string
  private token: string | null = null
  private currentUser: User | null = null

  constructor() {
    this.baseUrl = API_BASE_URL
    // Load token from localStorage if available
    if (typeof window !== "undefined") {
      this.token = localStorage.getItem("auth_token")
      const userData = localStorage.getItem("current_user")
      if (userData) {
        try {
          this.currentUser = JSON.parse(userData)
        } catch (error) {
          console.error("Failed to parse stored user data:", error)
          localStorage.removeItem("current_user")
        }
      }
    }
  }

  private getAuthHeaders(): Record<string, string> {
    const headers: Record<string, string> = {
      "Content-Type": "application/json",
    }

    if (this.token) {
      headers["Authorization"] = `Bearer ${this.token}`
    }

    return headers
  }

  private clearToken(): void {
    this.token = null
    this.currentUser = null
    if (typeof window !== "undefined") {
      localStorage.removeItem("auth_token")
      localStorage.removeItem("current_user")
      localStorage.removeItem("eventu_authenticated")
      localStorage.removeItem("eventu_user_id")
      localStorage.removeItem("userRole")
      localStorage.removeItem("redirectUrl")
      localStorage.removeItem("welcomeMessage")
      // Limpiar carrito al hacer logout
      localStorage.removeItem("eventu_cart")
      localStorage.removeItem("eventu_cart_user_id")
    }
  }

  private async request<T>(endpoint: string, options: RequestInit = {}): Promise<ApiResponse<T>> {
    const url = `${this.baseUrl}${endpoint}`

    const config: RequestInit = {
      headers: this.getAuthHeaders(),
      ...options,
      headers: {
        ...this.getAuthHeaders(),
        ...options.headers,
      },
    }

    try {
      const response = await fetch(url, config)

      if (!response.ok) {
        if (response.status === 401) {
          this.clearToken()
        }

        const errorData = await response.json().catch(() => ({}))
        throw new Error(errorData.message || `HTTP error! status: ${response.status}`)
      }

      const data = await response.json()
      return data
    } catch (error) {
      console.error(`API request failed (${url}):`, error)
      return {
        success: false,
        error: error instanceof Error ? error.message : "Unknown error occurred",
      }
    }
  }

  // Password Reset API
  async forgotPassword(email: string): Promise<ApiResponse<any>> {
    try {
      const response = await fetch(`${this.baseUrl}/password-reset/forgot-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email }),
      })

      const data = await response.json()
      return data
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : "Error al solicitar recuperación de contraseña",
      }
    }
  }

  async verifyResetToken(token: string): Promise<ApiResponse<any>> {
    try {
      const response = await fetch(`${this.baseUrl}/password-reset/verify-reset-token`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token }),
      })

      const data = await response.json()
      return data
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : "Error al verificar token",
      }
    }
  }

  async resetPassword(token: string, password: string): Promise<ApiResponse<any>> {
    try {
      const response = await fetch(`${this.baseUrl}/password-reset/reset-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ token, password }),
      })

      const data = await response.json()
      return data
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : "Error al restablecer contraseña",
      }
    }
  }

  // Authentication API
  async login(email: string, password: string): Promise<LoginResponse> {
    try {
      const response = await fetch(`${this.baseUrl}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      })

      const raw = await response.json()
      const payload = raw?.data || {}
      const user = payload?.user
      const token = payload?.token

      if (raw.success && user && token) {
        this.token = token
        this.currentUser = user

        if (typeof window !== "undefined") {
          localStorage.setItem("auth_token", token)
          localStorage.setItem("current_user", JSON.stringify(user))
          localStorage.setItem("eventu_authenticated", "true")
          
          // Store redirect information
          if (payload.redirectUrl) {
            localStorage.setItem("redirectUrl", payload.redirectUrl)
          }
          if (payload.welcomeMessage) {
            localStorage.setItem("welcomeMessage", payload.welcomeMessage)
          }
          if (payload.role) {
            localStorage.setItem("userRole", payload.role)
          }
          
          // Disparar evento para notificar otros componentes
          window.dispatchEvent(new Event("authStateChanged"))
        }
        return { success: true, user, token }
      }

      return {
        success: false,
        user: {} as User,
        token: "",
        error: raw?.message || "Login failed",
      }
    } catch (error) {
      return {
        success: false,
        user: {} as User,
        token: "",
        error: error instanceof Error ? error.message : "Login failed",
      }
    }
  }

  async logout(): Promise<void> {
    this.clearToken()
    window.dispatchEvent(new Event("authStateChanged"))
  }

  // Events API
  async getEvents(params?: any): Promise<ApiResponse<any[]>> {
    return this.request("/events", {
      method: "GET",
    })
  }

  async getFeaturedEvents(): Promise<ApiResponse<any[]>> {
    return this.request("/events/featured", {
      method: "GET",
    })
  }

  async getEvent(id: number): Promise<ApiResponse<any>> {
    return this.request(`/events/${id}`, {
      method: "GET",
    })
  }

  // Categories API
  async getCategories(): Promise<ApiResponse<any[]>> {
    return this.request("/categories", {
      method: "GET",
    })
  }

  // User Profile API
  async updateProfile(userData: any): Promise<ApiResponse<any>> {
    return this.request("/users/profile", {
      method: "PUT",
      body: JSON.stringify(userData),
    })
  }

  // Change Password API
  async changePassword(currentPassword: string, newPassword: string): Promise<ApiResponse<any>> {
    return this.request("/auth/change-password", {
      method: "POST",
      body: JSON.stringify({ currentPassword, newPassword }),
    })
  }
}

export const apiClient = new ApiClient()

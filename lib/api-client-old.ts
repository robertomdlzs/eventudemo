/**
 * API Client for Node.js Express backend
 */

/**
 * Resolve an absolute base URL for the Node.js backend.
 *
 * Priority:
 * 1. NEXT_PUBLIC_API_URL – manually configured endpoint (works everywhere).
 * 2. process.env.VERCEL_URL – automatic URL of the current deployment (SSR only).
 * 3. window.location.origin – browser fallback (CSR only).
 * 4. http://localhost:3001 – dev fallback for Node.js backend.
 */
const resolveBaseUrl = (): string => {
  const explicit = process.env.NEXT_PUBLIC_API_URL?.trim()
  if (explicit) {
    return explicit.replace(/\/+$/, "")
  }

  // During SSR in Vercel/Next JS the deployment hostname is exposed here
  const vercelHost = process.env.VERCEL_URL?.trim()
  if (vercelHost) {
    return `https://${vercelHost}/api`
  }

  // Client-side (browser) – use backend URL directly
  if (typeof window !== "undefined") {
    // Check if we're running on port 3001 (Next.js fallback)
    const currentPort = window.location.port
    if (currentPort === "3001") {
      return "http://localhost:3002/api"
    }
    return "http://localhost:3002/api"
  }

  // Local dev fallback - Node.js backend runs on port 3002
  return "http://localhost:3002/api"
}

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

  async register(userData: {
    name: string
    email: string
    phone?: string
    password: string
  }): Promise<LoginResponse> {
    try {
      const response = await fetch(`${this.baseUrl}/auth/register`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(userData),
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
        }
        return { success: true, user, token }
      }

      return {
        success: false,
        user: {} as User,
        token: "",
        error: raw?.message || "Registration failed",
      }
    } catch (error) {
      return {
        success: false,
        user: {} as User,
        token: "",
        error: error instanceof Error ? error.message : "Registration failed",
      }
    }
  }

  async getProfile(): Promise<ApiResponse<User>> {
    const result = await this.request<User>("/auth/profile")
    if (result.success && result.data) {
      this.currentUser = result.data
      if (typeof window !== "undefined") {
        localStorage.setItem("current_user", JSON.stringify(result.data))
      }
    }
    return result
  }

  async updateProfile(userData: Partial<User>): Promise<ApiResponse<User>> {
    const result = await this.request<User>("/auth/profile", {
      method: "PUT",
      body: JSON.stringify(userData),
    })
    if (result.success && result.data) {
      this.currentUser = result.data
      if (typeof window !== "undefined") {
        localStorage.setItem("current_user", JSON.stringify(result.data))
      }
    }
    return result
  }

  async changePassword(currentPassword: string, newPassword: string): Promise<ApiResponse<any>> {
    try {
      const response = await fetch(`${this.baseUrl}/auth/change-password`, {
        method: "POST",
        headers: this.getAuthHeaders(),
        body: JSON.stringify({ currentPassword, newPassword }),
      })

      const raw = await response.json()

      if (raw.success) {
        return {
          success: true,
          data: raw.data,
          message: raw.message,
        }
      }

      return {
        success: false,
        error: raw.message || "Failed to change password",
      }
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : "Failed to change password",
      }
    }
  }

  logout(): void {
    this.clearToken()
    if (typeof window !== "undefined") {
      localStorage.removeItem("eventu_authenticated")
      // Disparar evento para notificar otros componentes
      window.dispatchEvent(new Event("authStateChanged"))
    }
  }

  // Events API
  async getEvents(filters?: {
    category?: string
    search?: string
    featured?: boolean
  }): Promise<ApiResponse<any[]>> {
    const params = new URLSearchParams()

    if (filters?.category) params.append("category", filters.category)
    if (filters?.search) params.append("search", filters.search)
    if (filters?.featured) params.append("featured", "true")

    const queryString = params.toString()
    const endpoint = `/events${queryString ? `?${queryString}` : ""}`

    return this.request<any[]>(endpoint)
  }

  async getFeaturedEvents(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/events/featured")
  }

  async getEventById(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`)
  }

  async createEvent(eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>("/events", {
      method: "POST",
      body: JSON.stringify(eventData),
    })
  }

  async updateEvent(id: number, eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`, {
      method: "PUT",
      body: JSON.stringify(eventData),
    })
  }

  async deleteEvent(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`, {
      method: "DELETE",
    })
  }

  // Categories API
  async getCategories(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/categories")
  }

  // Seat Maps API
  async getSeatMaps(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/seat-maps")
  }

  async getSeatMap(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/seat-maps/${id}`)
  }

  async getSeatMapByEvent(eventId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/seat-maps/event/${eventId}`)
  }

  async createSeatMap(seatMapData: any): Promise<ApiResponse<any>> {
    return this.request<any>("/seat-maps", {
      method: "POST",
      body: JSON.stringify(seatMapData),
    })
  }

  async updateSeatMap(id: number, seatMapData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/seat-maps/${id}`, {
      method: "PUT",
      body: JSON.stringify(seatMapData),
    })
  }

  async deleteSeatMap(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/seat-maps/${id}`, {
      method: "DELETE",
    })
  }

  async getSeatMapTemplates(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/seat-maps/templates")
  }

  async reserveSeats(seatMapId: number, seatIds: number[], userId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/seat-maps/${seatMapId}/reserve`, {
      method: "POST",
      body: JSON.stringify({ seat_ids: seatIds, user_id: userId }),
    })
  }

  // Payments API
  async getPayments(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/payments")
  }

  async getUserPayments(userId: number): Promise<ApiResponse<any[]>> {
    return this.request<any[]>(`/payments/user/${userId}`)
  }

  // Tickets API
  async getUserTickets(userId: number): Promise<ApiResponse<any[]>> {
    return this.request<any[]>(`/tickets/user/${userId}`)
  }

  async generateTicketQR(ticketId: number, forceRegenerate?: boolean): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/generate-qr/${ticketId}`, {
      method: "POST",
      body: JSON.stringify({ forceRegenerate }),
    })
  }

  async downloadTicket(ticketId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/download/${ticketId}`)
  }

  // Events API
  async getEvents(filters?: any): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          queryParams.append(key, String(value))
        }
      })
    }
    const queryString = queryParams.toString()
    return this.request<any[]>(`/events${queryString ? `?${queryString}` : ''}`)
  }

  async getFeaturedEvents(limit?: number): Promise<ApiResponse<any[]>> {
    const queryString = limit ? `?limit=${limit}` : ''
    return this.request<any[]>(`/events/featured${queryString}`)
  }

  async getEvent(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`)
  }

  async createEvent(eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/events', {
      method: 'POST',
      body: JSON.stringify(eventData),
    })
  }

  async updateEvent(id: number, eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`, {
      method: 'PUT',
      body: JSON.stringify(eventData),
    })
  }

  async deleteEvent(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/events/${id}`, {
      method: 'DELETE',
    })
  }

  async getOrganizerEvents(organizerId: number): Promise<ApiResponse<any[]>> {
    return this.request<any[]>(`/events/organizer/${organizerId}`)
  }

  async processPayment(paymentData: {
    event_id: number
    amount: number
    payment_method: string
    payment_data?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>("/payments/process", {
      method: "POST",
      body: JSON.stringify(paymentData),
    })
  }

  async getPaymentById(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/payments/${id}`)
  }

  // Admin Payments Management
  async getAdminPayments(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>(`/admin/payments`)
  }

  async getAdminPayment(id: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/payments/${id}`)
  }

  async processAdminPayment(id: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/payments/${id}/process`, {
      method: 'POST'
    })
  }

  async refundAdminPayment(id: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/payments/${id}/refund`, {
      method: 'POST'
    })
  }

  async exportAdminPayments(): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/payments/export`)
  }

  // Users API (Admin only)
  async getUsers(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/users")
  }



  // Categories API
  async getCategories(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/categories")
  }

  async getCategory(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/categories/${id}`)
  }

  async createCategory(categoryData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/categories', {
      method: 'POST',
      body: JSON.stringify(categoryData),
    })
  }

  async updateCategory(id: number, categoryData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/categories/${id}`, {
      method: 'PUT',
      body: JSON.stringify(categoryData),
    })
  }

  async deleteCategory(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/categories/${id}`, {
      method: 'DELETE',
    })
  }

  // Ticket Types API
  async getTicketTypes(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/ticket-types")
  }

  async getTicketType(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/ticket-types/${id}`)
  }

  async createTicketType(ticketTypeData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/ticket-types', {
      method: 'POST',
      body: JSON.stringify(ticketTypeData),
    })
  }

  async updateTicketType(id: number, ticketTypeData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/ticket-types/${id}`, {
      method: 'PUT',
      body: JSON.stringify(ticketTypeData),
    })
  }

  async deleteTicketType(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/ticket-types/${id}`, {
      method: 'DELETE',
    })
  }

  // Tickets API
  async getTickets(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/tickets")
  }

  async getTicket(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/${id}`)
  }

  async createTicket(ticketData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/tickets', {
      method: 'POST',
      body: JSON.stringify(ticketData),
    })
  }

  async updateTicket(id: number, ticketData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/${id}`, {
      method: 'PUT',
      body: JSON.stringify(ticketData),
    })
  }

  async deleteTicket(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/${id}`, {
      method: 'DELETE',
    })
  }

  async validateTicket(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/${id}/validate`, {
      method: 'POST',
    })
  }

  async resendTicket(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/tickets/${id}/resend`, {
      method: 'POST',
    })
  }

  // Sales API
  async getSales(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/sales")
  }

  // Media API
  async getMedia(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/media")
  }

  async getMediaItem(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/media/${id}`)
  }

  async createMedia(mediaData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/media', {
      method: 'POST',
      body: JSON.stringify(mediaData),
    })
  }

  async updateMedia(id: number, mediaData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/media/${id}`, {
      method: 'PUT',
      body: JSON.stringify(mediaData),
    })
  }

  async deleteMedia(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/media/${id}`, {
      method: 'DELETE',
    })
  }

  async uploadMedia(formData: FormData): Promise<ApiResponse<any>> {
    return this.request<any>('/media/upload', {
      method: 'POST',
      body: formData,
      headers: {
        // Don't set Content-Type for FormData, let the browser set it
      },
    })
  }

  // Media Folders API
  async getMediaFolders(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/media/folders")
  }

  async createMediaFolder(folderData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/media/folders', {
      method: 'POST',
      body: JSON.stringify(folderData),
    })
  }

  async deleteMediaFolder(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/media/folders/${id}`, {
      method: 'DELETE',
    })
  }

  // Reports API
  async getAnalytics(): Promise<ApiResponse<any>> {
    return this.request<any>("/reports/analytics")
  }

  async getSalesReport(filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          queryParams.append(key, String(value))
        }
      })
    }
    const queryString = queryParams.toString()
    return this.request<any>(`/reports/sales${queryString ? `?${queryString}` : ''}`)
  }

  async getEventsReport(filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          queryParams.append(key, String(value))
        }
      })
    }
    const queryString = queryParams.toString()
    return this.request<any>(`/reports/events${queryString ? `?${queryString}` : ''}`)
  }

  async getUsersReport(filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters) {
      Object.entries(filters).forEach(([key, value]) => {
        if (value !== undefined && value !== null) {
          queryParams.append(key, String(value))
        }
      })
    }
    const queryString = queryParams.toString()
    return this.request<any>(`/reports/users${queryString ? `?${queryString}` : ''}`)
  }

  async generateReport(reportType: string, filters?: any): Promise<ApiResponse<any>> {
    return this.request<any>('/reports/generate', {
      method: 'POST',
      body: JSON.stringify({ type: reportType, filters }),
    })
  }

  async exportReport(reportId: string, format: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/reports/${reportId}/export`, {
      method: 'POST',
      body: JSON.stringify({ format }),
    })
  }

  async getSavedReports(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>("/reports/saved")
  }

  async saveReport(reportData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/reports/save', {
      method: 'POST',
      body: JSON.stringify(reportData),
    })
  }

  async deleteSavedReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/reports/saved/${id}`, {
      method: 'DELETE',
    })
  }

  // Quick Reports API
  async getDailySalesReport(): Promise<ApiResponse<any>> {
    return this.request<any>("/reports/quick/daily-sales")
  }

  async getTopEventsReport(): Promise<ApiResponse<any>> {
    return this.request<any>("/reports/quick/top-events")
  }

  async getTrendsReport(): Promise<ApiResponse<any>> {
    return this.request<any>("/reports/quick/trends")
  }

  async getCompleteReport(): Promise<ApiResponse<any>> {
    return this.request<any>("/reports/quick/complete")
  }

  // Settings API
  async getSettings(): Promise<ApiResponse<any>> {
    return this.request<any>("/settings")
  }

  async updateSettings(settingsData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/settings', {
      method: 'PUT',
      body: JSON.stringify(settingsData),
    })
  }

  async getSetting(key: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/settings/${key}`)
  }

  async updateSetting(key: string, value: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/settings/${key}`, {
      method: 'PUT',
      body: JSON.stringify({ value }),
    })
  }

  async resetSettings(): Promise<ApiResponse<any>> {
    return this.request<any>('/settings/reset', {
      method: 'POST',
    })
  }

  async exportSettings(): Promise<ApiResponse<any>> {
    return this.request<any>('/settings/export', {
      method: 'POST',
    })
  }

  async importSettings(file: File): Promise<ApiResponse<any>> {
    const formData = new FormData()
    formData.append('file', file)
    
    return this.request<any>('/settings/import', {
      method: 'POST',
      body: formData,
      headers: {
        // Don't set Content-Type for FormData, let the browser set it
      },
    })
  }

  // ===== ADMIN API =====

  // Dashboard Stats
  async getAdminDashboardStats(): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/dashboard-stats')
  }

  // Users Management
  async getAdminUsers(params?: {
    page?: number
    limit?: number
    role?: string
    status?: string
    search?: string
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())
    if (params?.role) queryParams.append('role', params.role)
    if (params?.status) queryParams.append('status', params.status)
    if (params?.search) queryParams.append('search', params.search)

    return this.request<any>(`/admin/users?${queryParams.toString()}`)
  }

  async getAdminUser(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/users/${id}`)
  }

  async updateAdminUser(id: number, userData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/users/${id}`, {
      method: 'PUT',
      body: JSON.stringify(userData)
    })
  }

  async deleteAdminUser(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/users/${id}`, {
      method: 'DELETE'
    })
  }

  // Events Management
  async getAdminEvents(params?: {
    page?: number
    limit?: number
    status?: string
    category_id?: number
    organizer_id?: number
    search?: string
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())
    if (params?.status) queryParams.append('status', params.status)
    if (params?.category_id) queryParams.append('category_id', params.category_id.toString())
    if (params?.organizer_id) queryParams.append('organizer_id', params.organizer_id.toString())
    if (params?.search) queryParams.append('search', params.search)

    return this.request<any>(`/admin/events?${queryParams.toString()}`)
  }

  async updateAdminEventStatus(id: number, status: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/events/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status })
    })
  }

  async getAdminEvent(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/events/${id}`)
  }

  async createAdminEvent(eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/events', {
      method: 'POST',
      body: JSON.stringify(eventData)
    })
  }

  async updateAdminEvent(id: number, eventData: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/events/${id}`, {
      method: 'PUT',
      body: JSON.stringify(eventData)
    })
  }

  async deleteAdminEvent(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/events/${id}`, {
      method: 'DELETE'
    })
  }

  // Sales Management
  async getAdminSales(params?: {
    page?: number
    limit?: number
    status?: string
    event_id?: number
    payment_method?: string
    search?: string
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())
    if (params?.status) queryParams.append('status', params.status)
    if (params?.event_id) queryParams.append('event_id', params.event_id.toString())
    if (params?.payment_method) queryParams.append('payment_method', params.payment_method)
    if (params?.search) queryParams.append('search', params.search)

    return this.request<any>(`/admin/sales?${queryParams.toString()}`)
  }

  async getAdminSale(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/sales/${id}`)
  }

  async updateAdminSaleStatus(id: number, status: string): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/sales/${id}/status`, {
      method: 'PUT',
      body: JSON.stringify({ status })
    })
  }

  // Check-in Management
  async performCheckIn(saleId: number, checkInData: {
    operator: string
    gate?: string
    notes?: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>(`/organizer/checkin/${saleId}`, {
      method: 'POST',
      body: JSON.stringify(checkInData)
    })
  }

  // Admin Check-in Management
  async getAdminCheckInRecords(): Promise<ApiResponse<any[]>> {
    return this.request<any[]>(`/admin/check-in/records`)
  }

  async createAdminCheckIn(checkInData: {
    ticketNumber: string
    eventName: string
    gate: string
    operator: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/check-in`, {
      method: 'POST',
      body: JSON.stringify(checkInData)
    })
  }

  async exportAdminCheckInRecords(): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/check-in/export`)
  }

  // Advanced Reports
  async getAdminAnalytics(period?: string): Promise<ApiResponse<any>> {
    const queryParams = period ? `?period=${period}` : ''
    return this.request<any>(`/admin/analytics${queryParams}`)
  }

  async getAdminSalesReport(filters?: {
    start_date?: string
    end_date?: string
    event_id?: number
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.start_date) queryParams.append('start_date', filters.start_date)
    if (filters?.end_date) queryParams.append('end_date', filters.end_date)
    if (filters?.event_id) queryParams.append('event_id', filters.event_id.toString())

    return this.request<any>(`/admin/reports/sales?${queryParams.toString()}`)
  }

  async getAdminEventsReport(filters?: {
    status?: string
    organizer_id?: number
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.status) queryParams.append('status', filters.status)
    if (filters?.organizer_id) queryParams.append('organizer_id', filters.organizer_id.toString())

    return this.request<any>(`/admin/reports/events?${queryParams.toString()}`)
  }

  async getAdminUsersReport(filters?: {
    role?: string
    status?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.role) queryParams.append('role', filters.role)
    if (filters?.status) queryParams.append('status', filters.status)

    return this.request<any>(`/admin/reports/users?${queryParams.toString()}`)
  }

  async generateAdminReport(reportData: {
    type: string
    filters?: any
    format?: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/reports/generate', {
      method: 'POST',
      body: JSON.stringify(reportData)
    })
  }

  // 2FA Management
  async enable2FA(): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/2fa/enable', {
      method: 'POST'
    })
  }

  async verify2FA(code: string): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/2fa/verify', {
      method: 'POST',
      body: JSON.stringify({ code })
    })
  }

  async disable2FA(code: string): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/2fa/disable', {
      method: 'POST',
      body: JSON.stringify({ code })
    })
  }

  async get2FAStatus(): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/2fa/status')
  }

  // Saved Reports Management
  async getSavedReports(userId?: number): Promise<ApiResponse<any[]>> {
    const queryParams = userId ? `?user_id=${userId}` : ''
    return this.request<any>(`/admin/reports/saved${queryParams}`)
  }

  async saveReport(reportData: {
    name: string
    description?: string
    type: string
    filters?: any
    schedule?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/reports/saved', {
      method: 'POST',
      body: JSON.stringify(reportData)
    })
  }

  async updateSavedReport(id: number, reportData: {
    name: string
    description?: string
    filters?: any
    schedule?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/saved/${id}`, {
      method: 'PUT',
      body: JSON.stringify(reportData)
    })
  }

  async deleteSavedReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/saved/${id}`, {
      method: 'DELETE'
    })
  }

  async runSavedReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/saved/${id}/run`, {
      method: 'POST'
    })
  }

  // Scheduled Reports Management
  async getScheduledReports(status?: string): Promise<ApiResponse<any[]>> {
    const queryParams = status ? `?status=${status}` : ''
    return this.request<any>(`/admin/reports/scheduled${queryParams}`)
  }

  async createScheduledReport(reportData: {
    name: string
    description?: string
    type: string
    schedule: any
    recipients?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/reports/scheduled', {
      method: 'POST',
      body: JSON.stringify(reportData)
    })
  }

  async updateScheduledReport(id: number, reportData: {
    name: string
    description?: string
    schedule?: any
    recipients?: any
    status?: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/scheduled/${id}`, {
      method: 'PUT',
      body: JSON.stringify(reportData)
    })
  }

  async deleteScheduledReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/scheduled/${id}`, {
      method: 'DELETE'
    })
  }

  async toggleScheduledReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/reports/scheduled/${id}/toggle`, {
      method: 'POST'
    })
  }

  // Audit Logs Management
  async getAuditLogs(params?: {
    page?: number
    limit?: number
    user_id?: number
    action?: string
    module?: string
    start_date?: string
    end_date?: string
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())
    if (params?.user_id) queryParams.append('user_id', params.user_id.toString())
    if (params?.action) queryParams.append('action', params.action)
    if (params?.module) queryParams.append('module', params.module)
    if (params?.start_date) queryParams.append('start_date', params.start_date)
    if (params?.end_date) queryParams.append('end_date', params.end_date)

    return this.request<any>(`/admin/audit-logs?${queryParams.toString()}`)
  }

  async createAuditLog(auditData: {
    user_id: number
    action: string
    module: string
    description: string
    ip_address?: string
    user_agent?: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/audit-logs', {
      method: 'POST',
      body: JSON.stringify(auditData)
    })
  }

  async exportAuditLogs(params?: {
    format?: string
    start_date?: string
    end_date?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.format) queryParams.append('format', params.format)
    if (params?.start_date) queryParams.append('start_date', params.start_date)
    if (params?.end_date) queryParams.append('end_date', params.end_date)

    return this.request<any>(`/admin/audit-logs/export?${queryParams.toString()}`)
  }

  // Backup Management
  async getBackups(params?: {
    page?: number
    limit?: number
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())

    return this.request<any>(`/admin/backup?${queryParams.toString()}`)
  }

  async createBackup(backupData: {
    type?: string
    description?: string
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/backup/create', {
      method: 'POST',
      body: JSON.stringify(backupData)
    })
  }

  async downloadBackup(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/backup/${id}/download`)
  }

  async deleteBackup(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/backup/${id}`, {
      method: 'DELETE'
    })
  }

  async scheduleBackup(scheduleData: {
    frequency: string
    time: string
    type?: string
    enabled?: boolean
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/backup/schedule', {
      method: 'POST',
      body: JSON.stringify(scheduleData)
    })
  }

  // Notifications Management
  async getNotifications(params?: {
    page?: number
    limit?: number
    unread_only?: boolean
  }): Promise<ApiResponse<any[]>> {
    const queryParams = new URLSearchParams()
    if (params?.page) queryParams.append('page', params.page.toString())
    if (params?.limit) queryParams.append('limit', params.limit.toString())
    if (params?.unread_only) queryParams.append('unread_only', params.unread_only.toString())

    return this.request<any>(`/admin/notifications?${queryParams.toString()}`)
  }

  async createNotification(notificationData: {
    user_id: number
    title: string
    message: string
    type?: string
    data?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/notifications', {
      method: 'POST',
      body: JSON.stringify(notificationData)
    })
  }

  async markNotificationAsRead(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/notifications/${id}/read`, {
      method: 'PUT'
    })
  }

  async markAllNotificationsAsRead(): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/notifications/read-all', {
      method: 'PUT'
    })
  }

  async deleteNotification(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/admin/notifications/${id}`, {
      method: 'DELETE'
    })
  }

  async broadcastNotification(broadcastData: {
    title: string
    message: string
    type?: string
    data?: any
    user_roles?: string[]
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/admin/notifications/broadcast', {
      method: 'POST',
      body: JSON.stringify(broadcastData)
    })
  }

  // ===== REPORTS API =====
  // Sales Reports
  async getSalesReport(params?: {
    startDate?: string
    endDate?: string
    eventId?: string
    categoryId?: string
    paymentMethod?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.startDate) queryParams.append('startDate', params.startDate)
    if (params?.endDate) queryParams.append('endDate', params.endDate)
    if (params?.eventId) queryParams.append('eventId', params.eventId)
    if (params?.categoryId) queryParams.append('categoryId', params.categoryId)
    if (params?.paymentMethod) queryParams.append('paymentMethod', params.paymentMethod)
    
    return this.request<any>(`/reports/sales?${queryParams.toString()}`)
  }

  // Events Reports
  async getEventsReport(params?: {
    startDate?: string
    endDate?: string
    categoryId?: string
    status?: string
    organizerId?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.startDate) queryParams.append('startDate', params.startDate)
    if (params?.endDate) queryParams.append('endDate', params.endDate)
    if (params?.categoryId) queryParams.append('categoryId', params.categoryId)
    if (params?.status) queryParams.append('status', params.status)
    if (params?.organizerId) queryParams.append('organizerId', params.organizerId)
    
    return this.request<any>(`/reports/events?${queryParams.toString()}`)
  }

  // Users Reports
  async getUsersReport(params?: {
    startDate?: string
    endDate?: string
    role?: string
    status?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.startDate) queryParams.append('startDate', params.startDate)
    if (params?.endDate) queryParams.append('endDate', params.endDate)
    if (params?.role) queryParams.append('role', params.role)
    if (params?.status) queryParams.append('status', params.status)
    
    return this.request<any>(`/reports/users?${queryParams.toString()}`)
  }

  // Financial Reports
  async getFinancialReport(params?: {
    startDate?: string
    endDate?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.startDate) queryParams.append('startDate', params.startDate)
    if (params?.endDate) queryParams.append('endDate', params.endDate)
    
    return this.request<any>(`/reports/financial?${queryParams.toString()}`)
  }

  // ===== ANALYTICS API =====
  // Performance Metrics
  async getPerformanceMetrics(params?: {
    period?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.period) queryParams.append('period', params.period)
    
    return this.request<any>(`/analytics/performance?${queryParams.toString()}`)
  }

  // Market Trends
  async getMarketTrends(params?: {
    period?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.period) queryParams.append('period', params.period)
    
    return this.request<any>(`/analytics/trends?${queryParams.toString()}`)
  }

  // Behavior Analysis
  async getBehaviorAnalysis(params?: {
    period?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.period) queryParams.append('period', params.period)
    
    return this.request<any>(`/analytics/behavior?${queryParams.toString()}`)
  }

  // Sales Predictions
  async getSalesPredictions(params?: {
    days?: string
  }): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (params?.days) queryParams.append('days', params.days)
    
    return this.request<any>(`/analytics/predictions?${queryParams.toString()}`)
  }

  // ===== EXPORT API =====
  // Export to PDF
  async exportToPDF(data: {
    reportType: string
    filters?: any
    data: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/export/pdf', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // Export to Excel
  async exportToExcel(data: {
    reportType: string
    filters?: any
    data: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/export/excel', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // Export to CSV
  async exportToCSV(data: {
    reportType: string
    filters?: any
    data: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/export/csv', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // Get Scheduled Reports
  async getScheduledReports(): Promise<ApiResponse<any[]>> {
    return this.request<any>('/export/scheduled')
  }

  // Create Scheduled Report
  async createScheduledReport(data: {
    name: string
    type: string
    format: string
    frequency: string
    recipients: string[]
    filters?: any
  }): Promise<ApiResponse<any>> {
    return this.request<any>('/export/scheduled', {
      method: 'POST',
      body: JSON.stringify(data)
    })
  }

  // Update Scheduled Report
  async updateScheduledReport(id: number, data: any): Promise<ApiResponse<any>> {
    return this.request<any>(`/export/scheduled/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data)
    })
  }

  // Delete Scheduled Report
  async deleteScheduledReport(id: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/export/scheduled/${id}`, {
      method: 'DELETE'
    })
  }

  // ===== ORGANIZER API =====

  // Dashboard Stats
  async getOrganizerDashboardStats(organizerId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/organizer/dashboard-stats/${organizerId}`)
  }

  // Sales Realtime
  async getOrganizerSalesRealtime(organizerId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/organizer/sales-realtime/${organizerId}`)
  }

  // Organizer Events
  async getOrganizerEvents(organizerId: number, filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.status) queryParams.append('status', filters.status)
    if (filters?.category) queryParams.append('category', filters.category)
    if (filters?.search) queryParams.append('search', filters.search)
    
    return this.request<any>(`/organizer/events/${organizerId}?${queryParams.toString()}`)
  }

  // Organizer Sales
  async getOrganizerSales(organizerId: number, filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.eventId) queryParams.append('eventId', filters.eventId.toString())
    if (filters?.startDate) queryParams.append('startDate', filters.startDate)
    if (filters?.endDate) queryParams.append('endDate', filters.endDate)
    if (filters?.status) queryParams.append('status', filters.status)
    
    return this.request<any>(`/organizer/sales/${organizerId}?${queryParams.toString()}`)
  }

  // Organizer Attendees
  async getOrganizerAttendees(organizerId: number, filters?: any): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (filters?.eventId) queryParams.append('eventId', filters.eventId.toString())
    if (filters?.search) queryParams.append('search', filters.search)
    if (filters?.status) queryParams.append('status', filters.status)
    
    return this.request<any>(`/organizer/attendees/${organizerId}?${queryParams.toString()}`)
  }

  // Check-in
  async performCheckIn(saleId: string, organizerId: number): Promise<ApiResponse<any>> {
    return this.request<any>(`/organizer/checkin/${saleId}`, {
      method: 'POST',
      body: JSON.stringify({ organizerId }),
    })
  }

  // Analytics
  async getOrganizerAnalytics(organizerId: number, period?: number): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    if (period) queryParams.append('period', period.toString())
    
    return this.request<any>(`/organizer/analytics/${organizerId}?${queryParams.toString()}`)
  }

  // Reports
  async getOrganizerReports(organizerId: number, type: string, startDate: string, endDate: string): Promise<ApiResponse<any>> {
    const queryParams = new URLSearchParams()
    queryParams.append('type', type)
    queryParams.append('startDate', startDate)
    queryParams.append('endDate', endDate)
    
    return this.request<any>(`/organizer/reports/${organizerId}?${queryParams.toString()}`)
  }

  // Utility methods
  isAuthenticated(): boolean {
    return !!this.token
  }

  getCurrentUser(): User | null {
    return this.currentUser
  }

  async refreshUserData(): Promise<User | null> {
    if (!this.isAuthenticated()) {
      return null
    }

    const result = await this.getProfile()
    return result.success ? result.data || null : null
  }
}

// Export singleton instance
export const apiClient = new ApiClient()

// Export utility functions for backward compatibility
export const loginUser = (email: string, password: string) => apiClient.login(email, password)
export const registerUser = (userData: any) => apiClient.register(userData)
export const getAllEvents = () => apiClient.getEvents()
export const getFeaturedEvents = () => apiClient.getFeaturedEvents()
export const getCategories = () => apiClient.getCategories()

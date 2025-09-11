import { useState, useEffect } from 'react'
import { trackAddToCart, trackEvent } from '@/lib/analytics'

export interface CartItem {
  id: string
  eventId: string
  eventTitle: string
  eventSlug: string
  ticketTypeId: string
  ticketTypeName: string
  quantity: number
  price: number
  selectedSeats?: string[]
  eventDate?: string
  eventLocation?: string
}

export interface Cart {
  items: CartItem[]
  total: number
}

const CART_STORAGE_KEY = 'eventu_cart'
const CART_USER_KEY = 'eventu_cart_user_id'

export function useCart() {
  const [cart, setCart] = useState<Cart>(() => {
    // Inicializar el estado con datos del localStorage si están disponibles
    if (typeof window !== 'undefined') {
      const savedCart = localStorage.getItem(CART_STORAGE_KEY)
      const savedUserId = localStorage.getItem(CART_USER_KEY)
      const currentUserId = localStorage.getItem("eventu_user_id")
      
      // Solo cargar el carrito si pertenece al usuario actual
      if (savedCart && savedUserId === currentUserId) {
        try {
          const parsedCart = JSON.parse(savedCart)
          console.log('Carrito cargado desde localStorage:', parsedCart)
          // Asegurar que el carrito tenga la estructura correcta
          return {
            items: parsedCart.items || [],
            total: parsedCart.total || 0
          }
        } catch (error) {
          console.error('Error loading cart from localStorage:', error)
          localStorage.removeItem(CART_STORAGE_KEY)
          localStorage.removeItem(CART_USER_KEY)
        }
      } else if (savedCart && savedUserId !== currentUserId) {
        // El carrito pertenece a otro usuario, limpiarlo
        console.log('Carrito de otro usuario detectado, limpiando...')
        localStorage.removeItem(CART_STORAGE_KEY)
        localStorage.removeItem(CART_USER_KEY)
      }
    }
    return { items: [], total: 0 }
  })

  // Recalcular total si es necesario al cargar
  useEffect(() => {
    if (cart.total === null || cart.total === undefined) {
      const newTotal = recalculateTotal(cart.items)
      setCart(prev => ({ ...prev, total: newTotal }))
    }
  }, [cart.items, cart.total])

  // Guardar carrito en localStorage cuando cambie
  useEffect(() => {
    if (typeof window !== 'undefined') {
      const currentUserId = localStorage.getItem("eventu_user_id")
      if (currentUserId) {
        console.log('Guardando carrito en localStorage:', cart)
        localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(cart))
        localStorage.setItem(CART_USER_KEY, currentUserId)
        // Disparar evento para notificar otros componentes
        window.dispatchEvent(new Event('cartUpdated'))
      }
    }
  }, [cart])

  // Escuchar cambios de autenticación para limpiar el carrito
  useEffect(() => {
    if (typeof window === 'undefined') return

    const handleAuthChange = () => {
      const isAuthenticated = localStorage.getItem("eventu_authenticated") === "true"
      const currentUser = localStorage.getItem("current_user")
      const currentUserId = localStorage.getItem("eventu_user_id")
      const savedUserId = localStorage.getItem(CART_USER_KEY)
      
      // Si no hay usuario autenticado, limpiar el carrito
      if (!isAuthenticated || !currentUser || !currentUserId) {
        console.log('Usuario no autenticado, limpiando carrito')
        setCart({ items: [], total: 0 })
        localStorage.removeItem(CART_STORAGE_KEY)
        localStorage.removeItem(CART_USER_KEY)
      } else if (savedUserId && savedUserId !== currentUserId) {
        // El usuario cambió, limpiar el carrito del usuario anterior
        console.log('Usuario cambió, limpiando carrito del usuario anterior')
        setCart({ items: [], total: 0 })
        localStorage.removeItem(CART_STORAGE_KEY)
        localStorage.removeItem(CART_USER_KEY)
      }
    }

    // Escuchar eventos de cambio de autenticación
    window.addEventListener("authStateChanged", handleAuthChange)
    
    // Verificar estado inicial
    handleAuthChange()

    return () => {
      window.removeEventListener("authStateChanged", handleAuthChange)
    }
  }, [])

  const addToCart = (item: Omit<CartItem, 'id'>) => {
    console.log('addToCart llamado con:', item)
    
    // Track add to cart event
    trackAddToCart(
      item.eventId.toString(),
      item.eventTitle || 'Evento',
      item.price,
      item.quantity
    )
    
    const newItem: CartItem = {
      ...item,
      id: `${item.eventId}-${item.ticketTypeId}-${Date.now()}`
    }

    console.log('Nuevo item creado:', newItem)

    setCart(prevCart => {
      console.log('Estado anterior del carrito:', prevCart)
      
      // Verificar si ya existe un item similar
      const existingItemIndex = prevCart.items.findIndex(
        cartItem => 
          cartItem.eventId === item.eventId && 
          cartItem.ticketTypeId === item.ticketTypeId
      )

      if (existingItemIndex >= 0) {
        // Actualizar cantidad del item existente
        const updatedItems = [...prevCart.items]
        updatedItems[existingItemIndex] = {
          ...updatedItems[existingItemIndex],
          quantity: updatedItems[existingItemIndex].quantity + item.quantity,
          selectedSeats: item.selectedSeats || updatedItems[existingItemIndex].selectedSeats
        }
        
        const newCart = {
          items: updatedItems,
          total: updatedItems.reduce((sum, item) => sum + ((item.price || 0) * (item.quantity || 1)), 0)
        }
        
        console.log('Carrito actualizado (item existente):', newCart)
        return newCart
      } else {
        // Agregar nuevo item
        const newItems = [...prevCart.items, newItem]
        const newCart = {
          items: newItems,
          total: newItems.reduce((sum, item) => sum + ((item.price || 0) * (item.quantity || 1)), 0)
        }
        
        console.log('Carrito actualizado (nuevo item):', newCart)
        return newCart
      }
    })
  }

  const updateCartItem = (itemId: string, updates: Partial<CartItem>) => {
    setCart(prevCart => {
      const updatedItems = prevCart.items.map(item => 
        item.id === itemId ? { ...item, ...updates } : item
      )
      
      return {
        items: updatedItems,
        total: updatedItems.reduce((sum, item) => sum + ((item.price || 0) * (item.quantity || 1)), 0)
      }
    })
  }

  const removeFromCart = (itemId: string) => {
    setCart(prevCart => {
      const updatedItems = prevCart.items.filter(item => item.id !== itemId)
      
      return {
        items: updatedItems,
        total: updatedItems.reduce((sum, item) => sum + ((item.price || 0) * (item.quantity || 1)), 0)
      }
    })
  }

  const clearCart = () => {
    setCart({ items: [], total: 0 })
    localStorage.removeItem(CART_STORAGE_KEY)
    localStorage.removeItem(CART_USER_KEY)
  }

  // Función para recalcular el total del carrito
  const recalculateTotal = (items: CartItem[]) => {
    return items.reduce((sum, item) => sum + ((item.price || 0) * (item.quantity || 1)), 0)
  }

  const getCartItemCount = () => {
    return cart.items.reduce((sum, item) => sum + item.quantity, 0)
  }

  const getCartItemById = (itemId: string) => {
    return cart.items.find(item => item.id === itemId)
  }

  const getCartItemsByEvent = (eventId: string) => {
    return cart.items.filter(item => item.eventId === eventId)
  }

  return {
    cart,
    addToCart,
    updateCartItem,
    removeFromCart,
    clearCart,
    getCartItemCount,
    getCartItemById,
    getCartItemsByEvent
  }
}

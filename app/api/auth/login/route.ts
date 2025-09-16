import { NextRequest, NextResponse } from 'next/server'

// Usuarios mock para autenticación
const mockUsers = [
  {
    id: "1",
    email: "admin@eventu.com",
    password: "admin123", // En producción, esto sería un hash
    name: "Administrador",
    role: "admin"
  },
  {
    id: "2",
    email: "organizer@eventu.com",
    password: "organizer123",
    name: "Organizador",
    role: "organizer"
  },
  {
    id: "3",
    email: "user@eventu.com",
    password: "user123",
    name: "Usuario",
    role: "user"
  }
]

export async function POST(request: NextRequest) {
  try {
    const { email, password } = await request.json()
    
    if (!email || !password) {
      return NextResponse.json(
        { 
          success: false, 
          message: "Email y contraseña son requeridos" 
        },
        { status: 400 }
      )
    }
    
    // Buscar usuario
    const user = mockUsers.find(u => u.email === email && u.password === password)
    
    if (!user) {
      return NextResponse.json(
        { 
          success: false, 
          message: "Credenciales inválidas" 
        },
        { status: 401 }
      )
    }
    
    // Simular token JWT (en producción usarías una librería real)
    const token = Buffer.from(JSON.stringify({
      userId: user.id,
      email: user.email,
      role: user.role,
      exp: Date.now() + 24 * 60 * 60 * 1000 // 24 horas
    })).toString('base64')
    
    return NextResponse.json({
      success: true,
      message: "Login exitoso",
      data: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          role: user.role
        },
        token
      }
    })
  } catch (error) {
    return NextResponse.json(
      { 
        success: false, 
        error: 'Error en el login' 
      },
      { status: 500 }
    )
  }
}

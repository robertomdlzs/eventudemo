import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  // Manejar rutas de API
  if (request.nextUrl.pathname.startsWith('/api/')) {
    // Redirigir las llamadas API al backend
    const backendUrl = process.env.BACKEND_URL || 'http://localhost:3002'
    const apiPath = request.nextUrl.pathname.replace('/api', '')
    const url = new URL(apiPath, backendUrl)
    
    // Copiar query parameters
    request.nextUrl.searchParams.forEach((value, key) => {
      url.searchParams.set(key, value)
    })

    return NextResponse.rewrite(url)
  }

  return NextResponse.next()
}

export const config = {
  matcher: [
    '/api/:path*',
  ],
}

import Link from "next/link"
import { Mail, Phone, MapPin } from "lucide-react"

export function Footer() {
  return (
    <footer className="relative bg-gradient-to-br from-slate-800 via-slate-900 to-slate-800 text-white overflow-hidden">
      {/* Background Pattern */}
      <div className="absolute inset-0 bg-gradient-to-br from-slate-700/10 via-slate-800/20 to-slate-700/10"></div>
      
      {/* Main Content */}
      <div className="relative z-10 py-16">
        <div className="container mx-auto px-4 max-w-7xl">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-12">
            
            {/* Eventu - Logo y descripción */}
            <div className="lg:col-span-1 space-y-6">
              <Link href="/" className="flex items-center group">
                <div className="relative">
                  <img
                    src="/images/eventu-logo.svg"
                    alt="Eventu"
                    className="w-[276px] h-[80px] group-hover:scale-105 transition-transform duration-300"
                  />
                </div>
              </Link>
              <p className="text-gray-300 leading-relaxed text-sm">
                Tu plataforma integral para la gestión y venta de boletos de eventos.
              </p>
              <div className="flex items-center gap-3 text-sm text-gray-400 group">
                <div className="p-2 bg-white/10 rounded-lg group-hover:bg-white/20 transition-colors">
                  <MapPin className="h-4 w-4" />
                </div>
                <span>Barranquilla, Colombia</span>
              </div>
            </div>

            {/* Eventos */}
            <div className="space-y-6">
              <h3 className="font-bold text-white text-lg relative">
                <span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                  Eventos
                </span>
                <div className="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full"></div>
              </h3>
              <ul className="space-y-4">
                <li>
                  <Link href="/eventos" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Explorar Eventos</span>
                  </Link>
                </li>
                <li>
                  <Link href="/vende-tu-evento" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Vende tu Evento</span>
                  </Link>
                </li>
                <li>
                  <Link href="/puntos-de-venta" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Puntos de Venta</span>
                  </Link>
                </li>
              </ul>
            </div>

            {/* Compañía */}
            <div className="space-y-6">
              <h3 className="font-bold text-white text-lg relative">
                <span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                  Compañía
                </span>
                <div className="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full"></div>
              </h3>
              <ul className="space-y-4">
                <li>
                  <Link href="/nuestros-servicios" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Nuestros Servicios</span>
                  </Link>
                </li>
                <li>
                  <Link href="/terminos-condiciones" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Términos y Condiciones</span>
                  </Link>
                </li>
                <li>
                  <Link href="/politica-privacidad" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Política de Privacidad</span>
                  </Link>
                </li>
              </ul>
            </div>

            {/* Soporte */}
            <div className="space-y-6">
              <h3 className="font-bold text-white text-lg relative">
                <span className="bg-gradient-to-r from-purple-400 to-pink-400 bg-clip-text text-transparent">
                  Soporte
                </span>
                <div className="absolute -bottom-2 left-0 w-8 h-0.5 bg-gradient-to-r from-purple-400 to-pink-400 rounded-full"></div>
              </h3>
              <ul className="space-y-4">
                <li>
                  <Link href="/preguntas-frecuentes" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Preguntas Frecuentes</span>
                  </Link>
                </li>
                <li>
                  <Link href="/contacto" className="group flex items-center text-gray-300 hover:text-white transition-all duration-300">
                    <div className="w-2 h-2 bg-purple-400 rounded-full mr-3 group-hover:scale-125 transition-transform"></div>
                    <span className="group-hover:translate-x-1 transition-transform">Contacto</span>
                  </Link>
                </li>
              </ul>
              <div className="space-y-3 pt-4">
                <div className="flex items-center gap-3 text-sm text-gray-300 group">
                  <div className="p-2 bg-white/10 rounded-lg group-hover:bg-white/20 transition-colors">
                    <Mail className="h-4 w-4" />
                  </div>
                  <span className="group-hover:text-white transition-colors">info@eventu.co</span>
                </div>
                <div className="flex items-center gap-3 text-sm text-gray-300 group">
                  <div className="p-2 bg-white/10 rounded-lg group-hover:bg-white/20 transition-colors">
                    <Phone className="h-4 w-4" />
                  </div>
                  <span className="group-hover:text-white transition-colors">(300) 285-0000</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Copyright */}
      <div className="relative z-10 border-t border-white/10 py-8">
        <div className="container mx-auto px-4 text-center">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <p className="text-sm text-gray-400">
              © {new Date().getFullYear()} Eventu. Todos los derechos reservados.
            </p>
          </div>
        </div>
      </div>
    </footer>
  )
}
import Link from "next/link"
import { Mail, Phone, MapPin, AlertCircle } from "lucide-react"

export function Footer() {
  return (
    <footer className="bg-gray-950 text-gray-300">
      {/* Aviso sobre pagos desactivados */}
      <div className="bg-orange-900/10 border-b border-orange-800/20">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center justify-center gap-2">
            <AlertCircle className="h-4 w-4 text-orange-400" />
            <p className="text-orange-300 text-xs text-center">
              Sistema de pagos temporalmente desactivado
            </p>
          </div>
        </div>
      </div>

      {/* Contenido principal del footer */}
      <div className="py-8">
        <div className="container mx-auto px-4 max-w-6xl">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            
            {/* Logo y descripción */}
            <div className="space-y-4">
              <Link href="/" className="flex items-center group">
                <img
                  src="/images/eventu-logo.svg"
                  alt="Eventu"
                  className="h-6 md:h-8 w-auto group-hover:scale-105 transition-transform"
                />
              </Link>
              <p className="text-sm text-gray-400 leading-relaxed">
                Plataforma integral para la gestión y venta de boletos de eventos.
              </p>
              <div className="flex items-center gap-2 text-xs text-gray-500">
                <MapPin className="h-3 w-3" />
                <span>Barranquilla, Colombia</span>
              </div>
            </div>

            {/* Enlaces principales */}
            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-white">Enlaces</h3>
              <div className="grid grid-cols-2 gap-2">
                <Link className="text-xs text-gray-400 hover:text-white transition-colors" href="/eventos">
                  Eventos
                </Link>
                <Link className="text-xs text-gray-400 hover:text-white transition-colors" href="/vende-tu-evento">
                  Vende tu Evento
                </Link>
                <Link className="text-xs text-gray-400 hover:text-white transition-colors" href="/organizer">
                  Organizador
                </Link>
                <Link className="text-xs text-gray-400 hover:text-white transition-colors" href="/contacto">
                  Contacto
                </Link>
              </div>
            </div>

            {/* Contacto */}
            <div className="space-y-4">
              <h3 className="text-sm font-semibold text-white">Contacto</h3>
              <div className="space-y-2">
                <div className="flex items-center gap-2 text-xs text-gray-400">
                  <Mail className="h-3 w-3" />
                  <span>info@eventu.co</span>
                </div>
                <div className="flex items-center gap-2 text-xs text-gray-400">
                  <Phone className="h-3 w-3" />
                  <span>(300) 285-0000</span>
                </div>
              </div>
            </div>

          </div>
        </div>
      </div>

      {/* Línea inferior */}
      <div className="border-t border-gray-800/50">
        <div className="container mx-auto px-4 py-4">
          <div className="flex flex-col md:flex-row justify-between items-center gap-2">
            <div className="text-xs text-gray-500">
              © {new Date().getFullYear()} Eventu. Todos los derechos reservados.
            </div>
            <div className="flex gap-4 text-xs">
              <Link className="text-gray-500 hover:text-gray-300 transition-colors" href="/terminos-condiciones">
                Términos
              </Link>
              <Link className="text-gray-500 hover:text-gray-300 transition-colors" href="/politica-privacidad">
                Privacidad
              </Link>
            </div>
          </div>
        </div>
      </div>
    </footer>
  )
}

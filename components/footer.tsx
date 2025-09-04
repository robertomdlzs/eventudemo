import Link from "next/link"
import { MountainIcon } from "lucide-react"

export function Footer() {
  return (
    <footer className="bg-gray-900 text-gray-400 py-12 md:py-16">
      <div className="container mx-auto px-4 md:px-6 grid grid-cols-1 md:grid-cols-4 gap-8">
        <div className="space-y-4">
          <Link className="flex items-center gap-2 text-white" href="#">
            <MountainIcon className="h-6 w-6" />
            <span className="text-lg font-semibold">Eventu</span>
          </Link>
          <p className="text-sm">Tu plataforma integral para la gestión y venta de boletos de eventos.</p>
        </div>
        <div className="space-y-2">
          <h3 className="text-lg font-semibold text-white">Eventos</h3>
          <ul className="space-y-1">
            <li>
              <Link className="hover:text-white transition-colors" href="/eventos">
                Explorar Eventos
              </Link>
            </li>
            <li>
              <Link className="hover:text-white transition-colors" href="/vende-tu-evento">
                Vende tu Evento
              </Link>
            </li>
            <li>
              <Link className="hover:text-white transition-colors" href="/puntos-de-venta">
                Puntos de Venta
              </Link>
            </li>
          </ul>
        </div>
        <div className="space-y-2">
          <h3 className="text-lg font-semibold text-white">Compañía</h3>
          <ul className="space-y-1">
            <li>
              <Link className="hover:text-white transition-colors" href="/nuestros-servicios">
                Nuestros Servicios
              </Link>
            </li>
            <li>
              <Link className="hover:text-white transition-colors" href="/terminos-condiciones">
                Términos y Condiciones
              </Link>
            </li>
            <li>
              <Link className="hover:text-white transition-colors" href="/politica-privacidad">
                Política de Privacidad
              </Link>
            </li>
          </ul>
        </div>
        <div className="space-y-2">
          <h3 className="text-lg font-semibold text-white">Soporte</h3>
          <ul className="space-y-1">
            <li>
              <Link className="hover:text-white transition-colors" href="#">
                Preguntas Frecuentes
              </Link>
            </li>
            <li>
              <Link className="hover:text-white transition-colors" href="#">
                Contacto
              </Link>
            </li>
          </ul>
        </div>
      </div>
      <div className="container mx-auto px-4 md:px-6 mt-8 text-center text-sm text-gray-500">
        © {new Date().getFullYear()} Eventu. Todos los derechos reservados.
      </div>
    </footer>
  )
}

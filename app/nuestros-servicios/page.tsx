import type { Metadata } from "next"

export const metadata: Metadata = {
  title: "Nuestros Servicios | Eventu",
  description: "Descubre todos los servicios que ofrecemos para organizadores de eventos",
}

export default function NuestrosServiciosPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-pink-500 to-purple-600 text-white py-20">
        <div className="container mx-auto px-4 text-center">
          <h1 className="text-4xl md:text-6xl font-bold mb-6">
            Nuestros Servicios
          </h1>
          <p className="text-xl md:text-2xl mb-8 max-w-3xl mx-auto">
            Todo lo que necesitas para hacer de tu evento un éxito rotundo
          </p>
        </div>
      </section>

      {/* Services Grid */}
      <section className="py-16">
        <div className="container mx-auto px-4">
          <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
            {/* Service 1 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-pink-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Venta de Boletos</h3>
              <p className="text-gray-600 mb-6">
                Plataforma completa para la venta de boletos online con múltiples métodos de pago y gestión de inventario.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Múltiples métodos de pago</li>
                <li>• Gestión de inventario en tiempo real</li>
                <li>• Boletos digitales con QR</li>
                <li>• Reportes de ventas detallados</li>
              </ul>
            </div>

            {/* Service 2 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-purple-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Analíticas y Reportes</h3>
              <p className="text-gray-600 mb-6">
                Dashboard completo con métricas en tiempo real, análisis de ventas y reportes personalizados.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Métricas en tiempo real</li>
                <li>• Análisis de comportamiento</li>
                <li>• Reportes personalizados</li>
                <li>• Exportación de datos</li>
              </ul>
            </div>

            {/* Service 3 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-blue-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Gestión de Asistentes</h3>
              <p className="text-gray-600 mb-6">
                Sistema completo para gestionar asistentes, check-in y comunicación con los participantes.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Check-in digital</li>
                <li>• Gestión de asistentes</li>
                <li>• Comunicaciones masivas</li>
                <li>• Listas de acceso</li>
              </ul>
            </div>

            {/* Service 4 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Aplicación Móvil</h3>
              <p className="text-gray-600 mb-6">
                Aplicación móvil para organizadores y asistentes con funcionalidades avanzadas.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Check-in móvil</li>
                <li>• Boletos digitales</li>
                <li>• Notificaciones push</li>
                <li>• Gestión offline</li>
              </ul>
            </div>

            {/* Service 5 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-yellow-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M13 10V3L4 14h7v7l9-11h-7z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Marketing y Promoción</h3>
              <p className="text-gray-600 mb-6">
                Herramientas de marketing integradas para promocionar tu evento y aumentar las ventas.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Campañas de email</li>
                <li>• Integración con redes sociales</li>
                <li>• Códigos de descuento</li>
                <li>• Marketing de afiliados</li>
              </ul>
            </div>

            {/* Service 6 */}
            <div className="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
              <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mb-6">
                <svg className="w-8 h-8 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M18.364 5.636l-3.536 3.536m0 5.656l3.536 3.536M9.172 9.172L5.636 5.636m3.536 9.192L5.636 18.364M12 2.25a9.75 9.75 0 109.75 9.75A9.75 9.75 0 0012 2.25z" />
                </svg>
              </div>
              <h3 className="text-2xl font-bold mb-4">Soporte 24/7</h3>
              <p className="text-gray-600 mb-6">
                Soporte técnico disponible las 24 horas para resolver cualquier problema que puedas tener.
              </p>
              <ul className="space-y-2 text-sm text-gray-600">
                <li>• Chat en vivo</li>
                <li>• Soporte telefónico</li>
                <li>• Base de conocimientos</li>
                <li>• Capacitación personalizada</li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="bg-gray-900 text-white py-16">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl md:text-4xl font-bold mb-6">
            ¿Listo para empezar?
          </h2>
          <p className="text-xl mb-8 max-w-2xl mx-auto">
            Únete a miles de organizadores que ya confían en Eventu para sus eventos
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <a
              href="/vende-tu-evento"
              className="bg-pink-600 hover:bg-pink-700 text-white px-8 py-3 rounded-lg font-semibold transition-colors"
            >
              Crear mi primer evento
            </a>
            <a
              href="/contacto"
              className="border border-white text-white hover:bg-white hover:text-gray-900 px-8 py-3 rounded-lg font-semibold transition-colors"
            >
              Contactar ventas
            </a>
          </div>
        </div>
      </section>
    </div>
  )
}

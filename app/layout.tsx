import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { ThemeProvider } from '@/components/theme-provider'
import { Toaster } from '@/components/ui/sonner'
import GoogleAnalytics from '@/components/GoogleAnalytics'
import CookieConsent from '@/components/CookieConsent'
import { BrowserSessionProvider } from '@/components/browser-session-provider'
import { SessionTimeoutProvider } from '@/components/session-timeout-provider'
import MainHeader from '@/components/main-header'
import { Footer } from '@/components/footer'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Eventu - Plataforma de Eventos',
  description: 'Plataforma completa para la gestión y venta de eventos',
  keywords: 'eventos, tickets, boletos, venta, gestión',
  authors: [{ name: 'Eventu Team' }],
  viewport: 'width=device-width, initial-scale=1',
  robots: 'index, follow',
  openGraph: {
    title: 'Eventu - Plataforma de Eventos',
    description: 'Plataforma completa para la gestión y venta de eventos',
    type: 'website',
    locale: 'es_ES',
  },
}

// Deshabilitar prerenderizado para esta aplicación
export const dynamic = 'force-dynamic'
export const revalidate = 0

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="es" suppressHydrationWarning>
      <head>
        <GoogleAnalytics />
      </head>
      <body className={inter.className}>
        <ThemeProvider
          attribute="class"
          defaultTheme="system"
          enableSystem
          disableTransitionOnChange
        >
          <BrowserSessionProvider>
            <SessionTimeoutProvider>
              <div className="min-h-screen bg-background flex flex-col">
                <MainHeader />
                <main className="flex-1">
                  {children}
                </main>
                <Footer />
              </div>
              <Toaster />
              <CookieConsent />
            </SessionTimeoutProvider>
          </BrowserSessionProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}
import type React from "react"
import type { Metadata } from "next"
import { ThemeProvider } from "@/components/theme-provider"
import { Inter } from "next/font/google"
import "./globals.css"
import { Toaster } from "@/components/ui/toaster"
import MainHeader from "@/components/main-header"
import { Footer } from "@/components/footer"
import GoogleAnalytics from "@/components/GoogleAnalytics"
import CookieConsent from "@/components/CookieConsent"
import { BrowserSessionProvider } from "@/components/browser-session-provider"
import { ActivityTracker } from "@/components/activity-tracker"
import { SessionTimeoutWarning } from "@/components/session-timeout-warning"

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Eventu - Plataforma de Eventos",
  description: "La plataforma líder de venta de boletos para eventos en Colombia.",
    generator: 'v0.app'
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="es" suppressHydrationWarning>
      <body className={inter.className}>
        <ThemeProvider attribute="class" defaultTheme="light" enableSystem disableTransitionOnChange>
          <BrowserSessionProvider>
            <ActivityTracker />
            <SessionTimeoutWarning />
            <GoogleAnalytics />
            <MainHeader />
            <main className="min-h-screen">{children}</main>
            <Footer />
            <Toaster />
            <CookieConsent />
          </BrowserSessionProvider>
        </ThemeProvider>
      </body>
    </html>
  )
}

"use client"

import { useState } from "react"
import Link from "next/link"
import { usePathname } from "next/navigation"
import Image from "next/image"
import { BarChart3, Calendar, ChevronDown, Home, Settings, Ticket, Users, ImageIcon } from "lucide-react"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "@/components/ui/collapsible"

const menuItems = [
  {
    title: "Dashboard",
    href: "/admin",
    icon: Home,
  },
  {
    title: "Eventos",
    icon: Calendar,
    items: [
      { title: "Ver Eventos", href: "/admin/eventos" },
      { title: "Crear Evento", href: "/admin/eventos/crear" },
      { title: "Categorías", href: "/admin/eventos/categorias" },
      { title: "Mapas de Asientos", href: "/admin/eventos/mapas-asientos" },
    ],
  },
  {
    title: "Usuarios",
    icon: Users,
    items: [
      { title: "Ver Usuarios", href: "/admin/usuarios" },
      { title: "Crear Usuario", href: "/admin/usuarios/crear" },
    ],
  },
  {
    title: "Boletas",
    icon: Ticket,
    items: [
      { title: "Tipos de Boleta", href: "/admin/boletas/tipos" },
      { title: "Boletas Virtuales", href: "/admin/boletas/virtuales" },
      { title: "Boletas Físicas", href: "/admin/boletas/fisicas" },
      { title: "Ventas", href: "/admin/boletas/ventas" },
      { title: "Check-in", href: "/admin/boletas/checkin" },
    ],
  },
  {
    title: "Biblioteca de Medios",
    href: "/admin/biblioteca",
    icon: ImageIcon,
  },
  {
    title: "Reportes",
    href: "/admin/reportes",
    icon: BarChart3,
  },
  {
    title: "Configuración",
    href: "/admin/configuracion",
    icon: Settings,
  },
]

export function AdminSidebar() {
  const pathname = usePathname()
  const [openItems, setOpenItems] = useState<string[]>([])

  const toggleItem = (title: string) => {
    setOpenItems((prev) => (prev.includes(title) ? prev.filter((item) => item !== title) : [...prev, title]))
  }

  return (
    <div className="w-64 bg-white border-r border-gray-200 flex flex-col">
      {/* Logo */}
      <div className="p-6 border-b border-gray-200">
        <Link href="/" className="flex items-center gap-3">
          <Image
            src="/assets?path=images/eventu-logo.svg"
            alt="Eventu"
            width={120}
            height={32}
            className="h-8 w-auto"
          />
        </Link>
      </div>

      {/* Navigation */}
      <nav className="flex-1 p-4 space-y-2">
        {menuItems.map((item) => {
          if (item.items) {
            const isOpen = openItems.includes(item.title)
            const hasActiveChild = item.items.some((child) => pathname === child.href)

            return (
              <Collapsible key={item.title} open={isOpen} onOpenChange={() => toggleItem(item.title)}>
                <CollapsibleTrigger asChild>
                  <Button
                    variant="ghost"
                    className={cn(
                      "w-full justify-between text-left font-normal",
                      (isOpen || hasActiveChild) && "bg-primary/10 text-primary",
                    )}
                  >
                    <div className="flex items-center gap-3">
                      <item.icon className="h-4 w-4" />
                      <span>{item.title}</span>
                    </div>
                    <ChevronDown className={cn("h-4 w-4 transition-transform", isOpen && "rotate-180")} />
                  </Button>
                </CollapsibleTrigger>
                <CollapsibleContent className="space-y-1 mt-1">
                  {item.items.map((subItem) => (
                    <Button
                      key={subItem.href}
                      variant="ghost"
                      asChild
                      className={cn(
                        "w-full justify-start pl-10 font-normal",
                        pathname === subItem.href && "bg-primary/10 text-primary",
                      )}
                    >
                      <Link href={subItem.href}>{subItem.title}</Link>
                    </Button>
                  ))}
                </CollapsibleContent>
              </Collapsible>
            )
          }

          return (
            <Button
              key={item.href}
              variant="ghost"
              asChild
              className={cn("w-full justify-start font-normal", pathname === item.href && "bg-primary/10 text-primary")}
            >
              <Link href={item.href!} className="flex items-center gap-3">
                <item.icon className="h-4 w-4" />
                <span>{item.title}</span>
              </Link>
            </Button>
          )
        })}
      </nav>

      {/* Footer */}
      <div className="p-4 border-t border-gray-200">
        <div className="text-xs text-gray-500 text-center">Eventu Admin Panel v2.0</div>
      </div>
    </div>
  )
}

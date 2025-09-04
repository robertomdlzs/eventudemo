import { getAdminDashboardStats } from "@/app/admin/actions"
import AdminDashboardClient from "./AdminDashboardClient"

export const metadata = {
  title: "Dashboard | Eventu Admin",
  description: "Panel de administración de Eventu - Gestión completa del sistema.",
}

/**
 * Server Component ─ fetches data and passes plain JSON
 */
export default async function AdminDashboardPage() {
  const dashboardData = await getAdminDashboardStats()

  /**
   * ⬇️ Everything below this point runs on the client.
   * We only pass serialisable props (arrays / objects).
   */
  return <AdminDashboardClient dashboardData={dashboardData} />
}

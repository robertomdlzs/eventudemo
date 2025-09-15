import { Suspense } from 'react'
import { AdminDashboardClient } from '@/components/admin/AdminDashboardClient'

// Deshabilitar prerenderizado para esta página
export const dynamic = 'force-dynamic'
export const revalidate = 0

export default function AdminPage() {
  return (
    <Suspense fallback={
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-32 w-32 border-b-2 border-primary"></div>
      </div>
    }>
      <AdminDashboardClient />
    </Suspense>
  )
}
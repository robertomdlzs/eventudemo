import { ConnectionTest } from "@/components/connection-test"

export default function TestConnectionPage() {
  return (
    <div className="container mx-auto py-8">
      <div className="text-center mb-8">
        <h1 className="text-3xl font-bold">Prueba de Conectividad</h1>
        <p className="text-muted-foreground mt-2">Verifica que el frontend y backend estén conectados correctamente</p>
      </div>
      <ConnectionTest />
    </div>
  )
}

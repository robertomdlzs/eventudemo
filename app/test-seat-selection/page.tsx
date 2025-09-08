import { SeatSelectionTest } from '@/components/seat-selection-test'

export default function TestSeatSelectionPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <div className="container mx-auto py-8">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Prueba de Selección de Asientos
          </h1>
          <p className="text-gray-600">
            Esta página permite probar la funcionalidad de selección de asientos
          </p>
        </div>
        <SeatSelectionTest />
      </div>
    </div>
  )
}


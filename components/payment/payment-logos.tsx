"use client"

import { Card, CardContent } from "@/components/ui/card"

interface PaymentLogosProps {
  className?: string
}

export function PaymentLogos({ className = "" }: PaymentLogosProps) {
  return (
    <Card className={`${className}`}>
      <CardContent className="p-4">
        <div className="text-center mb-4">
          <h4 className="text-sm font-semibold text-gray-700 mb-2">Métodos de Pago Aceptados</h4>
        </div>
        
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
          {/* PSE */}
          <div className="flex flex-col items-center p-3 bg-blue-50 rounded-lg border border-blue-200">
            <div className="w-12 h-8 bg-blue-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">PSE</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Pagos Seguros</span>
          </div>

          {/* Visa */}
          <div className="flex flex-col items-center p-3 bg-blue-50 rounded-lg border border-blue-200">
            <div className="w-12 h-8 bg-blue-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">VISA</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Crédito/Débito</span>
          </div>

          {/* Mastercard */}
          <div className="flex flex-col items-center p-3 bg-orange-50 rounded-lg border border-orange-200">
            <div className="w-12 h-8 bg-gradient-to-r from-orange-500 to-red-500 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">MC</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Crédito/Débito</span>
          </div>

          {/* Diners */}
          <div className="flex flex-col items-center p-3 bg-green-50 rounded-lg border border-green-200">
            <div className="w-12 h-8 bg-green-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">DC</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Diners Club</span>
          </div>

          {/* Daviplata */}
          <div className="flex flex-col items-center p-3 bg-purple-50 rounded-lg border border-purple-200">
            <div className="w-12 h-8 bg-purple-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">DV</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Daviplata</span>
          </div>

          {/* TC Serfinanza */}
          <div className="flex flex-col items-center p-3 bg-red-50 rounded-lg border border-red-200">
            <div className="w-12 h-8 bg-red-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">TC</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Serfinanza</span>
          </div>

          {/* American Express */}
          <div className="flex flex-col items-center p-3 bg-teal-50 rounded-lg border border-teal-200">
            <div className="w-12 h-8 bg-teal-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">AMEX</span>
            </div>
            <span className="text-xs text-gray-600 text-center">American Express</span>
          </div>

          {/* Seguridad */}
          <div className="flex flex-col items-center p-3 bg-gray-50 rounded-lg border border-gray-200">
            <div className="w-12 h-8 bg-gray-600 rounded flex items-center justify-center mb-2">
              <span className="text-white text-xs font-bold">SSL</span>
            </div>
            <span className="text-xs text-gray-600 text-center">Seguro</span>
          </div>
        </div>

        <div className="mt-4 text-center">
          <p className="text-xs text-gray-500">
            Todos los pagos son procesados de forma segura con encriptación SSL
          </p>
        </div>
      </CardContent>
    </Card>
  )
}

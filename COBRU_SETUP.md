# Configuración de Cobru - Pasarela de Pagos para Colombia

## Descripción

Cobru es una pasarela de pagos especializada en Colombia que permite procesar pagos a través de múltiples métodos locales como Nequi, Daviplata, Bancolombia, PSE, y otros métodos de pago populares en el país.

## Características

- **Múltiples métodos de pago**: Nequi, Daviplata, Bancolombia, PSE, Efecty, Baloto, RedServi
- **QR Code**: Generación automática de códigos QR para pagos móviles
- **Webhooks**: Notificaciones en tiempo real del estado de las transacciones
- **Reembolsos**: Soporte para reembolsos totales y parciales
- **Ambiente sandbox**: Modo de pruebas para desarrollo
- **Seguridad**: Firma HMAC SHA-256 para validación de webhooks

## Configuración

### 1. Variables de Entorno

Agregar las siguientes variables al archivo `backend/config.env`:

```env
# Cobru Configuration (para pagos en Colombia)
COBRU_API_URL=https://api.cobru.co
COBRU_API_KEY=your-cobru-api-key
COBRU_SECRET_KEY=your-cobru-secret-key
COBRU_MERCHANT_ID=your-cobru-merchant-id
COBRU_ENVIRONMENT=sandbox
```

### 2. Obtener Credenciales

1. **Registrarse en Cobru**: Visitar [https://cobru.co](https://cobru.co) y crear una cuenta
2. **Obtener API Key**: Desde el dashboard de Cobru, generar una API Key
3. **Obtener Secret Key**: Generar un Secret Key para firmar las peticiones
4. **Merchant ID**: Obtener el ID del comercio asignado por Cobru

### 3. Configuración de Webhooks

Configurar las siguientes URLs en el dashboard de Cobru:

- **Webhook URL**: `https://tu-dominio.com/api/payments/cobru/webhook`
- **Return URL**: `https://tu-dominio.com/checkout/success`
- **Cancel URL**: `https://tu-dominio.com/checkout/cancel`

## API Endpoints

### Configuración

```http
GET /api/payments/cobru/config
```

Retorna la configuración actual de Cobru y métodos de pago soportados.

### Crear Transacción

```http
POST /api/payments/cobru/create
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 50000,
  "currency": "COP",
  "description": "Compra de boletos para evento",
  "reference": "EVENT-123-456",
  "customerEmail": "cliente@email.com",
  "customerName": "Juan Pérez",
  "customerPhone": "+573001234567",
  "eventId": "1",
  "ticketTypeId": "2",
  "quantity": 2
}
```

### Verificar Estado

```http
GET /api/payments/cobru/status/{transactionId}
Authorization: Bearer <token>
```

### Procesar Reembolso

```http
POST /api/payments/cobru/refund
Authorization: Bearer <token>
Content-Type: application/json

{
  "transactionId": "cobru_txn_123456",
  "amount": 25000,
  "reason": "Cancelación del evento"
}
```

## Métodos de Pago Soportados

### Billeteras Digitales
- **Nequi**: Billetera digital de Bancolombia
- **Daviplata**: Billetera digital de Davivienda

### Transferencias Bancarias
- **Bancolombia**: Transferencia directa
- **PSE**: Pagos Seguros en Línea

### Puntos de Pago
- **Efecty**: Pago en efectivo en puntos físicos
- **Baloto**: Pago en puntos de venta
- **RedServi**: Red de puntos de pago

## Estados de Transacción

- **pending**: Transacción creada, esperando pago
- **approved**: Pago aprobado
- **completed**: Transacción completada
- **failed**: Pago fallido
- **cancelled**: Transacción cancelada
- **expired**: Transacción expirada

## Webhooks

Cobru enviará webhooks a la URL configurada con los siguientes eventos:

### Estructura del Webhook

```json
{
  "event_type": "payment.approved",
  "transaction_id": "cobru_txn_123456",
  "status": "approved",
  "amount": 50000,
  "reference": "EVENT-123-456",
  "payment_method": "nequi",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Tipos de Eventos

- `payment.created`: Transacción creada
- `payment.approved`: Pago aprobado
- `payment.completed`: Transacción completada
- `payment.failed`: Pago fallido
- `payment.cancelled`: Transacción cancelada
- `payment.expired`: Transacción expirada

## Uso en el Frontend

### Componente React

```tsx
import CobruPayment from '@/components/payment/CobruPayment';

<CobruPayment
  amount={50000}
  currency="COP"
  description="Compra de boletos"
  reference="EVENT-123-456"
  customerEmail="cliente@email.com"
  customerName="Juan Pérez"
  customerPhone="+573001234567"
  onSuccess={(data) => {
    console.log('Pago exitoso:', data);
  }}
  onError={(error) => {
    console.error('Error en pago:', error);
  }}
/>
```

### Cliente API

```typescript
import { apiClient } from '@/lib/api-client';

// Obtener configuración
const config = await apiClient.getCobruConfig();

// Crear transacción
const transaction = await apiClient.createCobruTransaction({
  amount: 50000,
  currency: 'COP',
  description: 'Compra de boletos',
  reference: 'EVENT-123-456',
  customerEmail: 'cliente@email.com'
});

// Verificar estado
const status = await apiClient.getCobruTransactionStatus(transactionId);
```

## Seguridad

### Firma de Peticiones

Todas las peticiones a Cobru incluyen una firma HMAC SHA-256:

```javascript
const signature = crypto
  .createHmac('sha256', secretKey)
  .update(JSON.stringify(payload))
  .digest('hex');
```

### Validación de Webhooks

Los webhooks de Cobru incluyen una firma que debe ser validada:

```javascript
const isValid = crypto.timingSafeEqual(
  Buffer.from(receivedSignature, 'hex'),
  Buffer.from(expectedSignature, 'hex')
);
```

## Modo de Pruebas

Para desarrollo, configurar:

```env
COBRU_ENVIRONMENT=sandbox
```

En modo sandbox:
- Las transacciones no procesan pagos reales
- Se pueden usar datos de prueba
- Los webhooks se envían normalmente
- Los montos pueden ser cualquier valor

## Producción

Para producción:

1. Cambiar `COBRU_ENVIRONMENT=production`
2. Usar credenciales de producción
3. Configurar URLs de producción
4. Verificar configuración de webhooks

## Monitoreo y Logs

### Logs Importantes

- Creación de transacciones
- Respuestas de webhooks
- Errores de validación
- Reembolsos procesados

### Métricas a Monitorear

- Tasa de éxito de transacciones
- Tiempo de respuesta de la API
- Errores de webhook
- Reembolsos por método de pago

## Solución de Problemas

### Errores Comunes

1. **"Invalid signature"**: Verificar que el Secret Key sea correcto
2. **"Transaction not found"**: Verificar que el transaction_id sea válido
3. **"Webhook validation failed"**: Verificar la firma del webhook
4. **"Amount must be in cents"**: Cobru espera montos en centavos

### Debugging

```javascript
// Habilitar logs detallados
console.log('Cobru Request:', {
  url: apiUrl,
  payload: payload,
  signature: signature
});

// Verificar configuración
const config = await apiClient.getCobruConfig();
console.log('Cobru Config:', config);
```

## Soporte

- **Documentación**: [https://docs.cobru.co](https://docs.cobru.co)
- **Soporte**: contact@cobru.co
- **Dashboard**: [https://dashboard.cobru.co](https://dashboard.cobru.co)

## Integración con ePayco

Cobru y ePayco pueden coexistir en la aplicación:

1. **Selector de método**: El usuario puede elegir entre Cobru y ePayco
2. **Configuración independiente**: Cada pasarela tiene sus propias credenciales
3. **Webhooks separados**: Cada pasarela envía webhooks a endpoints diferentes
4. **Base de datos**: Las transacciones se almacenan con el campo `payment_gateway` para diferenciarlas

### Ejemplo de uso conjunto

```tsx
const handlePaymentMethodChange = (methodId: string) => {
  if (methodId === 'cobru') {
    setPaymentGateway('cobru');
  } else if (methodId === 'epayco') {
    setPaymentGateway('epayco');
  }
};
```

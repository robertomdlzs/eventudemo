# Configuración de ePayco para Eventu

## 🎯 **Configuración en Modo Sandbox**

Este documento explica cómo configurar ePayco en modo sandbox para desarrollo, evitando conflictos con aplicaciones en producción.

## 📋 **Prerrequisitos**

1. **Cuenta de ePayco**: Necesitas una cuenta en [ePayco](https://epayco.co/)
2. **Credenciales de Sandbox**: Obtén las credenciales de prueba desde tu panel de ePayco

## 🔧 **Configuración de Variables de Entorno**

### 1. **Obtener Credenciales de Sandbox**

En tu panel de ePayco:
1. Ve a **Configuración** > **Credenciales**
2. Selecciona **Modo Sandbox/Pruebas**
3. Copia las siguientes credenciales:
   - **P_CUST_ID_CLIENTE** (Customer ID)
   - **P_KEY** (Llave pública)
   - **Llave privada** (para firmas)

### 2. **Configurar Variables en `backend/config.env`**

```env
# Payment Configuration
PAYMENT_GATEWAY=epayco
PAYMENT_MODE=sandbox

# ePayco Sandbox Configuration
EPAYCO_PUBLIC_KEY=tu-llave-publica-sandbox
EPAYCO_PRIVATE_KEY=tu-llave-privada-sandbox
EPAYCO_P_KEY=tu-p-key-sandbox
EPAYCO_CUSTOMER_ID=tu-customer-id-sandbox

# ePayco URLs (sandbox)
EPAYCO_CONFIRM_URL=http://localhost:3002/api/payments/epayco/confirm
EPAYCO_RESPONSE_URL=http://localhost:3000/checkout/success
EPAYCO_CANCEL_URL=http://localhost:3000/checkout/cancel
```

## 🚀 **Instalación y Configuración**

### 1. **Instalar Dependencias**

```bash
cd backend
npm install axios crypto
```

### 2. **Reiniciar el Servidor**

```bash
npm run dev
```

### 3. **Verificar Configuración**

```bash
curl http://localhost:3002/api/payments/epayco/config
```

Deberías recibir una respuesta como:
```json
{
  "success": true,
  "data": {
    "publicKey": "tu-llave-publica",
    "isSandbox": true,
    "confirmUrl": "http://localhost:3002/api/payments/epayco/confirm",
    "responseUrl": "http://localhost:3000/checkout/success",
    "cancelUrl": "http://localhost:3000/checkout/cancel",
    "customerId": "tu-customer-id"
  }
}
```

## 🧪 **Pruebas en Modo Sandbox**

### 1. **Tarjetas de Prueba**

ePayco proporciona tarjetas de prueba para diferentes escenarios:

**Tarjeta Aprobada:**
- Número: `4575623182290326`
- CVV: `123`
- Fecha: Cualquier fecha futura

**Tarjeta Rechazada:**
- Número: `4575623182290327`
- CVV: `123`
- Fecha: Cualquier fecha futura

### 2. **Probar Transacción**

```bash
curl -X POST http://localhost:3002/api/payments/epayco/create \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer tu-jwt-token" \
  -d '{
    "amount": 100000,
    "currency": "COP",
    "description": "Prueba de pago",
    "eventId": "1",
    "ticketIds": ["1", "2"],
    "customerInfo": {
      "name": "Juan Pérez",
      "email": "juan@ejemplo.com",
      "phone": "3001234567",
      "address": "Calle 123 #45-67"
    }
  }'
```

## 🔄 **Webhooks y Callbacks**

### 1. **URL de Confirmación**
- **Endpoint**: `POST /api/payments/epayco/confirm`
- **Propósito**: ePayco envía confirmaciones de pago aquí
- **Configuración**: Debe estar configurada en tu panel de ePayco

### 2. **URL de Respuesta**
- **Endpoint**: `http://localhost:3000/checkout/success`
- **Propósito**: Redirige al usuario después del pago
- **Configuración**: Se configura automáticamente

### 3. **URL de Cancelación**
- **Endpoint**: `http://localhost:3000/checkout/cancel`
- **Propósito**: Redirige al usuario si cancela el pago
- **Configuración**: Se configura automáticamente

## 🛡️ **Seguridad y Mejores Prácticas**

### 1. **Separación de Entornos**
- ✅ **Desarrollo**: Usa siempre credenciales de sandbox
- ✅ **Producción**: Usa credenciales de producción
- ❌ **Nunca mezcles**: Credenciales de sandbox y producción

### 2. **Validación de Webhooks**
- ✅ **Firma**: Siempre valida la firma de los webhooks
- ✅ **Idempotencia**: Maneja transacciones duplicadas
- ✅ **Logs**: Registra todas las transacciones

### 3. **Manejo de Errores**
- ✅ **Timeouts**: Configura timeouts apropiados
- ✅ **Reintentos**: Implementa lógica de reintentos
- ✅ **Fallbacks**: Ten planes de respaldo

## 📊 **Monitoreo y Logs**

### 1. **Logs de Transacciones**
```javascript
// Los logs se guardan automáticamente en:
// - backend/logs/application.log
// - Base de datos: tabla 'payments'
```

### 2. **Monitoreo de Webhooks**
```bash
# Ver logs en tiempo real
tail -f backend/logs/application.log | grep epayco
```

### 3. **Estado de Transacciones**
```bash
# Consultar estado de transacción
curl http://localhost:3002/api/payments/epayco/status/TRANSACTION_ID \
  -H "Authorization: Bearer tu-jwt-token"
```

## 🔄 **Migración a Producción**

### 1. **Cambiar Variables de Entorno**
```env
# Cambiar a producción
PAYMENT_MODE=production

# Usar credenciales de producción
EPAYCO_PUBLIC_KEY=tu-llave-publica-produccion
EPAYCO_PRIVATE_KEY=tu-llave-privada-produccion
EPAYCO_P_KEY=tu-p-key-produccion
EPAYCO_CUSTOMER_ID=tu-customer-id-produccion

# URLs de producción
EPAYCO_CONFIRM_URL=https://tu-dominio.com/api/payments/epayco/confirm
EPAYCO_RESPONSE_URL=https://tu-dominio.com/checkout/success
EPAYCO_CANCEL_URL=https://tu-dominio.com/checkout/cancel
```

### 2. **Configurar Webhooks en ePayco**
1. Ve a tu panel de ePayco
2. Configuración > Webhooks
3. Agrega la URL de confirmación de producción
4. Activa las notificaciones

### 3. **Pruebas de Producción**
- ✅ **Transacciones pequeñas**: Prueba con montos mínimos
- ✅ **Webhooks**: Verifica que los webhooks funcionen
- ✅ **Logs**: Monitorea los logs de producción

## 🆘 **Solución de Problemas**

### 1. **Error: "Credenciales inválidas"**
- Verifica que las credenciales sean de sandbox
- Confirma que las variables de entorno estén configuradas
- Reinicia el servidor después de cambiar variables

### 2. **Error: "Webhook no recibido"**
- Verifica que la URL de confirmación sea accesible
- Confirma que el endpoint esté registrado en ePayco
- Revisa los logs del servidor

### 3. **Error: "Firma inválida"**
- Verifica que las llaves privadas coincidan
- Confirma que el algoritmo de firma sea correcto
- Revisa la documentación de ePayco

## 📞 **Soporte**

- **Documentación ePayco**: [https://docs.epayco.co/](https://docs.epayco.co/)
- **Soporte ePayco**: [https://epayco.co/soporte](https://epayco.co/soporte)
- **Panel de ePayco**: [https://dashboard.epayco.co/](https://dashboard.epayco.co/)

---

## ✅ **Checklist de Configuración**

- [ ] Credenciales de sandbox obtenidas
- [ ] Variables de entorno configuradas
- [ ] Servidor reiniciado
- [ ] Endpoint de configuración funcionando
- [ ] Transacción de prueba exitosa
- [ ] Webhooks configurados
- [ ] Logs funcionando
- [ ] Documentación revisada

**¡Tu configuración de ePayco en modo sandbox está lista! 🎉**

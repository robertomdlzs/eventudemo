# Sistema de Registro de Actividad (Audit Logging)

## 📋 Descripción General

El sistema de registro de actividad (audit logging) de Eventu registra automáticamente todas las acciones realizadas por usuarios en la plataforma, proporcionando un historial completo de actividades para auditoría, seguridad y análisis.

## 🏗️ Arquitectura del Sistema

### Componentes Principales

1. **Base de Datos**: Tabla `audit_logs` en PostgreSQL
2. **Servicio de Auditoría**: `AuditService` para manejar operaciones
3. **Middleware**: `auditMiddleware` para capturar actividades automáticamente
4. **API Routes**: Endpoints para consultar y exportar logs
5. **Interfaz de Administración**: Panel web para visualizar logs

### Estructura de la Base de Datos

```sql
CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    resource VARCHAR(100) NOT NULL,
    resource_id VARCHAR(255),
    details JSONB,
    ip_address INET NOT NULL,
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    severity VARCHAR(20) DEFAULT 'low',
    status VARCHAR(20) DEFAULT 'success'
);
```

## 📊 Tipos de Actividades Registradas

### 🔐 Autenticación
- **LOGIN**: Inicio de sesión exitoso
- **LOGOUT**: Cierre de sesión
- **REGISTER**: Registro de nuevos usuarios
- **PASSWORD_RESET**: Recuperación de contraseña
- **LOGIN_FAILED**: Intentos de login fallidos

### 👥 Gestión de Usuarios
- **CREATE USER**: Creación de usuarios
- **UPDATE USER**: Actualización de datos de usuario
- **DELETE USER**: Eliminación de usuarios
- **CHANGE_ROLE**: Cambio de roles de usuario
- **ACTIVATE/DEACTIVATE**: Activación/desactivación de cuentas

### 🎫 Gestión de Eventos
- **CREATE EVENT**: Creación de eventos
- **UPDATE EVENT**: Actualización de eventos
- **DELETE EVENT**: Eliminación de eventos
- **PUBLISH EVENT**: Publicación de eventos
- **CANCEL EVENT**: Cancelación de eventos

### 🎟️ Gestión de Tickets
- **CREATE TICKET_TYPE**: Creación de tipos de boletas
- **UPDATE TICKET_TYPE**: Actualización de tipos de boletas
- **DELETE TICKET_TYPE**: Eliminación de tipos de boletas
- **GENERATE TICKETS**: Generación de boletas

### 💰 Transacciones Financieras
- **PAYMENT_CREATED**: Creación de pagos
- **PAYMENT_SUCCESS**: Pagos exitosos
- **PAYMENT_FAILED**: Pagos fallidos
- **REFUND_CREATED**: Creación de reembolsos
- **REFUND_PROCESSED**: Reembolsos procesados

### 🗺️ Mapas de Asientos
- **CREATE SEAT_MAP**: Creación de mapas de asientos
- **UPDATE SEAT_MAP**: Actualización de mapas
- **DELETE SEAT_MAP**: Eliminación de mapas
- **SEAT_SELECTION**: Selección de asientos

### 📁 Gestión de Medios
- **UPLOAD_FILE**: Subida de archivos
- **DELETE_FILE**: Eliminación de archivos
- **CREATE_FOLDER**: Creación de carpetas

## 🎯 Niveles de Severidad

- **LOW**: Actividades rutinarias (lectura, navegación)
- **MEDIUM**: Actividades importantes (login, actualizaciones)
- **HIGH**: Actividades críticas (eliminaciones, cambios de rol)
- **CRITICAL**: Actividades de máxima importancia (transacciones, eliminaciones masivas)

## 🔧 Implementación Técnica

### Middleware de Auditoría

```javascript
// Ejemplo de uso en rutas
router.post('/users', auth, requireAdmin, auditAdmin('USER', { action: 'CREATE' }), async (req, res) => {
  // Lógica de creación de usuario
})
```

### Servicio de Auditoría

```javascript
// Registrar actividad manualmente
await AuditService.logActivity({
  userId: req.user.userId,
  userName: req.user.name,
  userEmail: req.user.email,
  action: 'CUSTOM_ACTION',
  resource: 'CUSTOM_RESOURCE',
  details: { customData: 'value' },
  ipAddress: req.ip,
  userAgent: req.get('User-Agent'),
  severity: 'medium',
  status: 'success'
})
```

## 📈 API Endpoints

### Obtener Logs de Auditoría
```
GET /api/audit/logs
Query Parameters:
- limit: Número de registros (default: 50)
- offset: Offset para paginación (default: 0)
- userId: Filtrar por ID de usuario
- action: Filtrar por acción
- resource: Filtrar por recurso
- severity: Filtrar por severidad
- status: Filtrar por estado
- startDate: Fecha de inicio
- endDate: Fecha de fin
```

### Obtener Estadísticas
```
GET /api/audit/stats
```

### Exportar Logs
```
GET /api/audit/export
Query Parameters: (mismos filtros que logs)
Response: Archivo CSV
```

### Limpiar Logs Antiguos
```
POST /api/audit/cleanup
```

## 🖥️ Interfaz de Administración

### Ubicación
- **URL**: `/admin/auditoria`
- **Acceso**: Solo administradores
- **Componente**: `AdminAuditClient`

### Funcionalidades

1. **Dashboard de Estadísticas**
   - Total de logs
   - Actividades críticas
   - Fallos del sistema
   - Actividad del día

2. **Filtros Avanzados**
   - Búsqueda por usuario/email
   - Filtro por acción
   - Filtro por recurso
   - Filtro por severidad
   - Filtro por estado
   - Rango de fechas

3. **Tabla de Logs**
   - Información del usuario
   - Acción realizada
   - Recurso afectado
   - Nivel de severidad
   - Estado de la operación
   - Fecha y hora
   - Detalles completos

4. **Exportación**
   - Exportar a CSV
   - Filtros aplicables
   - Límite de 10,000 registros

## 🔒 Seguridad y Privacidad

### Datos Sensibles
- Las contraseñas se redactan automáticamente
- Los tokens se ocultan en los logs
- Los datos de tarjetas de crédito se enmascaran

### Retención de Datos
- Los logs se mantienen por 90 días por defecto
- Función de limpieza automática disponible
- Exportación para archivo permanente

### Acceso
- Solo administradores pueden acceder a los logs
- Autenticación requerida para todas las operaciones
- Logs de acceso a los logs de auditoría

## 📊 Casos de Uso

### 1. Seguridad
- Detectar intentos de acceso no autorizados
- Monitorear actividades sospechosas
- Rastrear cambios en configuraciones críticas

### 2. Cumplimiento
- Auditoría para regulaciones
- Trazabilidad de transacciones
- Historial de cambios de datos

### 3. Análisis de Negocio
- Patrones de uso de usuarios
- Efectividad de funcionalidades
- Análisis de errores y fallos

### 4. Soporte Técnico
- Diagnóstico de problemas
- Rastreo de acciones de usuarios
- Resolución de disputas

## 🚀 Configuración y Despliegue

### Variables de Entorno
```env
# Configuración de base de datos (ya configurada)
DB_TYPE=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eventu_db
DB_USER=postgres
DB_PASSWORD=Eventu321
```

### Inicialización
El sistema se inicializa automáticamente al iniciar el servidor. No requiere configuración adicional.

### Mantenimiento
- Limpieza automática de logs antiguos (configurable)
- Monitoreo del tamaño de la base de datos
- Backup regular de logs importantes

## 📝 Ejemplos de Logs

### Login Exitoso
```json
{
  "user_id": "123",
  "user_name": "Juan Pérez",
  "user_email": "juan@example.com",
  "action": "LOGIN",
  "resource": "AUTH",
  "details": {
    "method": "POST",
    "endpoint": "/api/auth/login",
    "duration": "245ms"
  },
  "ip_address": "192.168.1.100",
  "severity": "medium",
  "status": "success"
}
```

### Creación de Evento
```json
{
  "user_id": "456",
  "user_name": "María García",
  "user_email": "maria@example.com",
  "action": "CREATE",
  "resource": "EVENT",
  "resource_id": "789",
  "details": {
    "eventName": "Concierto de Rock",
    "eventDate": "2024-12-25",
    "venue": "Teatro Principal"
  },
  "ip_address": "192.168.1.101",
  "severity": "high",
  "status": "success"
}
```

### Transacción Financiera
```json
{
  "user_id": "789",
  "user_name": "Carlos López",
  "user_email": "carlos@example.com",
  "action": "TRANSACTION",
  "resource": "PAYMENT",
  "resource_id": "TXN_123456",
  "details": {
    "amount": 50000,
    "currency": "COP",
    "paymentMethod": "credit_card",
    "transactionId": "TXN_123456"
  },
  "ip_address": "192.168.1.102",
  "severity": "critical",
  "status": "success"
}
```

## 🔄 Actualizaciones Futuras

### Funcionalidades Planificadas
- Alertas en tiempo real para actividades críticas
- Dashboard de métricas avanzadas
- Integración con sistemas de monitoreo externos
- Análisis de patrones de comportamiento
- Reportes automatizados

### Mejoras de Rendimiento
- Índices optimizados para consultas frecuentes
- Particionado de tablas por fecha
- Compresión de logs antiguos
- Cache de estadísticas frecuentes

---

## 📞 Soporte

Para preguntas o problemas con el sistema de auditoría, contactar al equipo de desarrollo.

**Versión**: 1.0.0  
**Última actualización**: Septiembre 2024
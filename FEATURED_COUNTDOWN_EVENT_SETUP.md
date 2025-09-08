# Sistema de Evento Próximo con Cuenta Regresiva - Eventu

## 🎯 **Funcionalidad Implementada**

Este documento describe el sistema completo para que los administradores puedan gestionar el evento próximo destacado con cuenta regresiva, incluyendo la capacidad de cambiar el evento, configurar la cuenta regresiva, y redireccionamiento a compra.

## 📋 **Características Principales**

### **1. Gestión Completa del Evento Próximo** 🎪
- **Edición en Tiempo Real**: Los administradores pueden cambiar todos los aspectos del evento próximo
- **Activación/Desactivación**: Control total sobre cuándo mostrar el evento próximo
- **Vista Previa**: Los cambios se ven inmediatamente en el panel de administración
- **Redireccionamiento Configurable**: URL personalizada o slug automático

### **2. Información del Evento** 📅
- **Título**: Nombre del evento (ej: "PANACA VIAJERO BARRANQUILLA")
- **Fecha**: Fecha del evento (ej: "20 DE JUNIO 2025")
- **Ubicación**: Lugar del evento (ej: "PARQUE NORTE - BARRANQUILLA")
- **Imagen**: URL de la imagen de fondo del banner
- **Slug**: Generado automáticamente del título para redireccionamiento
- **URL Personalizada**: Redireccionamiento a URL externa si se desea

### **3. Cuenta Regresiva Dinámica** ⏰
- **Cálculo Automático**: Los días restantes se calculan automáticamente
- **Actualización en Tiempo Real**: Se actualiza cada 24 horas
- **Fallback Inteligente**: Si hay error, usa datos por defecto
- **Estado de Carga**: Indicador visual mientras carga los datos

## 🗄️ **Base de Datos**

### **Tabla `featured_countdown_event`**

```sql
CREATE TABLE featured_countdown_event (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Título del evento',
    date VARCHAR(100) NOT NULL COMMENT 'Fecha del evento (formato display)',
    location VARCHAR(255) NOT NULL COMMENT 'Ubicación del evento',
    image_url VARCHAR(500) DEFAULT '/placeholder.jpg' COMMENT 'URL de la imagen del evento',
    event_slug VARCHAR(255) COMMENT 'Slug del evento para redireccionamiento',
    redirect_url VARCHAR(500) COMMENT 'URL personalizada de redireccionamiento',
    is_active BOOLEAN DEFAULT TRUE COMMENT 'Si el evento está activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_featured_countdown_active (is_active),
    INDEX idx_featured_countdown_created (created_at)
);
```

### **Vista `active_featured_countdown`**
```sql
CREATE OR REPLACE VIEW active_featured_countdown AS
SELECT 
    id, title, date, location, image_url, event_slug, redirect_url, is_active, created_at, updated_at
FROM featured_countdown_event 
WHERE is_active = TRUE 
ORDER BY updated_at DESC 
LIMIT 1;
```

## 🎨 **Interfaz de Administración**

### **1. Panel de Administración**
- **URL**: `/admin/evento-proximo`
- **Acceso**: Solo administradores autenticados
- **Ubicación**: En el menú "Eventos" del sidebar de administración

### **2. Formulario de Edición**

#### **Estado del Evento**
```tsx
<div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
  <div>
    <h3 className="font-semibold text-gray-900">Estado del Evento</h3>
    <p className="text-sm text-gray-600">Activar o desactivar el evento próximo</p>
  </div>
  <div className="flex items-center gap-2">
    <Switch
      checked={eventData.is_active}
      onCheckedChange={(checked) => 
        setEventData(prev => ({ ...prev, is_active: checked }))
      }
    />
    <Badge variant={eventData.is_active ? "default" : "secondary"}>
      {eventData.is_active ? "Activo" : "Inactivo"}
    </Badge>
  </div>
</div>
```

#### **Información Básica**
- **Título del Evento**: Campo de texto con generación automática de slug
- **Fecha del Evento**: Campo de texto para fecha en formato display
- **Ubicación**: Campo de texto para la ubicación del evento

#### **Configuración de Imagen**
- **URL de la Imagen**: Campo para la URL de la imagen de fondo

#### **Configuración de Redireccionamiento**
- **Slug del Evento**: Generado automáticamente del título
- **URL Personalizada**: Campo opcional para redireccionamiento externo

### **3. Vista Previa en Tiempo Real**
- **Estado**: Muestra si el evento está activo o inactivo
- **Información**: Título, fecha, ubicación
- **Redireccionamiento**: URL que se usará para el botón de compra
- **Imagen**: Vista previa de la imagen de fondo

## 🔧 **API Endpoints**

### **1. Endpoints de Administración**

#### **GET /api/admin/featured-countdown-event**
- **Propósito**: Obtener evento próximo actual
- **Autenticación**: Requerida (admin)
- **Respuesta**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "PANACA VIAJERO BARRANQUILLA",
    "date": "20 DE JUNIO 2025",
    "location": "PARQUE NORTE - BARRANQUILLA",
    "image_url": "/placeholder.jpg",
    "event_slug": "panaca-viajero-barranquilla",
    "redirect_url": "",
    "is_active": true,
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z"
  },
  "message": "Evento próximo obtenido correctamente"
}
```

#### **POST /api/admin/featured-countdown-event**
- **Propósito**: Crear o actualizar evento próximo
- **Autenticación**: Requerida (admin)
- **Body**:
```json
{
  "title": "PANACA VIAJERO BARRANQUILLA",
  "date": "20 DE JUNIO 2025",
  "location": "PARQUE NORTE - BARRANQUILLA",
  "image_url": "/placeholder.jpg",
  "event_slug": "panaca-viajero-barranquilla",
  "redirect_url": "",
  "is_active": true
}
```

#### **PUT /api/admin/featured-countdown-event/toggle**
- **Propósito**: Activar/desactivar evento próximo
- **Autenticación**: Requerida (admin)
- **Body**:
```json
{
  "is_active": true
}
```

#### **GET /api/admin/featured-countdown-event/history**
- **Propósito**: Obtener historial de eventos próximos
- **Autenticación**: Requerida (admin)

### **2. Endpoints Públicos**

#### **GET /api/public/featured-countdown-event**
- **Propósito**: Obtener evento próximo activo (público)
- **Autenticación**: No requerida
- **Respuesta**:
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "PANACA VIAJERO BARRANQUILLA",
    "date": "20 DE JUNIO 2025",
    "location": "PARQUE NORTE - BARRANQUILLA",
    "image_url": "/placeholder.jpg",
    "event_slug": "panaca-viajero-barranquilla",
    "redirect_url": "",
    "is_active": true,
    "daysLeft": 15
  },
  "message": "Evento próximo obtenido correctamente"
}
```

#### **GET /api/public/featured-countdown-event/info**
- **Propósito**: Obtener información básica del evento próximo
- **Autenticación**: No requerida

## 📱 **Componente CountdownBanner**

### **1. Características Principales**

#### **Carga Dinámica de Datos**
```tsx
const loadFeaturedEvent = async () => {
  try {
    const response = await fetch('/api/public/featured-countdown-event')
    if (response.ok) {
      const result = await response.json()
      if (result.success && result.data) {
        setEventData(result.data)
        setRemainingDays(result.data.daysLeft || 15)
      }
    }
  } catch (error) {
    console.error('Error cargando evento próximo:', error)
  } finally {
    setIsLoading(false)
  }
}
```

#### **Fallback Inteligente**
```tsx
// Usar datos dinámicos si están disponibles, sino usar props
const currentTitle = eventData?.title || title || "PANACA VIAJERO BARRANQUILLA"
const currentDate = eventData?.date || date || "20 DE JUNIO 2025"
const currentLocation = eventData?.location || location || "PARQUE NORTE - BARRANQUILLA"
const currentImageUrl = eventData?.image_url || imageUrl || "/placeholder.jpg"
const currentEventSlug = eventData?.event_slug || eventSlug || "panaca-viajero-barranquilla"
const currentRedirectUrl = eventData?.redirect_url || redirectUrl
const currentIsActive = eventData?.is_active !== undefined ? eventData.is_active : isActive
```

#### **Redireccionamiento Configurable**
```tsx
const getRedirectUrl = () => {
  if (currentRedirectUrl) {
    return currentRedirectUrl
  }
  return `/evento/${currentEventSlug}`
}
```

### **2. Estados del Componente**

#### **Estado de Carga**
```tsx
if (isLoading) {
  return (
    <div className="relative bg-gradient-to-r from-neutral-900 via-neutral-800 to-neutral-900 overflow-hidden">
      <div className="container mx-auto px-4 relative z-10 py-6">
        <div className="flex items-center justify-center">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-amber-400"></div>
        </div>
      </div>
    </div>
  )
}
```

#### **Estado Inactivo**
```tsx
// No mostrar si está inactivo
if (!currentIsActive) {
  return null
}
```

### **3. Cuenta Regresiva en Tiempo Real**
```tsx
useEffect(() => {
  const countdownInterval = setInterval(
    () => {
      setRemainingDays((prevDays) => Math.max(0, prevDays - 1))
    },
    24 * 60 * 60 * 1000,
  ) // Update every day

  return () => clearInterval(countdownInterval)
}, [])
```

## 🚀 **Flujo de Trabajo**

### **1. Configuración Inicial**
1. **Administrador** accede a `/admin/evento-proximo`
2. **Sistema** carga el evento actual o muestra datos por defecto
3. **Administrador** ve el formulario con vista previa

### **2. Edición del Evento**
1. **Administrador** modifica los campos del evento
2. **Sistema** genera automáticamente el slug del título
3. **Vista previa** se actualiza en tiempo real
4. **Administrador** guarda los cambios

### **3. Activación/Desactivación**
1. **Administrador** usa el switch para activar/desactivar
2. **Sistema** actualiza el estado en la base de datos
3. **Banner** aparece o desaparece automáticamente

### **4. Experiencia del Usuario**
1. **Usuario** visita la página principal
2. **CountdownBanner** carga datos dinámicamente
3. **Banner** muestra el evento próximo con cuenta regresiva
4. **Usuario** hace clic en "COMPRAR ENTRADAS"
5. **Sistema** redirige según configuración (slug o URL personalizada)

## 📊 **Casos de Uso**

### **1. Evento PANACA (Actual)**
- **Configuración**: PANACA VIAJERO BARRANQUILLA, 20 DE JUNIO 2025
- **Ubicación**: PARQUE NORTE - BARRANQUILLA
- **Redireccionamiento**: `/evento/panaca-viajero-barranquilla`
- **Estado**: Activo

### **2. Evento Personalizado**
- **Configuración**: Evento personalizado con URL externa
- **Redireccionamiento**: `https://ejemplo.com/comprar`
- **Estado**: Activo

### **3. Evento Desactivado**
- **Configuración**: Cualquier evento
- **Estado**: Inactivo
- **Resultado**: Banner no se muestra

### **4. Fallback por Error**
- **Configuración**: Error en API o base de datos
- **Resultado**: Banner muestra datos por defecto
- **Funcionalidad**: Mantiene la experiencia del usuario

## 🔒 **Validaciones y Seguridad**

### **1. Validaciones del Frontend**
- **Campos requeridos**: Título, fecha y ubicación son obligatorios
- **Generación de slug**: Automática y consistente
- **Vista previa**: Actualización en tiempo real

### **2. Validaciones del Backend**
- **Autenticación**: Solo administradores pueden modificar
- **Validación de datos**: Estructura y tipos correctos
- **Sanitización**: Datos limpios antes de guardar

### **3. Seguridad**
- **Autenticación JWT**: Para endpoints de administración
- **Autorización**: Verificación de permisos de admin
- **Validación de entrada**: Sanitización de datos

## 📈 **Métricas y Monitoreo**

### **1. Logs Importantes**
- **Cambios de configuración**: Quién cambió qué evento
- **Errores de API**: Problemas con carga de datos
- **Uso del banner**: Clicks en "COMPRAR ENTRADAS"

### **2. Métricas de Uso**
- **Eventos configurados**: Cuántos eventos se han configurado
- **Tiempo de activación**: Cuánto tiempo está activo cada evento
- **Conversiones**: Clicks en el banner vs compras

## 🔄 **Actualizaciones Futuras**

### **1. Funcionalidades Adicionales**
- **Múltiples eventos**: Rotación automática de eventos
- **Programación**: Activación automática por fecha
- **Analytics**: Dashboard de métricas del banner
- **A/B Testing**: Pruebas de diferentes configuraciones

### **2. Mejoras Técnicas**
- **Cache**: Cache de datos para mejor rendimiento
- **WebSockets**: Actualizaciones en tiempo real
- **CDN**: Imágenes optimizadas
- **SEO**: Meta tags dinámicos

## 📞 **Soporte y Documentación**

### **1. Archivos Creados**
- `scripts/add_featured_countdown_event.sql` - Migración de base de datos
- `scripts/run-featured-countdown-migration.js` - Ejecutor de migración
- `app/admin/evento-proximo/page.tsx` - Interfaz de administración
- `backend/api/admin/featured-countdown-event.js` - API de administración
- `backend/api/public/featured-countdown-event.js` - API pública
- `components/countdown-banner.tsx` - Componente actualizado

### **2. Archivos Modificados**
- `components/admin/admin-sidebar.tsx` - Agregado enlace al panel

---

## ✅ **Checklist de Implementación**

- [x] Script de migración de base de datos creado
- [x] Tabla `featured_countdown_event` definida
- [x] Vista `active_featured_countdown` creada
- [x] Interfaz de administración implementada
- [x] API endpoints de administración creados
- [x] API endpoints públicos creados
- [x] Componente CountdownBanner actualizado
- [x] Carga dinámica de datos implementada
- [x] Fallback inteligente implementado
- [x] Redireccionamiento configurable implementado
- [x] Activación/desactivación implementada
- [x] Vista previa en tiempo real implementada
- [x] Enlace en sidebar de administración agregado
- [x] Documentación completa creada
- [x] Scripts de migración ejecutables

**¡El sistema de evento próximo con cuenta regresiva está completamente implementado y listo para usar! 🎉**

## 🚀 **Próximos Pasos**

1. **Ejecutar migración**: Aplicar cambios a la base de datos
2. **Probar funcionalidad**: Crear y editar eventos próximos
3. **Verificar banner**: Confirmar que muestra datos correctos
4. **Entrenar administradores**: Explicar cómo usar la nueva funcionalidad
5. **Monitorear uso**: Seguir métricas de adopción y conversión


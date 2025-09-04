# 🎫 Panel de Organizador - Eventu

## 📋 Índice

1. [Descripción General](#descripción-general)
2. [Arquitectura del Sistema](#arquitectura-del-sistema)
3. [Funcionalidades Implementadas](#funcionalidades-implementadas)
4. [API Endpoints](#api-endpoints)
5. [Base de Datos](#base-de-datos)
6. [Instalación y Configuración](#instalación-y-configuración)
7. [Uso del Panel](#uso-del-panel)
8. [Pruebas y Testing](#pruebas-y-testing)
9. [Troubleshooting](#troubleshooting)
10. [Roadmap](#roadmap)

---

## 🎯 Descripción General

El **Panel de Organizador** es una plataforma completa para que los organizadores de eventos gestionen sus eventos, ventas, asistentes y analíticas en tiempo real. Proporciona una interfaz moderna y intuitiva con todas las herramientas necesarias para el éxito de eventos.

### 🎨 Características Principales

- **Dashboard en Tiempo Real** con métricas actualizadas automáticamente
- **Gestión Completa de Eventos** con estados y filtros avanzados
- **Sistema de Ventas** con seguimiento detallado de transacciones
- **Gestión de Asistentes** con funcionalidades de check-in
- **Analíticas Profesionales** con gráficos y reportes
- **Sistema de Reportes** exportables en múltiples formatos
- **Interfaz Responsive** optimizada para todos los dispositivos

---

## 🏗️ Arquitectura del Sistema

### Frontend (Next.js 14)
```
app/organizer/
├── layout.tsx                    # Layout principal con sidebar
├── page.tsx                      # Dashboard principal
├── OrganizerDashboardClient.tsx  # Dashboard con métricas
├── eventos/
│   ├── page.tsx
│   └── OrganizerEventsPageClient.tsx
├── ventas/
│   ├── page.tsx
│   └── OrganizerSalesPageClient.tsx
├── asistentes/
│   ├── page.tsx
│   └── OrganizerAttendeesPageClient.tsx
├── checkin/
│   ├── page.tsx
│   └── OrganizerCheckInPageClient.tsx
├── analytics/
│   ├── page.tsx
│   └── OrganizerAnalyticsPageClient.tsx
└── reportes/
    ├── page.tsx
    └── OrganizerReportsPageClient.tsx
```

### Backend (Node.js + Express)
```
backend/routes/
└── organizer.js                  # Todas las rutas del organizador

backend/middleware/
├── auth.js                       # Autenticación
└── requireRole.js               # Autorización por roles
```

### Base de Datos (PostgreSQL)
```
Tablas principales:
├── users                         # Usuarios (incluye organizadores)
├── events                        # Eventos con organizer_id
├── sales                         # Ventas con check-in
├── ticket_types                  # Tipos de boletos
└── system_settings              # Configuraciones del sistema

Vistas optimizadas:
├── organizer_stats              # Estadísticas del organizador
├── realtime_sales              # Ventas en tiempo real
└── recent_activity             # Actividad reciente
```

---

## ⚡ Funcionalidades Implementadas

### 🏠 Dashboard Principal

#### Métricas en Tiempo Real
- **Ingresos Totales**: Suma de todas las ventas
- **Eventos Activos**: Eventos publicados vs borradores
- **Boletos Vendidos**: Cantidad total de boletos vendidos
- **Clientes Únicos**: Número de compradores únicos
- **Promedio por Venta**: Valor promedio de cada transacción

#### Ventas en Tiempo Real
- **Actualización Automática** cada 30 segundos
- **Ventas por Hora/Día/Semana**
- **Tasa de Ocupación** por evento
- **Última Venta** con timestamp

#### Actividad Reciente
- **Transacciones Recientes** con detalles
- **Tiempo Transcurrido** desde cada actividad
- **Filtrado por Tipo** de actividad

### 🎫 Gestión de Eventos

#### Lista de Eventos
- **Filtros Avanzados**: Estado, categoría, búsqueda
- **Estadísticas por Evento**: Boletos vendidos, ingresos, ocupación
- **Acciones Rápidas**: Ver, editar, eliminar
- **Ordenamiento**: Por fecha, ingresos, ocupación

#### Estados de Evento
- **Borrador**: Evento en desarrollo
- **Publicado**: Evento visible al público
- **Cancelado**: Evento cancelado
- **Finalizado**: Evento completado

### 💰 Gestión de Ventas

#### Seguimiento de Ventas
- **Transacciones Detalladas** con información completa
- **Filtros por Período**: Fecha inicio/fin
- **Filtros por Estado**: Completadas, pendientes, canceladas
- **Información del Comprador**: Nombre, email, método de pago

#### Métricas de Ventas
- **Ingresos por Período**
- **Tendencia de Ventas**
- **Métodos de Pago** más utilizados
- **Análisis de Rendimiento**

### 👥 Gestión de Asistentes

#### Lista de Participantes
- **Información Completa** de cada asistente
- **Estado de Check-in**: Verificado o pendiente
- **Historial de Compras** por asistente
- **Filtros Avanzados**: Por evento, estado, búsqueda

#### Funcionalidades de Check-in
- **Check-in Manual** con validación
- **Escaneo QR** (preparado para implementación)
- **Registro de Asistencia** en tiempo real
- **Historial de Check-ins**

### 📊 Analíticas y Reportes

#### Métricas de Negocio
- **Rendimiento por Período** (30, 60, 90 días)
- **Tendencias de Ventas**
- **Análisis de Eventos** con mejor rendimiento
- **Métricas de Clientes**

#### Reportes Exportables
- **Reporte de Ventas** por período
- **Reporte de Eventos** con estadísticas
- **Reporte de Asistentes** con detalles
- **Formatos**: JSON, CSV, PDF (preparado)

---

## 🔌 API Endpoints

### Dashboard y Estadísticas

#### GET `/api/organizer/dashboard-stats/:organizerId`
Obtiene estadísticas generales del dashboard.

**Respuesta:**
```json
{
  "success": true,
  "data": {
    "overview": {
      "totalEvents": 15,
      "publishedEvents": 12,
      "draftEvents": 3,
      "totalSales": 2850,
      "totalRevenue": 142500000,
      "totalTicketsSold": 8450,
      "uniqueCustomers": 2100,
      "averageOrderValue": 50000
    },
    "monthlyTrend": [...],
    "topEvents": [...],
    "recentActivity": [...]
  }
}
```

#### GET `/api/organizer/sales-realtime/:organizerId`
Obtiene datos de ventas en tiempo real.

**Respuesta:**
```json
{
  "success": true,
  "data": [
    {
      "eventId": 1,
      "eventTitle": "Concierto de Rock",
      "eventDate": "2024-02-15",
      "totalCapacity": 2000,
      "ticketsSold": 1250,
      "remainingCapacity": 750,
      "occupancyRate": 62.5,
      "totalSales": 1250,
      "totalRevenue": 31250000,
      "salesLastHour": 15,
      "salesToday": 85,
      "salesThisWeek": 320
    }
  ]
}
```

### Gestión de Eventos

#### GET `/api/organizer/events/:organizerId`
Obtiene lista de eventos del organizador con filtros.

**Parámetros:**
- `status`: Estado del evento (published, draft, all)
- `category`: Categoría del evento
- `search`: Término de búsqueda

#### GET `/api/organizer/sales/:organizerId`
Obtiene ventas del organizador con filtros.

**Parámetros:**
- `eventId`: ID del evento específico
- `startDate`: Fecha de inicio
- `endDate`: Fecha de fin
- `status`: Estado de la venta

### Gestión de Asistentes

#### GET `/api/organizer/attendees/:organizerId`
Obtiene lista de asistentes con filtros.

**Parámetros:**
- `eventId`: ID del evento específico
- `search`: Búsqueda por nombre o email
- `status`: Estado del check-in

#### POST `/api/organizer/checkin/:saleId`
Realiza check-in de un asistente.

**Body:**
```json
{
  "organizerId": 1
}
```

### Analíticas y Reportes

#### GET `/api/organizer/analytics/:organizerId`
Obtiene analíticas detalladas.

**Parámetros:**
- `period`: Período en días (30, 60, 90)

#### GET `/api/organizer/reports/:organizerId`
Genera reportes específicos.

**Parámetros:**
- `type`: Tipo de reporte (sales, events, attendees)
- `startDate`: Fecha de inicio
- `endDate`: Fecha de fin

---

## 🗄️ Base de Datos

### Campos Agregados

#### Tabla `events`
```sql
ALTER TABLE events ADD COLUMN organizer_id INTEGER REFERENCES users(id);
```

#### Tabla `sales`
```sql
ALTER TABLE sales ADD COLUMN checked_in BOOLEAN DEFAULT false;
ALTER TABLE sales ADD COLUMN check_in_time TIMESTAMP;
ALTER TABLE sales ADD COLUMN ticket_type_id INTEGER REFERENCES ticket_types(id);
```

### Índices de Rendimiento
```sql
CREATE INDEX idx_events_organizer_id ON events(organizer_id);
CREATE INDEX idx_sales_checked_in ON sales(checked_in);
CREATE INDEX idx_sales_check_in_time ON sales(check_in_time);
CREATE INDEX idx_sales_ticket_type_id ON sales(ticket_type_id);
CREATE INDEX idx_sales_created_at ON sales(created_at);
```

### Vistas Optimizadas

#### `organizer_stats`
Vista para estadísticas generales del organizador.

#### `realtime_sales`
Vista para datos de ventas en tiempo real.

#### `recent_activity`
Vista para actividad reciente del organizador.

---

## 🚀 Instalación y Configuración

### Prerrequisitos
- Node.js 18+
- PostgreSQL 12+
- npm o yarn

### 1. Configurar Base de Datos

```bash
# Ejecutar script de configuración
./scripts/setup-organizer-database.sh
```

### 2. Instalar Dependencias

```bash
# Frontend
npm install

# Backend
cd backend
npm install
```

### 3. Configurar Variables de Entorno

```bash
# backend/config.env
DB_TYPE=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eventu_db
DB_USER=eventu_user
DB_PASSWORD=eventu_password
```

### 4. Iniciar Servidores

```bash
# Terminal 1: Backend
cd backend
npm run dev

# Terminal 2: Frontend
npm run dev
```

### 5. Verificar Instalación

```bash
# Ejecutar pruebas del API
node scripts/test-organizer-api.js
```

---

## 🎮 Uso del Panel

### Acceso al Panel
1. Navegar a `http://localhost:3000/organizer`
2. Iniciar sesión con credenciales de organizador
3. El dashboard se cargará automáticamente

### Navegación
- **Dashboard**: Vista general con métricas
- **Mis Eventos**: Gestión de eventos
- **Ventas**: Seguimiento de transacciones
- **Asistentes**: Gestión de participantes
- **Analíticas**: Métricas detalladas
- **Reportes**: Generación de informes

### Funcionalidades Principales

#### Dashboard
- **Actualizar Datos**: Botón de refresh manual
- **Auto-refresh**: Actualización automática cada 30 segundos
- **Métricas Interactivas**: Click para ver detalles

#### Gestión de Eventos
- **Filtros**: Estado, categoría, búsqueda
- **Acciones**: Ver, editar, eliminar eventos
- **Estadísticas**: Boletos vendidos, ingresos, ocupación

#### Check-in
- **Búsqueda**: Por nombre, email o código QR
- **Validación**: Verificación automática de boletos
- **Registro**: Timestamp de check-in

---

## 🧪 Pruebas y Testing

### Pruebas Automáticas

```bash
# Ejecutar todas las pruebas
node scripts/test-organizer-api.js
```

### Pruebas Manuales

#### 1. Dashboard
- [ ] Carga correctamente
- [ ] Métricas se actualizan
- [ ] Auto-refresh funciona
- [ ] Botón de refresh manual funciona

#### 2. Eventos
- [ ] Lista se carga correctamente
- [ ] Filtros funcionan
- [ ] Búsqueda funciona
- [ ] Acciones (ver, editar, eliminar) funcionan

#### 3. Ventas
- [ ] Lista de ventas se carga
- [ ] Filtros por fecha funcionan
- [ ] Filtros por estado funcionan
- [ ] Detalles de venta se muestran

#### 4. Asistentes
- [ ] Lista de asistentes se carga
- [ ] Búsqueda funciona
- [ ] Check-in funciona
- [ ] Estado de check-in se actualiza

#### 5. Analíticas
- [ ] Gráficos se renderizan
- [ ] Métricas son correctas
- [ ] Filtros por período funcionan
- [ ] Exportación funciona

---

## 🔧 Troubleshooting

### Problemas Comunes

#### 1. Error de Conexión a Base de Datos
```bash
# Verificar PostgreSQL
sudo systemctl status postgresql

# Verificar conexión
psql -h localhost -U eventu_user -d eventu_db
```

#### 2. API No Responde
```bash
# Verificar servidor backend
curl http://localhost:3001/api/health

# Verificar logs
tail -f backend/logs/combined.log
```

#### 3. Datos No Se Actualizan
```bash
# Verificar auto-refresh
# Verificar conexión WebSocket
# Verificar permisos de base de datos
```

#### 4. Check-in No Funciona
```bash
# Verificar permisos de organizador
# Verificar que la venta existe
# Verificar campos de base de datos
```

### Logs y Debugging

#### Frontend
```javascript
// Habilitar logs detallados
localStorage.setItem('debug', 'true')
```

#### Backend
```bash
# Ver logs en tiempo real
tail -f backend/logs/combined.log

# Ver logs de error
tail -f backend/logs/error.log
```

---

## 🗺️ Roadmap

### Versión 1.1 (Próxima)
- [ ] **Creación de Eventos** desde el panel
- [ ] **Edición Avanzada** de eventos
- [ ] **Sistema de Notificaciones** push
- [ ] **Integración con Redes Sociales**

### Versión 1.2
- [ ] **Analytics Predictivo**
- [ ] **Sistema de Comisiones**
- [ ] **API para Terceros**
- [ ] **Modo Oscuro**

### Versión 1.3
- [ ] **Tutorial Interactivo**
- [ ] **Accesos Directos** de teclado
- [ ] **Drag & Drop** para eventos
- [ ] **Integración con Herramientas de Marketing**

### Versión 2.0
- [ ] **Marketplace de Eventos**
- [ ] **Sistema de Colaboración**
- [ ] **Analytics Avanzado**
- [ ] **Integración con CRM**

---

## 📞 Soporte

### Documentación
- [API Documentation](./API.md)
- [Database Schema](./DATABASE.md)
- [Frontend Components](./COMPONENTS.md)

### Contacto
- **Email**: soporte@eventu.com
- **Discord**: [Eventu Community](https://discord.gg/eventu)
- **GitHub**: [Issues](https://github.com/eventu/panel-organizer/issues)

### Contribuir
1. Fork el repositorio
2. Crear una rama para tu feature
3. Commit tus cambios
4. Push a la rama
5. Crear un Pull Request

---

*Este documento se actualiza regularmente. Última actualización: Enero 2025*

# Eventu - Plataforma de Gestión de Eventos

Sistema completo de gestión de eventos con frontend Next.js y backend Node.js, incluyendo funcionalidades de venta de tickets, mapas de asientos, pagos y administración.

## 🚀 Características Principales

- **Frontend**: Next.js 14 con TypeScript y Tailwind CSS
- **Backend**: Node.js con Express y PostgreSQL
- **Autenticación**: JWT con 2FA para administradores
- **Pagos**: Integración con ePayco y Cobru
- **Mapas de Asientos**: Sistema avanzado de selección de asientos
- **Administración**: Panel completo para organizadores y administradores
- **Seguridad**: Implementación de seguridad de nivel empresarial

## 📁 Estructura del Proyecto

```
my-appdemo/
├── app/                    # Aplicación Next.js (App Router)
│   ├── admin/             # Panel de administración
│   ├── carrito/           # Carrito de compras
│   ├── checkout/          # Proceso de pago
│   ├── evento/            # Páginas de eventos individuales
│   ├── eventos/           # Listado de eventos
│   ├── login/             # Autenticación
│   ├── mi-cuenta/         # Perfil de usuario
│   ├── organizer/         # Panel de organizadores
│   └── ...                # Otras páginas
├── backend/               # Servidor Node.js
│   ├── config/            # Configuraciones de base de datos
│   ├── middleware/        # Middleware de seguridad y autenticación
│   ├── models/            # Modelos de datos
│   ├── routes/            # Rutas de API
│   ├── services/          # Servicios de negocio
│   └── validators/        # Validadores de datos
├── components/            # Componentes React reutilizables
│   ├── admin/             # Componentes de administración
│   ├── organizer/         # Componentes de organizadores
│   ├── payment/           # Componentes de pago
│   └── ui/                # Componentes de interfaz
├── hooks/                 # Custom hooks de React
├── lib/                   # Utilidades y configuraciones
├── public/                # Archivos estáticos
└── scripts/               # Scripts de base de datos
```

## 🛠️ Tecnologías Utilizadas

### Frontend
- **Next.js 14** - Framework React con App Router
- **TypeScript** - Tipado estático
- **Tailwind CSS** - Framework de estilos
- **React Hook Form** - Manejo de formularios
- **Recharts** - Gráficos y visualizaciones
- **Socket.io** - Comunicación en tiempo real

### Backend
- **Node.js** - Runtime de JavaScript
- **Express** - Framework web
- **PostgreSQL** - Base de datos relacional
- **JWT** - Autenticación
- **Winston** - Logging
- **Helmet** - Seguridad
- **Rate Limiting** - Protección contra ataques

### Seguridad
- **2FA** - Autenticación de dos factores
- **WAF** - Web Application Firewall
- **SIEM** - Security Information and Event Management
- **Zero Trust** - Arquitectura de confianza cero
- **Micro-segmentación** - Segmentación de red
- **Threat Intelligence** - Inteligencia de amenazas
- **Honeypots** - Trampas para atacantes
- **Análisis de Comportamiento** - Detección de anomalías

## 🚀 Instalación y Configuración

### Prerrequisitos
- Node.js 18+
- PostgreSQL 12+
- npm o yarn

### Instalación
```bash
# Clonar el repositorio
git clone <repository-url>
cd my-appdemo

# Instalar dependencias del frontend
npm install

# Instalar dependencias del backend
cd backend
npm install
cd ..

# Configurar variables de entorno
cp backend/.env.example backend/.env
# Editar backend/.env con tus configuraciones

# Configurar base de datos
psql -d eventu_db -f scripts/eventu_database_export.sql
```

### Variables de Entorno
```env
# Database
DB_TYPE=postgresql
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eventu_db
DB_USER=postgres
DB_PASSWORD=your_password

# JWT
JWT_SECRET=your_jwt_secret
JWT_EXPIRES_IN=15m

# Server
PORT=3001
NODE_ENV=development
FRONTEND_URL=http://localhost:3000
```

## 🏃‍♂️ Ejecución

### Desarrollo
```bash
# Terminal 1: Backend
cd backend
npm start

# Terminal 2: Frontend
npm run dev
```

### Producción
```bash
# Construir aplicación
npm run build

# Iniciar en producción
npm start
```

## 📊 Base de Datos

### Scripts Disponibles
- `database_structure.sql` - Estructura completa de la base de datos
- `eventu_database_export.sql` - Exportación completa con datos de ejemplo
- `real_data_insertion.sql` (3 partes) - Datos reales para testing

### Restauración Rápida
```bash
psql -d eventu_db -f scripts/eventu_database_export.sql
```

## 🔐 Seguridad

El sistema implementa múltiples capas de seguridad:

### Autenticación y Autorización
- JWT con tokens de corta duración (15 minutos)
- 2FA obligatorio para administradores
- Rate limiting agresivo
- Validación robusta con Joi

### Protección de Datos
- Encriptación de contraseñas con bcrypt
- Headers de seguridad estrictos
- CORS restrictivo
- Escaneo de malware para uploads

### Monitoreo y Alertas
- SIEM para correlación de eventos
- Análisis de comportamiento
- Threat intelligence feeds
- Honeypots para detección de ataques

## 🎯 Funcionalidades

### Para Usuarios
- Registro y autenticación
- Exploración de eventos
- Selección de asientos
- Proceso de compra
- Gestión de tickets

### Para Organizadores
- Creación de eventos
- Gestión de mapas de asientos
- Reportes de ventas
- Configuración de precios
- Gestión de promociones

### Para Administradores
- Gestión de usuarios
- Moderación de eventos
- Reportes del sistema
- Configuración de seguridad
- Monitoreo de amenazas

## 📱 API Endpoints

### Autenticación
- `POST /api/auth/register` - Registro de usuarios
- `POST /api/auth/login` - Inicio de sesión
- `POST /api/auth/2fa` - Verificación 2FA

### Eventos
- `GET /api/events` - Listar eventos
- `POST /api/events` - Crear evento
- `GET /api/events/:id` - Obtener evento
- `PUT /api/events/:id` - Actualizar evento

### Pagos
- `POST /api/payments/epayco` - Procesar pago ePayco
- `POST /api/payments/cobru` - Procesar pago Cobru
- `GET /api/payments/:id` - Estado del pago

## 🚀 Despliegue

### Variables de Producción
```env
NODE_ENV=production
FRONTEND_URL=https://tu-dominio.com
DB_SSL=true
JWT_SECRET=secret_produccion_seguro
```

## 📈 Monitoreo

### Logs
- Winston para logging estructurado
- Rotación automática de logs
- Niveles de log configurables

### Métricas
- Métricas de rendimiento
- Monitoreo de seguridad
- Alertas automáticas

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 🆘 Soporte

Para soporte técnico o preguntas:
- Crear un issue en GitHub
- Revisar la documentación
- Contactar al equipo de desarrollo

---

**Nota**: Este proyecto ha sido optimizado y limpiado para mantener solo los archivos esenciales para el funcionamiento del sistema.# eventudemo

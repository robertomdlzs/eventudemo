# 🚀 Despliegue en Vercel - Eventu

Guía completa para desplegar la aplicación Eventu en Vercel con frontend y backend.

## 📋 Prerrequisitos

1. **Cuenta de Vercel** - [Crear cuenta gratuita](https://vercel.com)
2. **Repositorio en GitHub** - El proyecto debe estar en GitHub
3. **Vercel CLI** (opcional) - Para deploy desde terminal

## 🔧 Configuración del Proyecto

### 1. Archivos de Configuración

El proyecto ya incluye los archivos necesarios:
- `vercel.json` - Configuración de Vercel
- `vercel.env.example` - Variables de entorno de ejemplo
- `next.config.js` - Configurado para Vercel

### 2. Instalación de Vercel CLI (Opcional)

```bash
npm i -g vercel
```

## 🚀 Pasos para Desplegar

### Opción 1: Despliegue Automático desde GitHub (Recomendado)

1. **Conectar Repositorio:**
   - Ve a [Vercel Dashboard](https://vercel.com/dashboard)
   - Click en "New Project"
   - Selecciona "Import Git Repository"
   - Conecta tu cuenta de GitHub
   - Selecciona tu repositorio `eventudev`

2. **Configurar Proyecto:**
   - **Framework Preset:** Next.js
   - **Root Directory:** `./` (raíz del proyecto)
   - **Build Command:** `npm run build`
   - **Output Directory:** `.next` (automático)

3. **Configurar Variables de Entorno:**
   - Ve a "Environment Variables"
   - Agrega las variables del archivo `vercel.env.example`

4. **Desplegar:**
   - Click en "Deploy"
   - Vercel construirá y desplegará automáticamente

### Opción 2: Despliegue con CLI

1. **Login en Vercel:**
   ```bash
   vercel login
   ```

2. **Deploy:**
   ```bash
   vercel
   ```

3. **Deploy a Producción:**
   ```bash
   vercel --prod
   ```

## 🗄️ Configuración de Base de Datos

### Opción 1: Vercel Postgres (Recomendado)

1. **Crear Base de Datos:**
   - Ve a tu proyecto en Vercel
   - Click en "Storage" > "Create Database"
   - Selecciona "Postgres"
   - Configura nombre y región

2. **Variables Automáticas:**
   Vercel configurará automáticamente:
   ```
   POSTGRES_URL
   POSTGRES_PRISMA_URL
   POSTGRES_URL_NON_POOLING
   POSTGRES_USER
   POSTGRES_HOST
   POSTGRES_PASSWORD
   POSTGRES_DATABASE
   ```

### Opción 2: Base de Datos Externa

Puedes usar:
- **Supabase** (gratis)
- **PlanetScale** (gratis)
- **Railway** (gratis)
- **Neon** (gratis)

## ⚙️ Variables de Entorno Necesarias

### Variables Obligatorias:
```env
NEXT_PUBLIC_API_URL=https://tu-proyecto.vercel.app
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
JWT_SECRET=tu-jwt-secret-super-seguro
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
```

### Variables de Base de Datos (si usas Vercel Postgres):
```env
POSTGRES_URL=postgres://...
POSTGRES_PRISMA_URL=postgres://...
POSTGRES_URL_NON_POOLING=postgres://...
POSTGRES_USER=username
POSTGRES_HOST=host
POSTGRES_PASSWORD=password
POSTGRES_DATABASE=database
```

## 🔄 Configuración del Backend

### 1. Rutas API

El archivo `vercel.json` ya está configurado para:
- **Frontend:** Next.js en la raíz
- **Backend:** Node.js en `/api/*`

### 2. Serverless Functions

Tu backend se ejecutará como serverless functions en:
- `/api/auth/*`
- `/api/events/*`
- `/api/users/*`
- etc.

## 🌐 URLs de Ejemplo

Después del despliegue tendrás:
- **Frontend:** `https://tu-proyecto.vercel.app`
- **Backend API:** `https://tu-proyecto.vercel.app/api/*`

## 🔧 Troubleshooting

### Error: "Build failed"

1. **Verificar Node version:**
   - Vercel usa Node 18 por defecto
   - Configurado en `vercel.json`

2. **Verificar dependencias:**
   ```bash
   npm install
   npm run build
   ```

3. **Verificar variables de entorno:**
   - Todas las variables deben estar configuradas

### Error: "Database connection failed"

1. **Verificar variables de base de datos:**
   - Las variables POSTGRES_* deben estar configuradas
   - Verificar que la base de datos esté activa

2. **Verificar conexión:**
   - Probar conexión desde el dashboard de Vercel

### Error: "API not found"

1. **Verificar rutas:**
   - El archivo `vercel.json` debe tener las rutas correctas
   - Verificar que el backend esté en la carpeta correcta

## 📊 Monitoreo

### Vercel Analytics

1. Ve a "Analytics" en el dashboard
2. Activa "Vercel Analytics"
3. Monitorea visitas y rendimiento

### Logs

1. Ve a "Functions" > "Logs"
2. Revisa logs de build y runtime
3. Identifica errores y warnings

## 🔄 Actualizaciones

### Despliegue Automático

- Cada push a `main` desplegará automáticamente
- Vercel construirá y desplegará en ~2-3 minutos

### Despliegue Manual

```bash
vercel --prod
```

## 🆘 Soporte

Si tienes problemas:

1. **Revisa logs de build** en Vercel
2. **Verifica variables de entorno**
3. **Confirma que la base de datos esté funcionando**
4. **Revisa la documentación de Vercel**

## 🎯 Ventajas de Vercel

- ✅ **Un solo deploy** para frontend y backend
- ✅ **Base de datos incluida** (Vercel Postgres)
- ✅ **Serverless Functions** automáticas
- ✅ **CDN global** para mejor rendimiento
- ✅ **Deploy automático** desde GitHub
- ✅ **Optimizado para Next.js**

---

**¡Listo!** Tu aplicación Eventu estará disponible en Vercel con frontend y backend funcionando. 🎉
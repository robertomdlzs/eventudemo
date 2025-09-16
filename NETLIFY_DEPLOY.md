# 🚀 Despliegue en Netlify - Eventu

Guía completa para desplegar la aplicación Eventu en Netlify.

## 📋 Prerrequisitos

1. **Cuenta de Netlify** - [Crear cuenta gratuita](https://netlify.com)
2. **Repositorio en GitHub** - El proyecto debe estar en GitHub
3. **Backend desplegado** - Necesitas un backend funcionando (Heroku, Railway, etc.)

## 🔧 Configuración del Proyecto

### 1. Archivos de Configuración

El proyecto ya incluye los archivos necesarios:
- `netlify.toml` - Configuración de Netlify
- `netlify.env.example` - Variables de entorno de ejemplo
- `next.config.js` - Configurado para export estático

### 2. Variables de Entorno

Configura las siguientes variables en Netlify:

```env
NEXT_PUBLIC_API_URL=https://tu-backend-url.com
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
```

## 🚀 Pasos para Desplegar

### Opción 1: Despliegue Automático desde GitHub

1. **Conectar Repositorio:**
   - Ve a [Netlify Dashboard](https://app.netlify.com)
   - Click en "New site from Git"
   - Selecciona "GitHub" y autoriza la conexión
   - Selecciona tu repositorio `eventudev`

2. **Configurar Build Settings:**
   - **Build command:** `npm run build`
   - **Publish directory:** `out`
   - **Node version:** `18`

3. **Configurar Variables de Entorno:**
   - Ve a "Site settings" > "Environment variables"
   - Agrega las variables del archivo `netlify.env.example`

4. **Desplegar:**
   - Click en "Deploy site"
   - Netlify construirá y desplegará automáticamente

### Opción 2: Despliegue Manual

1. **Build Local:**
   ```bash
   npm install
   npm run build
   ```

2. **Subir a Netlify:**
   - Arrastra la carpeta `out` a [Netlify Drop](https://app.netlify.com/drop)

## ⚙️ Configuración Avanzada

### Headers de Seguridad

El archivo `netlify.toml` incluye headers de seguridad:
- X-Frame-Options: DENY
- X-Content-Type-Options: nosniff
- X-XSS-Protection: 1; mode=block
- Content Security Policy

### Redirecciones

Configurado para SPA (Single Page Application):
- Todas las rutas redirigen a `/index.html`

### Caché

- Archivos estáticos: 1 año
- Imágenes: 1 año
- HTML: Sin caché

## 🔗 Configuración del Backend

### Opción 1: Heroku (Recomendado)

1. **Crear app en Heroku:**
   ```bash
   heroku create tu-app-backend
   ```

2. **Configurar variables:**
   ```bash
   heroku config:set NODE_ENV=production
   heroku config:set DB_HOST=tu-db-host
   heroku config:set DB_PASSWORD=tu-password
   ```

3. **Desplegar:**
   ```bash
   git subtree push --prefix backend heroku main
   ```

### Opción 2: Railway

1. Conectar repositorio en [Railway](https://railway.app)
2. Configurar variables de entorno
3. Deploy automático

### Opción 3: Render

1. Conectar repositorio en [Render](https://render.com)
2. Configurar como Web Service
3. Deploy automático

## 🌐 URLs de Ejemplo

Después del despliegue tendrás:
- **Frontend:** `https://tu-app.netlify.app`
- **Backend:** `https://tu-backend.herokuapp.com`

## 🔧 Troubleshooting

### Error: "Build failed"

1. **Verificar Node version:**
   - Asegúrate de usar Node 18
   - Configura en `netlify.toml`

2. **Verificar dependencias:**
   ```bash
   npm install
   npm run build
   ```

3. **Verificar variables de entorno:**
   - Todas las variables deben estar configuradas

### Error: "API not found"

1. **Verificar URL del backend:**
   - La variable `NEXT_PUBLIC_API_URL` debe apuntar al backend
   - El backend debe estar funcionando

2. **Verificar CORS:**
   - El backend debe permitir requests desde Netlify

### Error: "Page not found"

1. **Verificar redirecciones:**
   - El archivo `netlify.toml` incluye redirecciones para SPA

2. **Verificar rutas:**
   - Todas las rutas deben estar definidas en Next.js

## 📊 Monitoreo

### Netlify Analytics

1. Ve a "Analytics" en el dashboard
2. Activa "Netlify Analytics"
3. Monitorea visitas y rendimiento

### Logs

1. Ve a "Functions" > "Logs"
2. Revisa logs de build y runtime
3. Identifica errores y warnings

## 🔄 Actualizaciones

### Despliegue Automático

- Cada push a `main` desplegará automáticamente
- Netlify construirá y desplegará en ~2-3 minutos

### Despliegue Manual

1. Ve a "Deploys" en el dashboard
2. Click en "Trigger deploy"
3. Selecciona "Deploy site"

## 🆘 Soporte

Si tienes problemas:

1. **Revisa logs de build** en Netlify
2. **Verifica variables de entorno**
3. **Confirma que el backend esté funcionando**
4. **Revisa la documentación de Netlify**

---

**¡Listo!** Tu aplicación Eventu estará disponible en Netlify. 🎉

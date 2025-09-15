# 🚀 Guía de Despliegue en DomCloud

Esta guía te ayudará a desplegar tu aplicación Next.js con backend Node.js en DomCloud.

## 📋 Requisitos Previos

1. **Cuenta en DomCloud** activa
2. **Base de datos MySQL** configurada en DomCloud
3. **Repositorio en GitHub** actualizado (ya completado ✅)

## 🔧 Configuración

### 1. Archivos de Configuración

Los siguientes archivos ya están configurados para DomCloud:

- ✅ `domcloud.yaml` - Configuración principal de DomCloud
- ✅ `backend/domcloud.config.js` - Configuración específica del backend
- ✅ `env.production.example` - Variables de entorno de ejemplo
- ✅ `deploy-domcloud.sh` - Script de despliegue

### 2. Variables de Entorno

Antes del despliegue, configura estas variables en el panel de DomCloud:

```bash
# Base de datos
DB_HOST=localhost
DB_USER=tu_usuario_db
DB_PASSWORD=tu_password_db
DB_NAME=eventudev
DB_PORT=3306

# JWT
JWT_SECRET=tu-jwt-secret-super-seguro

# URLs
NEXT_PUBLIC_API_URL=https://tu-dominio.com/api
FRONTEND_URL=https://tu-dominio.com

# Puerto (DomCloud lo asigna automáticamente)
PORT=$PORT
```

## 🚀 Proceso de Despliegue

### Paso 1: Conectar Repositorio

1. Ve al panel de DomCloud
2. Crea una nueva aplicación
3. Conecta tu repositorio: `https://github.com/robertmdlzs01/eventudev.git`
4. Selecciona la rama `main`

### Paso 2: Configurar Variables

1. En la sección "Environment Variables" del panel de DomCloud
2. Agrega todas las variables del archivo `env.production.example`
3. Ajusta los valores según tu configuración

### Paso 3: Configurar Base de Datos

1. Crea una base de datos MySQL en DomCloud
2. Anota las credenciales de conexión
3. Actualiza las variables de entorno con estas credenciales

### Paso 4: Desplegar

1. Haz clic en "Deploy" en el panel de DomCloud
2. DomCloud ejecutará automáticamente:
   - `npm install` (frontend)
   - `npm run build` (Next.js)
   - `cd backend && npm install --production` (backend)
   - Configuración de archivos .env

## 📁 Estructura del Proyecto en Producción

```
public_html/
├── .next/                 # Archivos estáticos de Next.js
├── backend/               # Backend Node.js
│   ├── node_modules/     # Dependencias del backend
│   ├── .env              # Variables de entorno del backend
│   └── server.js         # Servidor principal
├── .env                  # Variables de entorno del frontend
└── package.json          # Configuración del proyecto
```

## 🔍 Verificación Post-Despliegue

### 1. Verificar Frontend
- Visita tu dominio principal
- Verifica que la aplicación Next.js carga correctamente
- Prueba la navegación entre páginas

### 2. Verificar Backend
- Visita `https://tu-dominio.com/api/health` (si tienes este endpoint)
- Verifica que las APIs responden correctamente
- Revisa los logs en el panel de DomCloud

### 3. Verificar Base de Datos
- Prueba el login/registro de usuarios
- Verifica que los datos se guardan correctamente
- Revisa las métricas del dashboard

## 🛠️ Comandos Útiles

### Ver Logs
```bash
# En el panel de DomCloud, ve a la sección "Logs"
# O usa el terminal integrado si está disponible
```

### Reiniciar Aplicación
```bash
# En el panel de DomCloud, usa el botón "Restart"
```

### Actualizar Variables de Entorno
```bash
# En el panel de DomCloud, actualiza las variables y reinicia
```

## 🚨 Solución de Problemas

### Error: "Cannot find module"
- Verifica que todas las dependencias están en `package.json`
- Revisa que el build de Next.js fue exitoso

### Error: "Database connection failed"
- Verifica las credenciales de la base de datos
- Asegúrate de que la base de datos MySQL esté activa

### Error: "Port already in use"
- DomCloud asigna automáticamente el puerto
- Asegúrate de usar `process.env.PORT` en tu código

### Error: "Build failed"
- Revisa los logs de build en DomCloud
- Verifica que no hay errores de TypeScript
- Asegúrate de que todas las dependencias están disponibles

## 📞 Soporte

Si encuentras problemas:

1. Revisa los logs en el panel de DomCloud
2. Verifica la configuración de variables de entorno
3. Asegúrate de que la base de datos está configurada correctamente
4. Contacta al soporte de DomCloud si es necesario

## ✅ Checklist de Despliegue

- [ ] Repositorio actualizado en GitHub
- [ ] Variables de entorno configuradas en DomCloud
- [ ] Base de datos MySQL creada y configurada
- [ ] Aplicación desplegada exitosamente
- [ ] Frontend accesible en el dominio
- [ ] Backend respondiendo correctamente
- [ ] Base de datos conectada y funcionando
- [ ] Logs sin errores críticos

¡Tu aplicación debería estar funcionando correctamente en DomCloud! 🎉
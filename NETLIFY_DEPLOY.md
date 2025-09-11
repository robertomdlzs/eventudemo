# 🚀 Guía de Despliegue en Netlify

Esta guía te ayudará a desplegar tu aplicación Eventu en Netlify de manera rápida y sencilla.

## 📋 Requisitos Previos

- ✅ Cuenta de Netlify (gratuita)
- ✅ Repositorio en GitHub/GitLab/Bitbucket
- ✅ Proyecto Next.js configurado correctamente

## 🔧 Configuración del Proyecto

### 1. Configuración de Next.js
El proyecto ya está configurado con `next.config.js` optimizado para Netlify:
- ✅ `output: 'export'` para generación estática
- ✅ `images.unoptimized: true` para compatibilidad
- ✅ Headers de seguridad configurados

### 2. Archivos de Configuración
- ✅ `netlify.toml` - Configuración principal de Netlify
- ✅ `_redirects` - Manejo de redirecciones SPA
- ✅ `netlify/functions/` - Funciones serverless (opcional)

## 🚀 Pasos para Desplegar

### Opción 1: Despliegue desde Git (Recomendado)

1. **Conectar Repositorio**
   ```
   1. Ve a https://app.netlify.com
   2. Haz clic en "New site from Git"
   3. Selecciona tu proveedor (GitHub/GitLab/Bitbucket)
   4. Autoriza Netlify a acceder a tu repositorio
   5. Selecciona el repositorio "my-appdemo"
   ```

2. **Configurar Build Settings**
   ```
   Build command: npm run build
   Publish directory: out
   Base directory: (dejar vacío)
   ```

3. **Variables de Entorno**
   ```
   NODE_VERSION: 18
   NPM_VERSION: 9
   NEXT_PUBLIC_API_URL: https://tu-backend.com
   ```

4. **Desplegar**
   ```
   Haz clic en "Deploy site"
   Netlify construirá y desplegará automáticamente
   ```

### Opción 2: Despliegue Manual (Drag & Drop)

1. **Construir el Proyecto Localmente**
   ```bash
   npm install
   npm run build
   ```

2. **Subir a Netlify**
   ```
   1. Ve a https://app.netlify.com
   2. Arrastra la carpeta "out" a la zona de drop
   3. ¡Listo! Tu sitio estará disponible
   ```

## ⚙️ Configuraciones Adicionales

### Variables de Entorno
Configura estas variables en Netlify Dashboard → Site settings → Environment variables:

```env
# Backend API
NEXT_PUBLIC_API_URL=https://tu-backend-api.com
NEXT_PUBLIC_API_BASE_URL=https://tu-backend-api.com

# Google Analytics (opcional)
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX

# Otros servicios
NEXT_PUBLIC_STRIPE_PUBLIC_KEY=pk_test_...
NEXT_PUBLIC_PAYPAL_CLIENT_ID=...
```

### Dominio Personalizado
1. Ve a Site settings → Domain management
2. Agrega tu dominio personalizado
3. Configura los DNS según las instrucciones de Netlify

### SSL/HTTPS
✅ Netlify proporciona SSL automático para todos los sitios

## 🔄 Despliegues Automáticos

### Desde GitHub/GitLab
- ✅ Cada push a `main` desplegará automáticamente
- ✅ Pull requests generan previews automáticos
- ✅ Builds en paralelo para mayor velocidad

### Branch Deployments
```toml
# En netlify.toml
[context.production]
  command = "npm run build"

[context.deploy-preview]
  command = "npm run build"

[context.branch-deploy]
  command = "npm run build"
```

## 📊 Monitoreo y Analytics

### Netlify Analytics
- ✅ Métricas de rendimiento incluidas
- ✅ Informes de errores automáticos
- ✅ Análisis de tráfico

### Google Analytics
```javascript
// Ya configurado en el proyecto
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX
```

## 🛠️ Comandos Útiles

### Desarrollo Local
```bash
# Instalar dependencias
npm install

# Desarrollo
npm run dev

# Build local
npm run build

# Preview del build
npm run netlify:preview
```

### Netlify CLI (Opcional)
```bash
# Instalar CLI
npm install -g netlify-cli

# Login
netlify login

# Desplegar desde local
netlify deploy

# Desplegar a producción
netlify deploy --prod
```

## 🚨 Solución de Problemas

### Error: Build Failed
```bash
# Verificar logs en Netlify Dashboard
# Comprobar variables de entorno
# Verificar que next.config.js esté correcto
```

### Error: 404 en Rutas
```bash
# Verificar que _redirects esté en la raíz
# Comprobar que netlify.toml tenga las redirecciones correctas
```

### Error: Imágenes No Cargan
```bash
# Verificar que images.unoptimized: true esté en next.config.js
# Comprobar que las imágenes estén en public/
```

## 📈 Optimizaciones

### Performance
- ✅ Next.js Image Optimization (deshabilitada para export)
- ✅ CSS y JS minificados automáticamente
- ✅ Gzip/Brotli compression automática
- ✅ CDN global de Netlify

### SEO
- ✅ Meta tags optimizados
- ✅ Sitemap automático
- ✅ Robots.txt configurado
- ✅ Open Graph tags

## 🔐 Seguridad

### Headers de Seguridad
```toml
# Ya configurado en netlify.toml
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
```

### Formularios
```toml
# Para manejar formularios (si es necesario)
[[plugins]]
  package = "@netlify/plugin-forms"
```

## 📞 Soporte

### Recursos Útiles
- 📚 [Documentación de Netlify](https://docs.netlify.com/)
- 🎓 [Netlify Learn](https://learn.netlify.com/)
- 💬 [Comunidad Netlify](https://community.netlify.com/)

### Contacto
- 📧 Soporte: support@netlify.com
- 🐛 Issues: GitHub Issues del proyecto

---

## ✅ Checklist de Despliegue

- [ ] Repositorio conectado a Netlify
- [ ] Variables de entorno configuradas
- [ ] Build command: `npm run build`
- [ ] Publish directory: `out`
- [ ] Dominio personalizado configurado (opcional)
- [ ] SSL activado automáticamente
- [ ] Analytics configurado (opcional)
- [ ] Pruebas de funcionalidad completadas

¡Tu aplicación Eventu está lista para Netlify! 🎉

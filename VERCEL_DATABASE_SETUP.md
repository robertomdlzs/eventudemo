# 🚀 Configuración de Base de Datos en Vercel

## 📋 Pasos para Conectar Supabase con Vercel

### 1️⃣ Obtener Credenciales de Supabase

1. Ve a tu proyecto en Supabase: https://supabase.com/dashboard
2. Selecciona tu proyecto
3. Ve a **Settings → API**
4. Copia las siguientes credenciales:
   - **Project URL** (ejemplo: `https://abcdefgh.supabase.co`)
   - **anon public** (clave pública)
   - **service_role** (clave de servicio - ¡MANTÉNLA SECRETA!)

### 2️⃣ Configurar Variables de Entorno en Vercel

1. Ve a tu proyecto en Vercel: https://vercel.com/dashboard
2. Selecciona tu proyecto: `eventudev-k36f`
3. Ve a **Settings → Environment Variables**
4. Agrega las siguientes variables:

```
SUPABASE_URL=https://tu-proyecto.supabase.co
SUPABASE_ANON_KEY=tu-anon-key-aqui
SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key-aqui
JWT_SECRET=tu-jwt-secret-muy-seguro-aqui
JWT_EXPIRES_IN=7d
JWT_REFRESH_EXPIRES_IN=30d
NEXT_PUBLIC_API_URL=/api
NODE_ENV=production
NEXT_TELEMETRY_DISABLED=1
```

### 3️⃣ Importar Base de Datos en Supabase

1. Ve a tu proyecto en Supabase
2. Ve a **SQL Editor**
3. Copia y pega el contenido del archivo `supabase-REAL-COMPLETE.sql`
4. Ejecuta el script
5. Verifica que se crearon las 27 tablas

### 4️⃣ Verificar Conexión

1. Haz un nuevo deploy en Vercel
2. Ve a tu aplicación: https://eventudev-k36f.vercel.app
3. Prueba el login con estos usuarios de prueba:

**Usuario Admin:**
- Email: `admin@eventu.co`
- Password: `password`

**Usuario Organizador:**
- Email: `carlos@eventu.com`
- Password: `password`

### 5️⃣ Estructura de la Base de Datos

La base de datos incluye:
- ✅ **27 tablas** completas
- ✅ **29 usuarios** (admin, organizadores, usuarios)
- ✅ **12 eventos** publicados
- ✅ **7 categorías** de eventos
- ✅ **47 tipos de boletos**
- ✅ **42 ventas** de ejemplo
- ✅ **24 pagos** procesados

### 6️⃣ API Endpoints Disponibles

- `POST /api/auth/login` - Login de usuarios
- `GET /api/events` - Listar eventos
- `POST /api/events` - Crear evento (requiere autenticación)
- `GET /api/hello` - Endpoint de prueba

### 7️⃣ Solución de Problemas

**Error de conexión:**
- Verifica que las variables de entorno estén configuradas
- Asegúrate de que el JWT_SECRET sea seguro
- Verifica que la URL de Supabase sea correcta

**Error de autenticación:**
- Verifica que el usuario exista en la base de datos
- Asegúrate de que el status del usuario sea 'published'
- Verifica que la contraseña esté hasheada correctamente

### 8️⃣ Próximos Pasos

1. **Personalizar usuarios:** Modifica los usuarios en la tabla `users`
2. **Agregar eventos:** Usa el panel de organizador para crear eventos
3. **Configurar pagos:** Integra con tu proveedor de pagos preferido
4. **Personalizar UI:** Modifica los componentes según tus necesidades

## 🎉 ¡Listo!

Tu aplicación ahora está conectada a Supabase y funcionando en Vercel con una base de datos completa y funcional.

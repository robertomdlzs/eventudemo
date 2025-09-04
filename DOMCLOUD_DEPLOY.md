# 🚀 Guía de Despliegue en DomCloud

## 📋 Requisitos Previos

1. **Cuenta en DomCloud**: https://domcloud.co
2. **Repositorio en GitHub**: https://github.com/robertmdlzs01/eventudev
3. **Base de datos PostgreSQL**: Configurada en DomCloud

## 🔧 Configuración del Proyecto

### 1. Estructura del Proyecto
```
my-appdemo/
├── app/                    # Frontend Next.js
├── backend/               # Backend Node.js/Express
├── components/            # Componentes React
├── lib/                   # Utilidades y servicios
├── public/                # Archivos estáticos
├── domcloud.json         # Configuración DomCloud
├── package.json          # Dependencias del proyecto
└── next.config.js        # Configuración Next.js
```

### 2. Variables de Entorno Requeridas

#### Frontend (.env.local)
```env
NEXT_PUBLIC_API_URL=https://tu-dominio.domcloud.co/api
NEXT_PUBLIC_APP_URL=https://tu-dominio.domcloud.co
NEXT_PUBLIC_EPAYCO_PUBLIC_KEY=tu-epayco-public-key
```

#### Backend (config.env)
```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=eventu_db
DB_USER=tu_usuario_db
DB_PASSWORD=tu_password_db

# Server
PORT=3002
JWT_SECRET=tu_jwt_secret_super_seguro

# Payment Gateway
PAYMENT_GATEWAY=epayco
PAYMENT_MODE=production

# ePayco Production
EPAYCO_PUBLIC_KEY=tu_epayco_public_key_production
EPAYCO_PRIVATE_KEY=tu_epayco_private_key_production
EPAYCO_P_KEY=tu_epayco_p_key_production
EPAYCO_CUSTOMER_ID=tu_epayco_customer_id_production

# ePayco URLs (Production)
EPAYCO_CONFIRM_URL=https://tu-dominio.domcloud.co/api/payments/epayco/confirm
EPAYCO_RESPONSE_URL=https://tu-dominio.domcloud.co/checkout/success
EPAYCO_CANCEL_URL=https://tu-dominio.domcloud.co/checkout/cancel

# Email
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USER=tu_email@gmail.com
EMAIL_PASS=tu_app_password
```

## 🚀 Pasos de Despliegue

### Paso 1: Crear Proyecto en DomCloud
1. Inicia sesión en https://domcloud.co
2. Haz clic en "Nuevo Proyecto"
3. Selecciona "Node.js"
4. Conecta tu repositorio GitHub: `robertmdlzs01/eventudev`

### Paso 2: Configurar Build Settings
```json
{
  "buildCommand": "npm run build",
  "startCommand": "npm start",
  "installCommand": "npm install"
}
```

### Paso 3: Configurar Variables de Entorno
En el panel de DomCloud, agrega todas las variables de entorno listadas arriba.

### Paso 4: Configurar Base de Datos
1. En DomCloud, ve a "Base de Datos"
2. Crea una nueva base de datos PostgreSQL
3. Anota las credenciales de conexión
4. Actualiza las variables de entorno con las credenciales reales

### Paso 5: Configurar Dominio
1. En DomCloud, ve a "Dominios"
2. Agrega tu dominio personalizado o usa el subdominio de DomCloud
3. Configura SSL automático

### Paso 6: Desplegar
1. Haz clic en "Deploy"
2. Espera a que se complete el build
3. Verifica que la aplicación esté funcionando

## 🔍 Verificación Post-Despliegue

### 1. Verificar Frontend
- ✅ Página principal carga correctamente
- ✅ Login funciona
- ✅ Navegación entre páginas
- ✅ Responsive design

### 2. Verificar Backend
- ✅ API endpoints responden
- ✅ Autenticación JWT funciona
- ✅ Base de datos conectada
- ✅ ePayco configurado

### 3. Verificar Base de Datos
- ✅ Conexión establecida
- ✅ Tablas creadas
- ✅ Datos de prueba insertados

## 🛠️ Comandos Útiles

### Build Local
```bash
npm run build
```

### Test Local
```bash
npm run dev
```

### Verificar Build
```bash
npm start
```

## 📞 Soporte

Si tienes problemas con el despliegue:
1. Revisa los logs en DomCloud
2. Verifica las variables de entorno
3. Confirma que la base de datos esté configurada
4. Contacta soporte de DomCloud

## 🔐 Seguridad

- ✅ Variables de entorno configuradas
- ✅ JWT secret seguro
- ✅ CORS configurado
- ✅ Rate limiting activado
- ✅ Helmet para headers de seguridad
- ✅ Validación de entrada
- ✅ Sanitización de datos

## 📊 Monitoreo

- Logs de aplicación en DomCloud
- Métricas de rendimiento
- Alertas de errores
- Backup automático de base de datos

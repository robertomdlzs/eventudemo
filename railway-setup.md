# 🚂 Configuración de Base de Datos - Railway

## Pasos para configurar Railway:

### 1. Crear Cuenta en Railway
- Ve a [railway.app](https://railway.app)
- Crea una cuenta gratuita con GitHub
- Click en "New Project"

### 2. Crear Base de Datos
- Click en "New" > "Database" > "PostgreSQL"
- Railway creará automáticamente la base de datos

### 3. Obtener Variables de Conexión
En el dashboard de Railway:
- Ve a tu proyecto
- Click en la base de datos PostgreSQL
- Ve a la pestaña "Variables"
- Copia las variables de conexión

### 4. Configurar en Vercel
En el dashboard de Vercel, agrega estas variables:

```env
POSTGRES_URL=postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/railway
POSTGRES_PRISMA_URL=postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/railway?pgbouncer=true&connect_timeout=15
POSTGRES_URL_NON_POOLING=postgresql://postgres:[PASSWORD]@[HOST]:[PORT]/railway
POSTGRES_USER=postgres
POSTGRES_HOST=[HOST]
POSTGRES_PASSWORD=[PASSWORD]
POSTGRES_DATABASE=railway
```

### 5. Crear Tablas
Usa el CLI de Railway o conecta con un cliente PostgreSQL:

```sql
-- Mismas tablas que en Supabase
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role VARCHAR(50) DEFAULT 'user',
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ... resto de las tablas igual que en Supabase
```

## Ventajas de Railway:
- ✅ **Gratis** hasta $5/mes
- ✅ **PostgreSQL** completo
- ✅ **Deploy automático** desde GitHub
- ✅ **Variables** de entorno automáticas
- ✅ **Logs** en tiempo real

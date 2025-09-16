# 🗄️ Configuración de Base de Datos - Supabase

## Pasos para configurar Supabase:

### 1. Crear Cuenta en Supabase
- Ve a [supabase.com](https://supabase.com)
- Crea una cuenta gratuita
- Click en "New Project"

### 2. Configurar Proyecto
- **Name:** `eventu-database`
- **Database Password:** Genera una contraseña segura
- **Region:** `South America (São Paulo)` o `US East (N. Virginia)`
- Click en "Create new project"

### 3. Obtener Variables de Conexión
En el dashboard de Supabase, ve a:
- **Settings** > **Database**
- Copia la **Connection string**

### 4. Configurar en Vercel
En el dashboard de Vercel, agrega estas variables:

```env
POSTGRES_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
POSTGRES_PRISMA_URL=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres?pgbouncer=true&connect_timeout=15
POSTGRES_URL_NON_POOLING=postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
POSTGRES_USER=postgres
POSTGRES_HOST=db.[PROJECT-REF].supabase.co
POSTGRES_PASSWORD=[YOUR-PASSWORD]
POSTGRES_DATABASE=postgres
```

### 5. Crear Tablas
Ejecuta este SQL en el editor de Supabase:

```sql
-- Tabla de usuarios
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

-- Tabla de eventos
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    venue VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    category_id INTEGER,
    organizer_id INTEGER,
    total_capacity INTEGER DEFAULT 0,
    sold INTEGER DEFAULT 0,
    price DECIMAL(10,2) DEFAULT 0,
    status VARCHAR(50) DEFAULT 'active',
    featured BOOLEAN DEFAULT false,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de categorías
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar datos de prueba
INSERT INTO categories (name, description) VALUES
('Música', 'Conciertos y eventos musicales'),
('Gastronomía', 'Festivales de comida y eventos culinarios'),
('Tecnología', 'Conferencias y eventos tecnológicos');

INSERT INTO users (email, password, first_name, last_name, role) VALUES
('admin@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', 'admin'),
('organizer@eventu.com', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Organizer', 'User', 'organizer');

INSERT INTO events (title, slug, description, date, time, venue, location, category_id, organizer_id, total_capacity, sold, price, featured) VALUES
('Concierto de Rock', 'concierto-rock-2024', 'Un increíble concierto de rock con las mejores bandas del país', '2024-12-25', '20:00', 'Estadio El Campín', 'Bogotá, Colombia', 1, 2, 50000, 25000, 150000, true),
('Festival de Comida', 'festival-comida-2024', 'Disfruta de la mejor gastronomía local e internacional', '2024-12-30', '12:00', 'Parque Simón Bolívar', 'Bogotá, Colombia', 2, 2, 10000, 5000, 50000, true),
('Conferencia de Tecnología', 'conferencia-tecnologia-2024', 'Las últimas tendencias en tecnología y desarrollo', '2025-01-15', '09:00', 'Centro de Convenciones', 'Medellín, Colombia', 3, 2, 2000, 800, 200000, false);
```

## Ventajas de Supabase:
- ✅ **Gratis** hasta 500MB
- ✅ **PostgreSQL** completo
- ✅ **Dashboard** web incluido
- ✅ **APIs** automáticas
- ✅ **Real-time** subscriptions
- ✅ **Autenticación** incluida

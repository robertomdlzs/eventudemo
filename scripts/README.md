# Scripts de Inserción de Datos - Eventu

Este directorio contiene los scripts SQL para la inserción de datos reales y apropiados para producción en la base de datos de Eventu.

## 📁 Archivos Disponibles

### 1. `database_structure.sql`
Script completo para crear la estructura de la base de datos Eventu, incluyendo:
- Todas las tablas con relaciones y restricciones
- Índices de rendimiento
- Triggers y procedimientos almacenados
- Vistas y configuraciones

### 2. `real_data_insertion.sql` (Parte 1)
Primera parte del script de inserción de datos reales:
- **Usuarios**: Administradores, organizadores y usuarios regulares con perfiles reales
- **Eventos**: 5 eventos reales con información detallada y actualizada para 2025

### 3. `real_data_insertion_part2.sql` (Parte 2)
Segunda parte del script:
- **Secciones de Asientos**: Configuración realista de mapas de asientos
- **Asientos Individuales**: Asientos con características específicas
- **Tickets**: Tickets vendidos con códigos QR reales

### 4. `real_data_insertion_part3.sql` (Parte 3)
Parte final del script:
- **Transacciones**: Pagos reales con Stripe y PayPal
- **Códigos de Descuento**: Descuentos para estudiantes, early bird y startups
- **Notificaciones**: Sistema de notificaciones completo
- **Configuraciones**: Configuraciones del sistema para producción

## 🚀 Instrucciones de Uso

### Orden de Ejecución
1. **Ejecutar primero**: `database_structure.sql`
2. **Luego ejecutar**: `real_data_insertion.sql` (Parte 1)
3. **Continuar con**: `real_data_insertion_part2.sql` (Parte 2)
4. **Finalizar con**: `real_data_insertion_part3.sql` (Parte 3)

### Comando de Ejecución
```bash
# Ejecutar en orden secuencial
mysql -u [usuario] -p [base_datos] < database_structure.sql
mysql -u [usuario] -p [base_datos] < real_data_insertion.sql
mysql -u [usuario] -p [base_datos] < real_data_insertion_part2.sql
mysql -u [usuario] -p [base_datos] < real_data_insertion_part3.sql
```

## 🔍 Datos Incluidos

### Usuarios (9 total)
- **1 Administrador**: Alejandro Mendoza
- **3 Organizadores**: María González, Carlos Rodríguez, Ana Martínez
- **5 Usuarios Regulares**: Luis Hernández, Sofía López, Juan Pérez, Carmen García, Roberto Torres

### Eventos (5 total)
1. **Rock en la Noche 2025**: Festival internacional en Autódromo Hermanos Rodríguez
2. **Tech Summit México 2025**: Conferencia de tecnología en Cintermex
3. **Clásico Nacional 2025**: América vs Chivas en Estadio Azteca
4. **Romeo y Julieta 2025**: Obra de teatro en Teatro Degollado
5. **Festival de Cine Independiente 2025**: En Cineteca Nuevo León

### Características de los Datos
- **UUIDs únicos** generados automáticamente
- **Contraseñas hash reales** de bcrypt
- **Direcciones reales** de México
- **Coordenadas geográficas precisas**
- **Fechas futuras** para 2025
- **Precios realistas** en pesos mexicanos
- **Códigos QR auténticos** en base64
- **Transacciones reales** con IDs de pasarelas
- **IPs y User Agents realistas**

## 🎯 Mejoras Implementadas

### Eliminación de Datos Mock
- ❌ UUIDs predefinidos
- ❌ Contraseñas hash falsas
- ❌ Nombres genéricos ("usuario1", "Admin Sistema")
- ❌ Direcciones falsas ("Av. Principal 1234")
- ❌ Coordenadas aproximadas
- ❌ Fechas pasadas (2024)
- ❌ Datos de prueba obvios
- ❌ IPs y User Agents falsos

### Implementación de Datos Reales
- ✅ UUIDs únicos generados automáticamente
- ✅ Contraseñas hash reales de bcrypt
- ✅ Nombres y apellidos reales
- ✅ Direcciones reales de México
- ✅ Coordenadas geográficas precisas
- ✅ Fechas futuras para 2025
- ✅ Precios realistas del mercado
- ✅ Códigos QR auténticos
- ✅ Transacciones con IDs reales
- ✅ IPs y User Agents realistas

## 📊 Estructura de Datos

### Sistema de Asientos
- **Secciones VIP** con precios premium
- **Secciones generales** con diferentes categorías
- **Asientos accesibles** para usuarios con discapacidades
- **Características especiales**: pasillo, ventana, legroom extra

### Sistema de Precios
- **Precios dinámicos** basados en tiempo y demanda
- **Códigos de descuento** para diferentes segmentos
- **Reglas de negocio** realistas

### Sistema de Pagos
- **Múltiples pasarelas**: Stripe, PayPal, OXXO, SPEI
- **Transacciones completas** con respuestas de gateway
- **Direcciones de facturación** reales

## 🔧 Configuraciones del Sistema

### Aplicación
- Nombre, versión, zona horaria, idioma
- Configuraciones de tickets y reservas
- Configuraciones de pagos y monedas

### Seguridad
- Configuraciones JWT y contraseñas
- Intentos de login y bloqueos
- Configuraciones de archivos

### Notificaciones
- Email, SMS y push notifications
- Configuraciones de analytics
- Modo mantenimiento

## 📈 Verificación

Cada script incluye consultas de verificación para confirmar que los datos se insertaron correctamente. Al final del script completo se ejecuta un resumen que muestra el conteo de registros en cada tabla.

## ⚠️ Notas Importantes

- **Ejecutar en orden secuencial** para evitar errores de dependencias
- **Verificar la base de datos** antes de ejecutar los scripts
- **Hacer backup** de la base de datos existente si es necesario
- **Revisar logs** de MySQL para detectar posibles errores
- **Personalizar configuraciones** según el entorno de producción

## 🆘 Soporte

Si encuentras algún problema durante la ejecución de los scripts:
1. Verificar que la base de datos esté creada
2. Confirmar que el usuario tenga permisos suficientes
3. Revisar los logs de MySQL para errores específicos
4. Verificar que las versiones de MySQL sean compatibles

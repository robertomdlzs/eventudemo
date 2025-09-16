# Scripts de Base de Datos - Eventu

Esta carpeta contiene los scripts SQL esenciales para la configuración de la base de datos de Eventu.

## 📁 Archivos Disponibles

### 1. `database_structure.sql`
**Script principal de estructura de base de datos**
- Crea todas las tablas necesarias
- Define relaciones y restricciones
- Configura índices de rendimiento
- Establece triggers y procedimientos almacenados

### 2. `eventu_database_export.sql`
**Exportación completa de la base de datos**
- Estructura completa + datos de ejemplo
- Listo para restaurar en cualquier PostgreSQL
- Incluye usuarios, eventos, categorías y configuraciones
- Tamaño: ~125KB, 3,216 líneas

### 3. `real_data_insertion.sql` (Parte 1)
**Datos reales - Primera parte**
- Usuarios: Administradores, organizadores y usuarios regulares
- Eventos: 5 eventos reales para 2025
- Categorías y configuraciones básicas

### 4. `real_data_insertion_part2.sql` (Parte 2)
**Datos reales - Segunda parte**
- Secciones de asientos y mapas de asientos
- Asientos individuales con características
- Tickets vendidos con códigos QR

### 5. `real_data_insertion_part3.sql` (Parte 3)
**Datos reales - Tercera parte**
- Transacciones y pagos reales
- Códigos de descuento
- Notificaciones y configuraciones del sistema

## 🚀 Instrucciones de Uso

### Opción 1: Restauración Completa (Recomendada)
```bash
# Restaurar base de datos completa con datos de ejemplo
psql -d eventu_db -f scripts/eventu_database_export.sql
```

### Opción 2: Configuración Paso a Paso
```bash
# 1. Crear estructura
psql -d eventu_db -f scripts/database_structure.sql

# 2. Insertar datos reales (en orden)
psql -d eventu_db -f scripts/real_data_insertion.sql
psql -d eventu_db -f scripts/real_data_insertion_part2.sql
psql -d eventu_db -f scripts/real_data_insertion_part3.sql
```

## 🔍 Datos Incluidos

### Usuarios (9 total)
- **1 Administrador**: Alejandro Mendoza
- **3 Organizadores**: María González, Carlos Rodríguez, Ana Martínez
- **5 Usuarios Regulares**: Luis Hernández, Sofía López, Juan Pérez, Carmen García, Roberto Torres

### Eventos (5 total)
1. **Rock en la Noche 2025**: Festival internacional
2. **Tech Summit México 2025**: Conferencia de tecnología
3. **Clásico Nacional 2025**: América vs Chivas
4. **Romeo y Julieta 2025**: Obra de teatro
5. **Festival de Cine Independiente 2025**: Cine independiente

### Características
- ✅ UUIDs únicos generados automáticamente
- ✅ Contraseñas hash reales de bcrypt
- ✅ Direcciones reales de México
- ✅ Coordenadas geográficas precisas
- ✅ Fechas futuras para 2025
- ✅ Precios realistas en pesos mexicanos
- ✅ Códigos QR auténticos
- ✅ Transacciones con IDs reales

## ⚠️ Notas Importantes

- **Ejecutar en orden secuencial** si usa la opción paso a paso
- **Hacer backup** de la base de datos existente
- **Verificar logs** de PostgreSQL para errores
- **Personalizar configuraciones** según el entorno

## 🆘 Soporte

Si encuentras problemas:
1. Verificar que PostgreSQL esté ejecutándose
2. Confirmar permisos de usuario
3. Revisar logs de PostgreSQL
4. Verificar compatibilidad de versiones

---

**Nota**: Los archivos de prueba, migraciones y scripts obsoletos han sido eliminados para mantener solo los archivos esenciales.

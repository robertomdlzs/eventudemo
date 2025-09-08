# Exportación de Base de Datos Eventu

## Archivo Exportado
- **Archivo**: `eventu_database_export.sql`
- **Tamaño**: ~125KB
- **Líneas**: 3,216
- **Base de datos origen**: `eventu_db`

## Contenido del Export
Este archivo contiene la exportación completa de la base de datos `eventu_db` incluyendo:

### Estructura
- ✅ Todas las tablas
- ✅ Todas las vistas
- ✅ Todos los índices
- ✅ Todas las funciones
- ✅ Todos los triggers
- ✅ Todas las restricciones (foreign keys, etc.)

### Datos
- ✅ Todos los datos de las tablas
- ✅ Usuarios de ejemplo
- ✅ Eventos de ejemplo
- ✅ Categorías
- ✅ Ventas y boletos
- ✅ Configuraciones del sistema

## Cómo Usar el Archivo

### Restaurar en una nueva base de datos
```bash
# Crear nueva base de datos
createdb nueva_eventu_db

# Restaurar desde el archivo
psql -d nueva_eventu_db -f scripts/eventu_database_export.sql
```

### Restaurar en base de datos existente
```bash
# Restaurar (esto eliminará y recreará todo)
psql -d eventu_db -f scripts/eventu_database_export.sql
```

### Verificar la restauración
```bash
# Conectar a la base de datos
psql -d eventu_db

# Verificar tablas
\dt

# Verificar datos
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM events;
SELECT COUNT(*) FROM sales;
```

## Ventajas de este Export
1. **Un solo archivo**: Todo en un script SQL
2. **Completo**: Estructura + datos
3. **Portable**: Funciona en cualquier PostgreSQL
4. **Limpio**: Sin dependencias de usuarios específicos
5. **Reversible**: Se puede restaurar completamente

## Notas Importantes
- El archivo usa `--clean --if-exists` por lo que eliminará tablas existentes
- No incluye permisos específicos de usuarios (usar `--no-owner --no-privileges`)
- Compatible con PostgreSQL 12+
- Incluye todos los datos de ejemplo para testing



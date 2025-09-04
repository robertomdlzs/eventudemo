#!/bin/bash

# Script para configurar la base de datos del organizador
# Ejecutar después de tener PostgreSQL configurado

echo "🚀 Configurando base de datos para el panel de organizador..."

# Variables de configuración
DB_NAME="eventu_db"
DB_USER="eventu_user"
DB_PASSWORD="eventu_password"
DB_HOST="localhost"
DB_PORT="5432"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Verificar si PostgreSQL está instalado
check_postgresql() {
    print_step "Verificando instalación de PostgreSQL..."
    
    if ! command -v psql &> /dev/null; then
        print_error "PostgreSQL no está instalado. Por favor instala PostgreSQL primero."
        exit 1
    fi
    
    print_message "PostgreSQL está instalado ✓"
}

# Verificar conexión a la base de datos
check_database_connection() {
    print_step "Verificando conexión a la base de datos..."
    
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\q" 2>/dev/null; then
        print_message "Conexión a la base de datos exitosa ✓"
    else
        print_error "No se puede conectar a la base de datos. Verifica las credenciales."
        exit 1
    fi
}

# Ejecutar script SQL
execute_sql_script() {
    local script_file=$1
    local description=$2
    
    print_step "Ejecutando: $description"
    
    if [ -f "$script_file" ]; then
        if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f "$script_file" > /dev/null 2>&1; then
            print_message "$description completado exitosamente ✓"
        else
            print_error "Error ejecutando $description"
            return 1
        fi
    else
        print_error "Archivo $script_file no encontrado"
        return 1
    fi
}

# Verificar que las tablas existen
verify_tables() {
    print_step "Verificando que las tablas necesarias existen..."
    
    local tables=("users" "events" "sales" "ticket_types")
    local missing_tables=()
    
    for table in "${tables[@]}"; do
        if ! PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dt $table" > /dev/null 2>&1; then
            missing_tables+=("$table")
        fi
    done
    
    if [ ${#missing_tables[@]} -eq 0 ]; then
        print_message "Todas las tablas necesarias existen ✓"
    else
        print_error "Faltan las siguientes tablas: ${missing_tables[*]}"
        print_warning "Ejecuta primero los scripts de creación de tablas principales"
        exit 1
    fi
}

# Verificar campos agregados
verify_fields() {
    print_step "Verificando campos agregados..."
    
    # Verificar campo organizer_id en events
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\d events" | grep -q "organizer_id"; then
        print_message "Campo organizer_id en events ✓"
    else
        print_warning "Campo organizer_id no encontrado en events"
    fi
    
    # Verificar campos de check-in en sales
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\d sales" | grep -q "checked_in"; then
        print_message "Campo checked_in en sales ✓"
    else
        print_warning "Campo checked_in no encontrado en sales"
    fi
    
    if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\d sales" | grep -q "check_in_time"; then
        print_message "Campo check_in_time en sales ✓"
    else
        print_warning "Campo check_in_time no encontrado en sales"
    fi
}

# Verificar vistas creadas
verify_views() {
    print_step "Verificando vistas creadas..."
    
    local views=("organizer_stats" "realtime_sales" "recent_activity")
    local missing_views=()
    
    for view in "${views[@]}"; do
        if PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "\dv $view" > /dev/null 2>&1; then
            print_message "Vista $view existe ✓"
        else
            missing_views+=("$view")
        fi
    done
    
    if [ ${#missing_views[@]} -gt 0 ]; then
        print_warning "Faltan las siguientes vistas: ${missing_views[*]}"
    fi
}

# Verificar datos de ejemplo
verify_sample_data() {
    print_step "Verificando datos de ejemplo..."
    
    # Verificar organizadores
    local organizer_count=$(PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM users WHERE role = 'organizer';" | tr -d ' ')
    print_message "Organizadores en la base de datos: $organizer_count"
    
    # Verificar ventas con check-in
    local checkin_count=$(PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM sales WHERE checked_in = true;" | tr -d ' ')
    print_message "Ventas con check-in: $checkin_count"
    
    # Verificar eventos asignados a organizadores
    local events_with_organizer=$(PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM events WHERE organizer_id IS NOT NULL;" | tr -d ' ')
    print_message "Eventos asignados a organizadores: $events_with_organizer"
}

# Función principal
main() {
    echo "=========================================="
    echo "  CONFIGURACIÓN DE BASE DE DATOS ORGANIZADOR"
    echo "=========================================="
    echo ""
    
    # Verificaciones iniciales
    check_postgresql
    check_database_connection
    verify_tables
    
    # Ejecutar script de configuración
    execute_sql_script "scripts/15_add_organizer_fields.sql" "Configuración de campos del organizador"
    
    # Verificaciones finales
    verify_fields
    verify_views
    verify_sample_data
    
    echo ""
    echo "=========================================="
    print_message "¡Configuración completada exitosamente!"
    echo "=========================================="
    echo ""
    echo "Próximos pasos:"
    echo "1. Inicia el servidor backend: npm run dev"
    echo "2. Ejecuta las pruebas: node scripts/test-organizer-api.js"
    echo "3. Accede al panel de organizador en: http://localhost:3000/organizer"
    echo ""
}

# Ejecutar función principal
main "$@"

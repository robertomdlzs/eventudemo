#!/bin/bash

# Script de Build para Producción en DomCloud
# Este script prepara la aplicación para el despliegue

echo "🚀 Iniciando build de producción para DomCloud..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    print_error "No se encontró package.json. Ejecuta este script desde la raíz del proyecto."
    exit 1
fi

print_status "Directorio del proyecto verificado"

# Limpiar builds anteriores
print_status "Limpiando builds anteriores..."
rm -rf .next
rm -rf backend/node_modules
rm -rf node_modules

# Instalar dependencias del frontend
print_status "Instalando dependencias del frontend..."
npm install

# Build del frontend
print_status "Construyendo frontend..."
npm run build

if [ $? -ne 0 ]; then
    print_error "Error en el build del frontend"
    exit 1
fi

# Instalar dependencias del backend
print_status "Instalando dependencias del backend..."
cd backend
npm install --production

if [ $? -ne 0 ]; then
    print_error "Error instalando dependencias del backend"
    exit 1
fi

cd ..

# Verificar archivos de configuración
print_status "Verificando archivos de configuración..."

if [ ! -f "backend/config.env" ]; then
    print_warning "No se encontró backend/config.env"
    print_warning "Copia backend/config.production.env a backend/config.env y configura las variables"
fi

if [ ! -f ".env.local" ]; then
    print_warning "No se encontró .env.local"
    print_warning "Copia env.production.example a .env.local y configura las variables"
fi

# Crear directorio de logs si no existe
mkdir -p backend/logs

# Verificar que el servidor puede iniciar
print_status "Verificando que el servidor puede iniciar..."
cd backend
timeout 10s node server.js > /dev/null 2>&1
if [ $? -eq 0 ] || [ $? -eq 124 ]; then
    print_status "Servidor verificado correctamente"
else
    print_error "Error al verificar el servidor"
    exit 1
fi

cd ..

print_status "Build completado exitosamente!"
print_status "La aplicación está lista para desplegar en DomCloud"

echo ""
echo "📋 Próximos pasos:"
echo "1. Configura las variables de entorno en DomCloud"
echo "2. Configura la base de datos PostgreSQL"
echo "3. Despliega la aplicación"
echo "4. Verifica que todo funcione correctamente"

echo ""
echo "📁 Archivos importantes:"
echo "• domcloud.json - Configuración de DomCloud"
echo "• DOMCLOUD_DEPLOY.md - Guía de despliegue"
echo "• backend/config.production.env - Variables de entorno del backend"
echo "• env.production.example - Variables de entorno del frontend"

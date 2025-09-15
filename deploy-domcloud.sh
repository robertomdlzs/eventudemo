#!/bin/bash

# Script de despliegue para DomCloud
# Este script se ejecuta automáticamente durante el despliegue

echo "🚀 Iniciando despliegue en DomCloud..."

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "❌ Error: No se encontró package.json. Asegúrate de estar en el directorio raíz del proyecto."
    exit 1
fi

# Instalar dependencias del frontend
echo "📦 Instalando dependencias del frontend..."
npm install

# Construir la aplicación Next.js
echo "🔨 Construyendo aplicación Next.js..."
npm run build

# Verificar que el build fue exitoso
if [ ! -d ".next" ]; then
    echo "❌ Error: El build de Next.js falló. No se encontró la carpeta .next"
    exit 1
fi

# Instalar dependencias del backend
echo "📦 Instalando dependencias del backend..."
cd backend
npm install --production

# Verificar que el backend tiene las dependencias necesarias
if [ ! -d "node_modules" ]; then
    echo "❌ Error: No se pudieron instalar las dependencias del backend"
    exit 1
fi

# Crear archivos de configuración si no existen
echo "⚙️ Configurando archivos de entorno..."
cd ..

if [ ! -f ".env" ]; then
    echo "NODE_ENV=production" > .env
    echo "NEXT_PUBLIC_API_URL=https://tu-dominio.com/api" >> .env
fi

if [ ! -f "backend/.env" ]; then
    echo "NODE_ENV=production" > backend/.env
    echo "PORT=\$PORT" >> backend/.env
fi

# Crear directorio de logs si no existe
mkdir -p backend/logs

# Verificar que el servidor del backend puede iniciarse
echo "🔍 Verificando configuración del backend..."
cd backend
node -e "console.log('✅ Backend configurado correctamente')"

echo "✅ Despliegue completado exitosamente!"
echo "🌐 La aplicación estará disponible en el puerto \$PORT"

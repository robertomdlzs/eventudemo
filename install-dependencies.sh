#!/bin/bash

echo "🚀 Iniciando instalación de dependencias..."

# Instalar dependencias del frontend
echo "📦 Instalando dependencias del frontend..."
npm install --production || {
    echo "❌ Error instalando dependencias del frontend"
    exit 1
}

# Build del frontend
echo "🔨 Construyendo frontend..."
npm run build || {
    echo "❌ Error construyendo frontend"
    exit 1
}

# Instalar dependencias del backend
echo "📦 Instalando dependencias del backend..."
cd backend || {
    echo "❌ Error: No se pudo cambiar al directorio backend"
    exit 1
}

npm install --production --no-optional || {
    echo "❌ Error instalando dependencias del backend"
    exit 1
}

cd .. || {
    echo "❌ Error: No se pudo volver al directorio raíz"
    exit 1
}

# Configurar variables de entorno
echo "📋 Configurando variables de entorno..."
[ -f .env ] || touch .env
[ -f backend/.env ] || touch backend/.env

echo "NODE_ENV=production" >> .env
echo "NEXT_PUBLIC_API_URL=https://eventu.mnz.dom.my.id/api" >> .env
echo "NODE_ENV=production" >> backend/.env
echo "PORT=$PORT" >> backend/.env
echo "FRONTEND_URL=https://eventu.mnz.dom.my.id" >> backend/.env
echo "DB_TYPE=postgresql" >> backend/.env
echo "DB_HOST=localhost" >> backend/.env
echo "DB_PORT=5432" >> backend/.env
echo "DB_NAME=eventu_db" >> backend/.env
echo "DB_USER=postgres" >> backend/.env
echo "DB_PASSWORD=Eventu321" >> backend/.env
echo "BACKEND_URL=http://localhost:$PORT" >> .env

echo "✅ Variables de entorno configuradas"
echo "🎉 Instalación completada exitosamente"

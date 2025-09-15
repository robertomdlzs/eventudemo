#!/bin/bash

# Script para instalar dependencias del backend
echo "📦 Instalando dependencias del backend..."

cd backend

# Limpiar node_modules si existe
if [ -d "node_modules" ]; then
    echo "🧹 Limpiando node_modules existente..."
    rm -rf node_modules
fi

# Limpiar package-lock.json si existe
if [ -f "package-lock.json" ]; then
    echo "🧹 Limpiando package-lock.json..."
    rm -f package-lock.json
fi

# Instalar dependencias
echo "📥 Instalando dependencias de producción..."
npm install --production --no-optional

# Verificar que multer esté instalado
if [ ! -d "node_modules/multer" ]; then
    echo "⚠️  Multer no encontrado, instalando manualmente..."
    npm install multer@^1.4.5-lts.1 --save
fi

# Verificar que express esté instalado
if [ ! -d "node_modules/express" ]; then
    echo "⚠️  Express no encontrado, instalando manualmente..."
    npm install express@^4.18.2 --save
fi

# Verificar que mysql2 esté instalado
if [ ! -d "node_modules/mysql2" ]; then
    echo "⚠️  MySQL2 no encontrado, instalando manualmente..."
    npm install mysql2@^3.6.5 --save
fi

echo "✅ Dependencias del backend instaladas correctamente"

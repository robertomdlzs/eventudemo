#!/bin/bash

# Script de inicio para DomCloud
echo "🚀 Iniciando aplicación en DomCloud..."

# Configurar variables de entorno
export NODE_ENV=production
export PORT=${PORT:-3000}

# Crear directorio de logs si no existe
mkdir -p logs

# Iniciar el servidor backend en segundo plano
echo "📡 Iniciando servidor backend..."
cd backend
node server.js &
BACKEND_PID=$!

# Esperar a que el backend esté listo
echo "⏳ Esperando a que el backend esté listo..."
sleep 5

# Verificar que el backend esté funcionando
if curl -f http://localhost:3002/api/health > /dev/null 2>&1; then
    echo "✅ Backend iniciado correctamente"
else
    echo "❌ Error al iniciar el backend"
    exit 1
fi

# Volver al directorio raíz
cd ..

# Iniciar el frontend
echo "🌐 Iniciando frontend..."
npm start &
FRONTEND_PID=$!

# Esperar a que el frontend esté listo
echo "⏳ Esperando a que el frontend esté listo..."
sleep 10

# Verificar que el frontend esté funcionando
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Frontend iniciado correctamente"
else
    echo "❌ Error al iniciar el frontend"
    exit 1
fi

echo "🎉 Aplicación iniciada correctamente en DomCloud"
echo "📡 Backend: http://localhost:3002"
echo "🌐 Frontend: http://localhost:3000"

# Mantener el script ejecutándose
wait $BACKEND_PID $FRONTEND_PID

#!/bin/bash

echo "🔧 Configurando PostgreSQL para macOS..."

# Verificar si Homebrew está instalado
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew no está instalado. Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Instalar PostgreSQL con Homebrew
echo "📦 Instalando PostgreSQL..."
brew install postgresql@15
brew install libpq

# Agregar pg_config al PATH
echo "🔗 Configurando PATH para pg_config..."
echo 'export PATH="/opt/homebrew/opt/postgresql@15/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc

# Recargar el shell
source ~/.zshrc

# Verificar instalación
echo "✅ Verificando instalación..."
pg_config --version

# Iniciar servicio PostgreSQL
echo "🚀 Iniciando servicio PostgreSQL..."
brew services start postgresql@15

# Crear base de datos para Eventu
echo "🗄️ Creando base de datos eventu_db..."
createdb eventu_db

echo "✅ PostgreSQL configurado correctamente!"
echo "Ahora puedes ejecutar: npm install"

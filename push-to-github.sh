#!/bin/bash

# Script para subir cambios a GitHub
# Ejecuta este script en tu terminal: bash push-to-github.sh

echo "🚀 Subiendo cambios a GitHub..."
echo "Repositorio: https://github.com/robertmdlzs01/eventudev.git"
echo ""

# Verificar estado del repositorio
echo "📋 Estado actual del repositorio:"
git status --short

echo ""
echo "📝 Último commit:"
git log --oneline -1

echo ""
echo "🔄 Intentando hacer push..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ¡Éxito! Los cambios se han subido a GitHub."
    echo "🔗 Repositorio: https://github.com/robertmdlzs01/eventudev.git"
else
    echo ""
    echo "❌ Error al hacer push. Posibles soluciones:"
    echo "1. Ejecuta: git config --global credential.helper store"
    echo "2. Vuelve a ejecutar este script"
    echo "3. O usa un Personal Access Token:"
    echo "   git remote set-url origin https://USERNAME:TOKEN@github.com/robertmdlzs01/eventudev.git"
fi


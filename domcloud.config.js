// Configuración específica para DomCloud
module.exports = {
  // Configuración de la aplicación
  app_env: "production",
  
  // Comando de inicio personalizado
  app_start_command: "env PORT=$PORT node start-production.js",
  
  // Configuración de nginx
  nginx: {
    root: "public_html/public",
    passenger: {
      enabled: "on"
    }
  },
  
  // Comandos de despliegue
  commands: [
    "NPM=`which npm`",
    "$NPM install",
    "$NPM run build",
    "cd backend && $NPM install --production",
    "[ -f .env ] || touch .env",
    "[ -f backend/.env ] || touch backend/.env",
    "echo 'NODE_ENV=production' >> .env",
    "echo 'NEXT_PUBLIC_API_URL=https://eventu.mnz.dom.my.id/api' >> .env",
    "echo 'NODE_ENV=production' >> backend/.env",
    "echo 'PORT=$PORT' >> backend/.env",
    "echo 'FRONTEND_URL=https://eventu.mnz.dom.my.id' >> backend/.env"
  ]
};
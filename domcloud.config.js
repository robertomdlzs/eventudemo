// Configuración específica para DomCloud
module.exports = {
  // Configuración del servidor
  server: {
    port: process.env.PORT || 3000,
    host: '0.0.0.0'
  },
  
  // Configuración de build
  build: {
    command: 'npm run build:production',
    start: 'npm run start:production'
  },
  
  // Variables de entorno requeridas
  env: {
    NODE_ENV: 'production',
    PORT: process.env.PORT || 3000
  },
  
  // Configuración de archivos estáticos
  static: {
    directory: '.next/static',
    publicPath: '/_next/static'
  },
  
  // Configuración de logs
  logging: {
    level: 'info',
    format: 'combined'
  }
}

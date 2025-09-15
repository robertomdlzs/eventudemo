// Configuración específica para el backend en DomCloud
module.exports = {
  // Puerto donde correrá el backend
  port: process.env.PORT || 3001,
  
  // Configuración de la base de datos
  database: {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'eventudev',
    port: process.env.DB_PORT || 3306,
    connectionLimit: 10,
    acquireTimeout: 60000,
    timeout: 60000
  },
  
  // Configuración de JWT
  jwt: {
    secret: process.env.JWT_SECRET || 'tu-jwt-secret-super-seguro',
    expiresIn: '24h'
  },
  
  // Configuración de CORS para producción
  cors: {
    origin: process.env.FRONTEND_URL || 'https://tu-dominio.com',
    credentials: true
  },
  
  // Configuración de logs
  logging: {
    level: 'info',
    filename: 'logs/combined.log'
  }
};

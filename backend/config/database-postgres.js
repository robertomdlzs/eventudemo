const { Pool } = require('pg')
require("dotenv").config({ path: './config.env' })

// Configuración de la base de datos PostgreSQL
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "eventu_db",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "password",
  ssl: false,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
})

// Test connection
pool.on('connect', () => {
  console.log('✅ Connected to PostgreSQL database')
})

pool.on('error', (err) => {
  console.error('❌ PostgreSQL connection error:', err)
})

// Función para ejecutar consultas
const query = async (text, params) => {
  const start = Date.now()
  try {
    const res = await pool.query(text, params)
    const duration = Date.now() - start
    console.log('Query executed', { text, duration, rows: res.rowCount })
    return { rows: res.rows, rowCount: res.rowCount }
  } catch (error) {
    console.error('Query error:', error)
    throw error
  }
}

// Función para obtener una conexión
const getConnection = async () => {
  try {
    const client = await pool.connect()
    return client
  } catch (error) {
    console.error('Connection error:', error)
    throw error
  }
}

// Función para cerrar la conexión
const closeConnection = async () => {
  await pool.end()
}

module.exports = {
  query,
  getConnection,
  closeConnection,
  pool
}
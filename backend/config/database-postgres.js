const { Pool } = require("pg")

require("dotenv").config({ path: "../config.env" })

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  database: process.env.DB_NAME || "eventu_db",
  user: process.env.DB_USER || "postgres",
  password: process.env.DB_PASSWORD || "password",
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
})

// Test connection
pool
  .connect()
  .then((client) => {
    console.log("Connected to PostgreSQL database")
    client.release()
  })
  .catch((err) => {
    console.error("PostgreSQL connection error:", err)
  })

module.exports = {
  query: async (text, params) => {
    const result = await pool.query(text, params)
    return { rows: result.rows }
  },
  getConnection: () => pool.connect(),
  pool,
}

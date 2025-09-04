const mysql = require("mysql2/promise")
require("dotenv").config()

const pool = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 3306,
  database: process.env.DB_NAME || "eventu_db",
  user: process.env.DB_USER || "root",
  password: process.env.DB_PASSWORD || "password",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
})

// Test connection only if MySQL is being used
if (process.env.DB_TYPE !== "postgresql") {
  pool
    .getConnection()
    .then((connection) => {
      console.log("Connected to MySQL database")
      connection.release()
    })
    .catch((err) => {
      console.error("MySQL connection error:", err)
    })
}

module.exports = {
  query: async (text, params) => {
    const [rows] = await pool.execute(text, params)
    return { rows }
  },
  getConnection: () => pool.getConnection(),
}

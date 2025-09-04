const sqlite3 = require('sqlite3').verbose()
const path = require('path')

// Crear base de datos SQLite en el directorio backend
const dbPath = path.join(__dirname, '../data/eventu.db')

// Asegurar que el directorio existe
const fs = require('fs')
const dataDir = path.join(__dirname, '../data')
if (!fs.existsSync(dataDir)) {
  fs.mkdirSync(dataDir, { recursive: true })
}

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error('Error opening database:', err.message)
  } else {
    console.log('Connected to SQLite database')
  }
})

// Promisificar las consultas
const query = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.all(sql, params, (err, rows) => {
      if (err) {
        reject(err)
      } else {
        resolve({ rows })
      }
    })
  })
}

const run = (sql, params = []) => {
  return new Promise((resolve, reject) => {
    db.run(sql, params, function(err) {
      if (err) {
        reject(err)
      } else {
        resolve({ 
          lastID: this.lastID, 
          changes: this.changes 
        })
      }
    })
  })
}

module.exports = {
  query,
  run,
  db
}

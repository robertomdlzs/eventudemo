const { Pool } = require('pg');
require('dotenv').config();

const db = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
});

async function runMediaMigration() {
  try {
    console.log('Ejecutando migración de biblioteca de medios...');
    
    // Media files table
    await db.query(`
      CREATE TABLE IF NOT EXISTS media_files (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        original_name VARCHAR(255) NOT NULL,
        type VARCHAR(50) NOT NULL CHECK (type IN ('image', 'video', 'audio', 'document')),
        size BIGINT NOT NULL,
        url TEXT NOT NULL,
        alt_text TEXT,
        description TEXT,
        tags TEXT[],
        folder_id INTEGER,
        upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        last_used TIMESTAMP,
        usage_count INTEGER DEFAULT 0,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Media folders table
    await db.query(`
      CREATE TABLE IF NOT EXISTS media_folders (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        parent_id INTEGER REFERENCES media_folders(id) ON DELETE CASCADE,
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);

    // Create indexes
    await db.query(`
      CREATE INDEX IF NOT EXISTS idx_media_files_type ON media_files(type);
      CREATE INDEX IF NOT EXISTS idx_media_files_folder ON media_files(folder_id);
      CREATE INDEX IF NOT EXISTS idx_media_files_upload_date ON media_files(upload_date);
      CREATE INDEX IF NOT EXISTS idx_media_folders_parent ON media_folders(parent_id);
    `);

    // Create triggers
    await db.query(`
      CREATE TRIGGER update_media_files_updated_at BEFORE UPDATE ON media_files FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
      CREATE TRIGGER update_media_folders_updated_at BEFORE UPDATE ON media_folders FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
    `);

    console.log('Migración de biblioteca de medios completada exitosamente');
  } catch (error) {
    console.error('Error ejecutando migración de biblioteca de medios:', error);
  } finally {
    await db.end();
  }
}

runMediaMigration();

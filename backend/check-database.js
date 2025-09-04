const { Pool } = require('pg');
require('dotenv').config();

const db = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
});

async function checkDatabase() {
  try {
    console.log('Checking database structure...\n');

    // Check events table
    console.log('=== EVENTS TABLE ===');
    const eventsResult = await db.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'events' 
      ORDER BY ordinal_position
    `);
    
    eventsResult.rows.forEach(row => {
      console.log(`${row.column_name}: ${row.data_type} (${row.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
    });

    // Check media_files table
    console.log('\n=== MEDIA_FILES TABLE ===');
    const mediaResult = await db.query(`
      SELECT column_name, data_type, is_nullable 
      FROM information_schema.columns 
      WHERE table_name = 'media_files' 
      ORDER BY ordinal_position
    `);
    
    mediaResult.rows.forEach(row => {
      console.log(`${row.column_name}: ${row.data_type} (${row.is_nullable === 'YES' ? 'nullable' : 'not null'})`);
    });

    // Check if there are any media files
    console.log('\n=== MEDIA FILES COUNT ===');
    const countResult = await db.query('SELECT COUNT(*) as count FROM media_files');
    console.log(`Total media files: ${countResult.rows[0].count}`);

    // Check if there are any events with images
    console.log('\n=== EVENTS WITH IMAGES ===');
    const eventsWithImages = await db.query(`
      SELECT id, title, image_url, youtube_url 
      FROM events 
      WHERE image_url IS NOT NULL OR youtube_url IS NOT NULL
    `);
    
    console.log(`Events with images/videos: ${eventsWithImages.rows.length}`);
    eventsWithImages.rows.forEach(row => {
      console.log(`- ${row.title}: image=${row.image_url}, video=${row.youtube_url}`);
    });

  } catch (error) {
    console.error('Error checking database:', error);
  } finally {
    await db.end();
  }
}

checkDatabase();

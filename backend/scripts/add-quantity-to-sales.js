// Script para agregar el campo quantity a la tabla sales
const db = require('../config/database-postgres')

async function addQuantityToSales() {
  try {
    console.log('🔧 Agregando campo quantity a la tabla sales...')
    
    // Verificar si el campo ya existe
    const checkColumn = await db.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'sales' AND column_name = 'quantity'
    `)
    
    if (checkColumn.rows.length > 0) {
      console.log('✅ El campo quantity ya existe en la tabla sales')
      return
    }
    
    // Agregar el campo quantity
    await db.query(`
      ALTER TABLE sales 
      ADD COLUMN quantity INTEGER DEFAULT 1
    `)
    
    console.log('✅ Campo quantity agregado exitosamente a la tabla sales')
    
    // Actualizar registros existentes para que tengan quantity = 1
    const updateResult = await db.query(`
      UPDATE sales 
      SET quantity = 1 
      WHERE quantity IS NULL
    `)
    
    console.log(`✅ ${updateResult.rowCount} registros actualizados con quantity = 1`)
    
    // Verificar la estructura final
    const finalCheck = await db.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = 'sales' 
      ORDER BY ordinal_position
    `)
    
    console.log('📋 Estructura final de la tabla sales:')
    finalCheck.rows.forEach(col => {
      console.log(`  ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable}, default: ${col.column_default})`)
    })
    
  } catch (error) {
    console.error('❌ Error:', error.message)
  } finally {
    process.exit(0)
  }
}

addQuantityToSales()

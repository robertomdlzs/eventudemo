// Script para migrar la tabla sales agregando campos faltantes
const express = require('express')
const { Pool } = require('pg')

// Configurar conexión a la base de datos
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || "postgresql://postgres:Eventu321@localhost:5432/eventu_db",
})

async function migrateSalesTable() {
  try {
    console.log('🔧 Migrando tabla sales...')
    
    // Verificar si el campo quantity existe
    const checkQuantity = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'sales' AND column_name = 'quantity'
    `)
    
    if (checkQuantity.rows.length === 0) {
      console.log('➕ Agregando campo quantity...')
      await pool.query(`
        ALTER TABLE sales 
        ADD COLUMN quantity INTEGER DEFAULT 1
      `)
      console.log('✅ Campo quantity agregado')
    } else {
      console.log('✅ Campo quantity ya existe')
    }
    
    // Verificar si el campo unit_price existe
    const checkUnitPrice = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'sales' AND column_name = 'unit_price'
    `)
    
    if (checkUnitPrice.rows.length === 0) {
      console.log('➕ Agregando campo unit_price...')
      await pool.query(`
        ALTER TABLE sales 
        ADD COLUMN unit_price DECIMAL(10,2) DEFAULT 0
      `)
      console.log('✅ Campo unit_price agregado')
    } else {
      console.log('✅ Campo unit_price ya existe')
    }
    
    // Verificar si el campo ticket_type_id existe
    const checkTicketTypeId = await pool.query(`
      SELECT column_name 
      FROM information_schema.columns 
      WHERE table_name = 'sales' AND column_name = 'ticket_type_id'
    `)
    
    if (checkTicketTypeId.rows.length === 0) {
      console.log('➕ Agregando campo ticket_type_id...')
      await pool.query(`
        ALTER TABLE sales 
        ADD COLUMN ticket_type_id INTEGER
      `)
      console.log('✅ Campo ticket_type_id agregado')
    } else {
      console.log('✅ Campo ticket_type_id ya existe')
    }
    
    // Actualizar registros existentes
    console.log('🔄 Actualizando registros existentes...')
    const updateResult = await pool.query(`
      UPDATE sales 
      SET 
        quantity = COALESCE(quantity, 1),
        unit_price = COALESCE(unit_price, total_amount),
        ticket_type_id = COALESCE(ticket_type_id, 1)
      WHERE quantity IS NULL OR unit_price IS NULL OR ticket_type_id IS NULL
    `)
    
    console.log(`✅ ${updateResult.rowCount} registros actualizados`)
    
    // Verificar la estructura final
    const finalCheck = await pool.query(`
      SELECT column_name, data_type, is_nullable, column_default
      FROM information_schema.columns 
      WHERE table_name = 'sales' 
      ORDER BY ordinal_position
    `)
    
    console.log('📋 Estructura final de la tabla sales:')
    finalCheck.rows.forEach(col => {
      console.log(`  ${col.column_name}: ${col.data_type} (nullable: ${col.is_nullable}, default: ${col.column_default})`)
    })
    
    console.log('🎉 Migración completada exitosamente!')
    
  } catch (error) {
    console.error('❌ Error en la migración:', error.message)
  } finally {
    await pool.end()
    process.exit(0)
  }
}

migrateSalesTable()

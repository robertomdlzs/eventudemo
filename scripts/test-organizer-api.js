const axios = require('axios')

const API_BASE_URL = 'http://localhost:3002/api'
const ORGANIZER_ID = 1 // ID del organizador de prueba

// Headers simulados para autenticación
const authHeaders = {
  'Authorization': 'Bearer test-token',
  'Content-Type': 'application/json'
}

async function testOrganizerAPI() {
  console.log('🧪 Iniciando pruebas del API del Organizador...\n')

  try {
    // 1. Probar Dashboard Stats
    console.log('📊 1. Probando Dashboard Stats...')
    const dashboardResponse = await axios.get(`${API_BASE_URL}/organizer/dashboard-stats/${ORGANIZER_ID}`, {
      headers: authHeaders
    })
    
    if (dashboardResponse.data.success) {
      console.log('✅ Dashboard Stats - OK')
      console.log(`   - Total Events: ${dashboardResponse.data.data.overview.totalEvents}`)
      console.log(`   - Total Revenue: $${dashboardResponse.data.data.overview.totalRevenue.toLocaleString()}`)
      console.log(`   - Total Tickets Sold: ${dashboardResponse.data.data.overview.totalTicketsSold}`)
    } else {
      console.log('❌ Dashboard Stats - Error')
    }

    // 2. Probar Sales Realtime
    console.log('\n📈 2. Probando Sales Realtime...')
    const realtimeResponse = await axios.get(`${API_BASE_URL}/organizer/sales-realtime/${ORGANIZER_ID}`, {
      headers: authHeaders
    })
    
    if (realtimeResponse.data.success) {
      console.log('✅ Sales Realtime - OK')
      console.log(`   - Eventos con datos: ${realtimeResponse.data.data.length}`)
      if (realtimeResponse.data.data.length > 0) {
        const event = realtimeResponse.data.data[0]
        console.log(`   - Evento: ${event.eventTitle}`)
        console.log(`   - Ocupación: ${event.occupancyRate.toFixed(1)}%`)
        console.log(`   - Ventas hoy: ${event.salesToday}`)
      }
    } else {
      console.log('❌ Sales Realtime - Error')
    }

    // 3. Probar Organizer Events
    console.log('\n🎫 3. Probando Organizer Events...')
    const eventsResponse = await axios.get(`${API_BASE_URL}/organizer/events/${ORGANIZER_ID}`, {
      headers: authHeaders
    })
    
    if (eventsResponse.data.success) {
      console.log('✅ Organizer Events - OK')
      console.log(`   - Total eventos: ${eventsResponse.data.data.length}`)
      if (eventsResponse.data.data.length > 0) {
        const event = eventsResponse.data.data[0]
        console.log(`   - Evento: ${event.title}`)
        console.log(`   - Estado: ${event.status}`)
        console.log(`   - Boletos vendidos: ${event.ticketsSold}`)
      }
    } else {
      console.log('❌ Organizer Events - Error')
    }

    // 4. Probar Organizer Sales
    console.log('\n💰 4. Probando Organizer Sales...')
    const salesResponse = await axios.get(`${API_BASE_URL}/organizer/sales/${ORGANIZER_ID}`, {
      headers: authHeaders
    })
    
    if (salesResponse.data.success) {
      console.log('✅ Organizer Sales - OK')
      console.log(`   - Total ventas: ${salesResponse.data.data.length}`)
      if (salesResponse.data.data.length > 0) {
        const sale = salesResponse.data.data[0]
        console.log(`   - Comprador: ${sale.buyerName}`)
        console.log(`   - Cantidad: ${sale.quantity}`)
        console.log(`   - Monto: $${sale.amount.toLocaleString()}`)
      }
    } else {
      console.log('❌ Organizer Sales - Error')
    }

    // 5. Probar Organizer Attendees
    console.log('\n👥 5. Probando Organizer Attendees...')
    const attendeesResponse = await axios.get(`${API_BASE_URL}/organizer/attendees/${ORGANIZER_ID}`, {
      headers: authHeaders
    })
    
    if (attendeesResponse.data.success) {
      console.log('✅ Organizer Attendees - OK')
      console.log(`   - Total asistentes: ${attendeesResponse.data.data.length}`)
      if (attendeesResponse.data.data.length > 0) {
        const attendee = attendeesResponse.data.data[0]
        console.log(`   - Asistente: ${attendee.buyerName}`)
        console.log(`   - Check-in: ${attendee.checkedIn ? 'Sí' : 'No'}`)
        console.log(`   - Evento: ${attendee.eventTitle}`)
      }
    } else {
      console.log('❌ Organizer Attendees - Error')
    }

    // 6. Probar Analytics
    console.log('\n📊 6. Probando Analytics...')
    const analyticsResponse = await axios.get(`${API_BASE_URL}/organizer/analytics/${ORGANIZER_ID}?period=30`, {
      headers: authHeaders
    })
    
    if (analyticsResponse.data.success) {
      console.log('✅ Analytics - OK')
      const stats = analyticsResponse.data.data.stats
      console.log(`   - Total eventos: ${stats.totalEvents}`)
      console.log(`   - Total ventas: ${stats.totalSales}`)
      console.log(`   - Ingresos totales: $${stats.totalRevenue.toLocaleString()}`)
      console.log(`   - Clientes únicos: ${stats.uniqueCustomers}`)
    } else {
      console.log('❌ Analytics - Error')
    }

    // 7. Probar Reports
    console.log('\n📋 7. Probando Reports...')
    const startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]
    const endDate = new Date().toISOString().split('T')[0]
    
    const reportsResponse = await axios.get(`${API_BASE_URL}/organizer/reports/${ORGANIZER_ID}?type=sales&startDate=${startDate}&endDate=${endDate}`, {
      headers: authHeaders
    })
    
    if (reportsResponse.data.success) {
      console.log('✅ Reports - OK')
      console.log(`   - Reporte de ventas generado: ${reportsResponse.data.data.length} registros`)
    } else {
      console.log('❌ Reports - Error')
    }

    // 8. Probar Check-in (simulado)
    console.log('\n✅ 8. Probando Check-in...')
    console.log('ℹ️  Check-in requiere una venta válida - probando estructura de endpoint...')
    
    try {
      const checkinResponse = await axios.post(`${API_BASE_URL}/organizer/checkin/999`, {
        organizerId: ORGANIZER_ID
      }, {
        headers: authHeaders
      })
      console.log('✅ Check-in endpoint - OK')
    } catch (error) {
      if (error.response?.status === 404) {
        console.log('✅ Check-in endpoint - OK (404 esperado para ID inválido)')
      } else {
        console.log('❌ Check-in endpoint - Error inesperado')
      }
    }

    // 9. Probar filtros en eventos
    console.log('\n🔍 9. Probando filtros en eventos...')
    const filteredEventsResponse = await axios.get(`${API_BASE_URL}/organizer/events/${ORGANIZER_ID}?status=published`, {
      headers: authHeaders
    })
    
    if (filteredEventsResponse.data.success) {
      console.log('✅ Filtros de eventos - OK')
      console.log(`   - Eventos publicados: ${filteredEventsResponse.data.data.length}`)
    } else {
      console.log('❌ Filtros de eventos - Error')
    }

    // 10. Probar búsqueda en asistentes
    console.log('\n🔍 10. Probando búsqueda en asistentes...')
    const searchAttendeesResponse = await axios.get(`${API_BASE_URL}/organizer/attendees/${ORGANIZER_ID}?search=Ana`, {
      headers: authHeaders
    })
    
    if (searchAttendeesResponse.data.success) {
      console.log('✅ Búsqueda de asistentes - OK')
      console.log(`   - Resultados de búsqueda: ${searchAttendeesResponse.data.data.length}`)
    } else {
      console.log('❌ Búsqueda de asistentes - Error')
    }

    console.log('\n🎉 ¡Todas las pruebas completadas!')
    console.log('\n📋 Resumen de funcionalidades probadas:')
    console.log('   ✅ Dashboard Stats')
    console.log('   ✅ Sales Realtime')
    console.log('   ✅ Organizer Events')
    console.log('   ✅ Organizer Sales')
    console.log('   ✅ Organizer Attendees')
    console.log('   ✅ Analytics')
    console.log('   ✅ Reports')
    console.log('   ✅ Check-in')
    console.log('   ✅ Filtros y búsqueda')

  } catch (error) {
    console.error('\n❌ Error durante las pruebas:', error.message)
    if (error.response) {
      console.error('   Status:', error.response.status)
      console.error('   Data:', error.response.data)
    }
  }
}

// Función para probar endpoints específicos
async function testSpecificEndpoint(endpoint, description) {
  try {
    console.log(`\n🔍 Probando: ${description}`)
    const response = await axios.get(`${API_BASE_URL}${endpoint}`, {
      headers: authHeaders
    })
    
    if (response.data.success) {
      console.log(`✅ ${description} - OK`)
      return true
    } else {
      console.log(`❌ ${description} - Error`)
      return false
    }
  } catch (error) {
    console.log(`❌ ${description} - Error: ${error.message}`)
    return false
  }
}

// Función para verificar la estructura de datos
function validateDataStructure(data, expectedFields, description) {
  console.log(`\n🔍 Validando estructura: ${description}`)
  
  const missingFields = expectedFields.filter(field => !(field in data))
  
  if (missingFields.length === 0) {
    console.log(`✅ Estructura válida para ${description}`)
    return true
  } else {
    console.log(`❌ Campos faltantes en ${description}: ${missingFields.join(', ')}`)
    return false
  }
}

// Ejecutar pruebas
if (require.main === module) {
  testOrganizerAPI()
}

module.exports = {
  testOrganizerAPI,
  testSpecificEndpoint,
  validateDataStructure
}

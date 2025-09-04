const fetch = require('node-fetch');

async function assignEventsToPromoter() {
  try {
    console.log('🔍 Asignando eventos al promotor...');
    
    // Primero hacer login como admin
    const loginResponse = await fetch('http://localhost:3002/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        email: 'admin@eventu.co',
        password: 'Eventu321'
      })
    });

    const loginData = await loginResponse.json();
    
    if (!loginData.success) {
      console.error('❌ Error en login de admin:', loginData.message);
      return;
    }

    const adminToken = loginData.data.token;
    console.log('✅ Login de admin exitoso');

    // Obtener todos los eventos
    const eventsResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3002/api'}/events`);
    const eventsData = await eventsResponse.json();
    
    if (!eventsData.success) {
      console.error('❌ Error obteniendo eventos:', eventsData.message);
      return;
    }

    console.log('📊 Total de eventos disponibles:', eventsData.data.length);

    // Asignar algunos eventos al promotor (ID: 26)
    const eventsToAssign = eventsData.data.slice(0, 3); // Tomar los primeros 3 eventos
    
    for (const event of eventsToAssign) {
      console.log(`🔄 Asignando evento: ${event.title} (ID: ${event.id})`);
      
      const updateResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3002/api'}/events/${event.id}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${adminToken}`
        },
        body: JSON.stringify({
          organizer_id: 26 // ID del promotor
        })
      });

      const updateData = await updateResponse.json();
      
      if (updateData.success) {
        console.log(`✅ Evento ${event.title} asignado correctamente`);
      } else {
        console.log(`❌ Error asignando evento ${event.title}:`, updateData.message);
      }
    }

    console.log('\n🎉 Proceso completado');
    console.log('🔄 Ahora puedes acceder al panel del promotor');
    
  } catch (error) {
    console.error('❌ Error:', error);
  }
}

assignEventsToPromoter();


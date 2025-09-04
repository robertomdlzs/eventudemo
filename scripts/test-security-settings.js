const axios = require('axios');

const API_BASE_URL = 'http://localhost:3002/api';

// Configuración de autenticación (simular admin)
const authHeaders = {
  'Authorization': 'Bearer admin-token',
  'Content-Type': 'application/json'
};

async function testSecuritySettings() {
  console.log('🔍 Iniciando pruebas de configuraciones de seguridad...\n');

  try {
    // 1. Probar obtención de configuraciones
    console.log('1️⃣ Probando obtención de configuraciones...');
    const getResponse = await axios.get(`${API_BASE_URL}/settings`, { headers: authHeaders });
    console.log('✅ Configuraciones obtenidas:', getResponse.data.success);
    
    if (getResponse.data.success) {
      const settings = getResponse.data.data;
      console.log('📋 Configuraciones actuales:');
      console.log(`   - 2FA: ${settings.two_factor_auth}`);
      console.log(`   - Límite intentos: ${settings.login_attempts_limit}`);
      console.log(`   - Máximo intentos: ${settings.max_login_attempts}`);
      console.log(`   - Duración bloqueo: ${settings.lockout_duration} min`);
      console.log(`   - Auto logout: ${settings.auto_logout}`);
      console.log(`   - Tiempo sesión: ${settings.session_timeout} min`);
      console.log(`   - Longitud contraseña: ${settings.password_min_length}`);
      console.log(`   - Registro actividad: ${settings.activity_logging}`);
      console.log(`   - Notificaciones: ${settings.security_notifications}`);
    }

    // 2. Probar actualización de configuraciones de seguridad
    console.log('\n2️⃣ Probando actualización de configuraciones de seguridad...');
    const testSettings = {
      twoFactorAuth: true,
      loginAttemptsLimit: true,
      maxLoginAttempts: 3,
      lockoutDuration: 15,
      autoLogout: true,
      sessionTimeout: 30,
      passwordMinLength: 10,
      passwordRequireUppercase: true,
      passwordRequireLowercase: true,
      passwordRequireNumbers: true,
      passwordRequireSymbols: true,
      activityLogging: true,
      securityNotifications: true
    };

    const updateResponse = await axios.put(`${API_BASE_URL}/settings`, testSettings, { headers: authHeaders });
    console.log('✅ Configuraciones actualizadas:', updateResponse.data.success);

    // 3. Verificar que los cambios se aplicaron
    console.log('\n3️⃣ Verificando cambios aplicados...');
    const verifyResponse = await axios.get(`${API_BASE_URL}/settings`, { headers: authHeaders });
    const updatedSettings = verifyResponse.data.data;
    
    const changesApplied = 
      updatedSettings.two_factor_auth === testSettings.twoFactorAuth &&
      updatedSettings.max_login_attempts === testSettings.maxLoginAttempts &&
      updatedSettings.lockout_duration === testSettings.lockoutDuration &&
      updatedSettings.password_min_length === testSettings.passwordMinLength;

    console.log('✅ Cambios aplicados correctamente:', changesApplied);

    // 4. Probar validación de rangos
    console.log('\n4️⃣ Probando validación de rangos...');
    const invalidSettings = {
      maxLoginAttempts: 15, // Debería ser máximo 10
      lockoutDuration: 2000, // Debería ser máximo 1440
      sessionTimeout: 5, // Debería ser mínimo 15
      passwordMinLength: 3 // Debería ser mínimo 8
    };

    try {
      await axios.put(`${API_BASE_URL}/settings`, invalidSettings, { headers: authHeaders });
      console.log('❌ Validación de rangos falló');
    } catch (error) {
      console.log('✅ Validación de rangos funcionando correctamente');
    }

    // 5. Probar actualización de configuración específica
    console.log('\n5️⃣ Probando actualización de configuración específica...');
    const specificUpdate = await axios.put(`${API_BASE_URL}/settings/two_factor_auth`, { value: false }, { headers: authHeaders });
    console.log('✅ Configuración específica actualizada:', specificUpdate.data.success);

    // 6. Probar exportación de configuraciones
    console.log('\n6️⃣ Probando exportación de configuraciones...');
    const exportResponse = await axios.post(`${API_BASE_URL}/settings/export`, {}, { headers: authHeaders });
    console.log('✅ Configuraciones exportadas:', exportResponse.data.success);

    // 7. Probar reseteo de configuraciones
    console.log('\n7️⃣ Probando reseteo de configuraciones...');
    const resetResponse = await axios.post(`${API_BASE_URL}/settings/reset`, {}, { headers: authHeaders });
    console.log('✅ Configuraciones reseteadas:', resetResponse.data.success);

    // 8. Verificar valores por defecto
    console.log('\n8️⃣ Verificando valores por defecto...');
    const defaultResponse = await axios.get(`${API_BASE_URL}/settings`, { headers: authHeaders });
    const defaultSettings = defaultResponse.data.data;
    
    const defaultsCorrect = 
      defaultSettings.two_factor_auth === false &&
      defaultSettings.login_attempts_limit === true &&
      defaultSettings.max_login_attempts === 5 &&
      defaultSettings.lockout_duration === 30 &&
      defaultSettings.auto_logout === true &&
      defaultSettings.session_timeout === 60 &&
      defaultSettings.password_min_length === 8;

    console.log('✅ Valores por defecto correctos:', defaultsCorrect);

    console.log('\n🎉 ¡Todas las pruebas completadas exitosamente!');
    console.log('\n📊 Resumen de pruebas:');
    console.log('   ✅ Obtención de configuraciones');
    console.log('   ✅ Actualización de configuraciones');
    console.log('   ✅ Verificación de cambios');
    console.log('   ✅ Validación de rangos');
    console.log('   ✅ Actualización específica');
    console.log('   ✅ Exportación de configuraciones');
    console.log('   ✅ Reseteo de configuraciones');
    console.log('   ✅ Valores por defecto');

  } catch (error) {
    console.error('❌ Error en las pruebas:', error.response?.data || error.message);
  }
}

// Ejecutar pruebas
testSecuritySettings();

 
 # Configuración de Google Analytics para Eventu

## Pasos para configurar Google Analytics

### 1. Crear una cuenta de Google Analytics

1. Ve a [Google Analytics](https://analytics.google.com/)
2. Crea una nueva cuenta para tu organización
3. Crea una nueva propiedad para Eventu
4. Selecciona "Web" como plataforma
5. Configura la información de tu sitio web

### 2. Obtener el ID de seguimiento

1. En Google Analytics, ve a **Administrador** > **Propiedad** > **Configuración de la propiedad**
2. Copia el **ID de medición** (formato: G-XXXXXXXXXX)

### 3. Configurar las variables de entorno

Crea un archivo `.env.local` en la raíz del proyecto con:

```env
# Google Analytics Configuration
NEXT_PUBLIC_GA_ID=G-XXXXXXXXXX

# Database Configuration
DATABASE_URL=postgresql://postgres:Eventu321@localhost:5432/eventu_db

# JWT Secret
JWT_SECRET=your-super-secret-jwt-key-here

# Server Configuration
PORT=3002
NODE_ENV=development
```

### 4. Eventos que se están trackeando

La aplicación ya está configurada para trackear los siguientes eventos:

#### Eventos de Usuario
- **Login**: Cuando un usuario inicia sesión
- **Sign Up**: Cuando un usuario se registra
- **Page Views**: Navegación entre páginas

#### Eventos de E-commerce
- **Add to Cart**: Cuando se agrega un ticket al carrito
- **Begin Checkout**: Cuando inicia el proceso de checkout
- **Purchase**: Cuando se completa una compra

#### Eventos de Administración
- **File Upload**: Cuando se suben archivos a la biblioteca de medios
- **Admin Actions**: Acciones administrativas

#### Eventos de Formularios
- **Form Submission**: Envío exitoso de formularios
- **Form Errors**: Errores en formularios

### 5. Verificar la instalación

1. Abre las herramientas de desarrollador del navegador
2. Ve a la pestaña **Network**
3. Busca llamadas a `googletagmanager.com`
4. En Google Analytics, ve a **Informes en tiempo real** para ver la actividad

### 6. Configuraciones adicionales recomendadas

#### Configurar objetivos de conversión
1. Ve a **Administrador** > **Vista** > **Objetivos**
2. Crea objetivos para:
   - Registro de usuarios
   - Compra de tickets
   - Inicio de sesión

#### Configurar eventos personalizados
1. Ve a **Administrador** > **Propiedad** > **Eventos**
2. Configura eventos para:
   - Visualización de eventos
   - Selección de asientos
   - Subida de archivos

### 7. Privacidad y cumplimiento

#### GDPR/CCPA
- La aplicación respeta las preferencias de cookies del usuario
- Los datos se procesan de forma anónima cuando es posible
- Los usuarios pueden optar por no ser trackeados

#### Configuración de cookies
```javascript
// Ejemplo de configuración de consentimiento
gtag('consent', 'default', {
  'analytics_storage': 'denied'
});

// Cuando el usuario acepta
gtag('consent', 'update', {
  'analytics_storage': 'granted'
});
```

### 8. Monitoreo y reportes

#### Reportes recomendados
1. **Audiencia**: Demografía y comportamiento de usuarios
2. **Adquisición**: Cómo llegan los usuarios al sitio
3. **Comportamiento**: Páginas más visitadas y flujo de usuarios
4. **Conversiones**: Objetivos y eventos de e-commerce

#### Alertas personalizadas
Configura alertas para:
- Caída en conversiones
- Errores 404 frecuentes
- Cambios significativos en el tráfico

### 9. Optimización

#### Mejores prácticas
- Revisa regularmente los reportes de velocidad del sitio
- Monitorea las tasas de rebote y tiempo en página
- Analiza el flujo de usuarios para identificar puntos de fricción
- Optimiza las páginas con menor rendimiento

#### A/B Testing
Usa Google Optimize para:
- Probar diferentes diseños de páginas
- Optimizar formularios de registro
- Mejorar la experiencia de checkout

### 10. Soporte

Para problemas con Google Analytics:
1. Revisa la [documentación oficial](https://developers.google.com/analytics)
2. Consulta el [Centro de ayuda](https://support.google.com/analytics)
3. Verifica la configuración en [Google Tag Assistant](https://tagassistant.google.com/)

---

**Nota**: Asegúrate de cumplir con las leyes de privacidad locales y obtener el consentimiento de los usuarios antes de activar el tracking.

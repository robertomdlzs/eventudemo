
# 🎫 Eventu - Plataforma de Gestión de Eventos

Una plataforma completa para la gestión y venta de boletos para eventos, construida con Next.js y optimizada para despliegue en Netlify.

## 🚀 Despliegue en Netlify

Este proyecto está configurado para desplegarse fácilmente en Netlify. Consulta la [guía completa de despliegue](NETLIFY_DEPLOY.md) para instrucciones detalladas.

### Despliegue Rápido

1. **Conectar Repositorio**
   - Ve a [Netlify](https://app.netlify.com)
   - Conecta tu repositorio de GitHub/GitLab
   - Configura: Build command: `npm run build`, Publish directory: `out`

2. **Variables de Entorno**
   - Configura las variables necesarias en Netlify Dashboard
   - Consulta `env.netlify.example` para la lista completa

3. **¡Listo!**
   - Netlify desplegará automáticamente en cada push

## 🛠️ Desarrollo Local

```bash
# Instalar dependencias
npm install

# Desarrollo
npm run dev

# Build para producción
npm run build

# Preview del build
npm run netlify:preview
```

## 📁 Estructura del Proyecto

```
├── app/                    # Páginas de Next.js (App Router)
├── components/             # Componentes reutilizables
├── hooks/                  # Custom hooks
├── lib/                    # Utilidades y configuraciones
├── public/                 # Archivos estáticos
├── netlify/               # Configuraciones de Netlify
├── netlify.toml           # Configuración principal de Netlify
├── _redirects            # Redirecciones para SPA
└── env.netlify.example   # Variables de entorno de ejemplo
```

## 🔧 Tecnologías

- **Frontend**: Next.js 14, React 18, TypeScript
- **Styling**: Tailwind CSS, Radix UI
- **Backend**: Node.js, Express, PostgreSQL
- **Despliegue**: Netlify
- **Autenticación**: JWT
- **Pagos**: Stripe, PayPal, ePayco

## 📚 Documentación

- [Guía de Despliegue en Netlify](NETLIFY_DEPLOY.md)
- [Configuración de Pagos](PAYMENT_METHODS_SETUP.md)
- [Configuración de Google Analytics](GOOGLE_ANALYTICS_SETUP.md)
- [Políticas de Seguridad](docs/security-policies.md)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 📞 Soporte

Para soporte, envía un email a soporte@eventu.co o abre un issue en GitHub.

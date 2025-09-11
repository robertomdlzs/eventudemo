# Guía de Despliegue en Domcloud

Esta guía te ayudará a desplegar tu aplicación Next.js en Domcloud.

## Configuración Inicial

### 1. Preparar el Proyecto

Asegúrate de que tu proyecto tenga los siguientes archivos de configuración:

- `domcloud.config.js` - Configuración principal de Domcloud
- `domcloud.yaml` - Configuración alternativa en YAML
- `domcloud.json` - Configuración en formato JSON
- `package.json` - Con los scripts necesarios

### 2. Scripts de Package.json

Tu `package.json` debe incluir estos scripts:

```json
{
  "scripts": {
    "build": "next build",
    "dev": "next dev",
    "start": "next start"
  }
}
```

### 3. Variables de Entorno

Configura las variables de entorno necesarias en el panel de Domcloud:

- `NODE_ENV=production`
- `NEXT_PUBLIC_API_URL` (si aplica)
- Otras variables específicas de tu aplicación

## Proceso de Despliegue

### 1. Conectar Repositorio

1. Ve al panel de Domcloud
2. Conecta tu repositorio de GitHub/GitLab
3. Selecciona la rama `main` para el despliegue automático

### 2. Configuración de Build

Domcloud detectará automáticamente que es un proyecto Next.js y usará:

- **Comando de Build**: `npm run build`
- **Directorio de Salida**: `.next`
- **Node.js Version**: 18.x

### 3. Despliegue

El despliegue se realizará automáticamente cuando hagas push a la rama principal.

## Configuración Avanzada

### Headers Personalizados

Puedes configurar headers personalizados en `next.config.js`:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
        ],
      },
    ]
  },
}

module.exports = nextConfig
```

### Variables de Entorno

Para variables de entorno específicas del cliente, usa el prefijo `NEXT_PUBLIC_`:

```javascript
// En tu código
const apiUrl = process.env.NEXT_PUBLIC_API_URL
```

## Monitoreo y Logs

- Accede a los logs de build en el panel de Domcloud
- Monitorea el rendimiento de tu aplicación
- Configura alertas para errores críticos

## Troubleshooting

### Error de Build

Si el build falla:

1. Verifica que todos los scripts en `package.json` funcionen localmente
2. Revisa las variables de entorno
3. Consulta los logs de build en Domcloud

### Error de Runtime

Si la aplicación no funciona en producción:

1. Verifica que todas las dependencias estén en `dependencies`
2. Confirma que las variables de entorno estén configuradas
3. Revisa los logs de la aplicación

## Soporte

Para soporte adicional:

- Documentación oficial de Domcloud
- Foro de la comunidad
- Soporte técnico de Domcloud

/** @type {import('next').NextConfig} */
const nextConfig = {
  
  // Configuración para Netlify
  output: 'export',
  trailingSlash: true,
  poweredByHeader: false,
  compress: true,
  
  // Configuración para evitar errores de prerenderizado
  generateBuildId: async () => {
    return 'build-' + Date.now()
  },
  
  images: {
    domains: [
      'images.unsplash.com',
      'via.placeholder.com',
      'picsum.photos',
      'localhost'
    ],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'via.placeholder.com',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'picsum.photos',
        port: '',
        pathname: '/**',
      },
    ],
  },

  // Headers se configuran en netlify.toml para export
}

module.exports = nextConfig

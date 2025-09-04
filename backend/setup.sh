#!/bin/bash

echo "🚀 Setting up Eventu Backend..."

# Create logs directory
mkdir -p logs

# Check if .env file exists
if [ ! -f .env ]; then
    echo "⚠️  .env file not found. Copying from .env.example..."
    cp .env.example .env
    echo "📝 Please edit .env file with your PostgreSQL credentials"
    echo ""
    echo "Required environment variables:"
    echo "- DB_HOST (default: localhost)"
    echo "- DB_PORT (default: 5432)"
    echo "- DB_NAME (default: eventu_db)"
    echo "- DB_USER (your PostgreSQL username)"
    echo "- DB_PASSWORD (your PostgreSQL password)"
    echo "- JWT_SECRET (generate a secure secret key)"
    echo ""
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

echo "✅ Backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your database credentials"
echo "2. Create PostgreSQL database: createdb eventu_db"
echo "3. Run database setup script: npm run setup-db"
echo "4. Start the server: npm run dev"

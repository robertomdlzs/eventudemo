#!/bin/bash

echo "🚀 Starting Eventu Backend (Node.js)..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

# Navigate to backend directory
cd backend

# Check if package.json exists
if [ ! -f "package.json" ]; then
    echo "❌ package.json not found. Make sure you're in the correct directory."
    exit 1
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Creating from .env.example..."
    if [ -f "../.env.example" ]; then
        cp ../.env.example .env
        echo "✅ .env file created. Please edit it with your configuration."
    else
        echo "❌ .env.example not found. Please create .env file manually."
        exit 1
    fi
fi

# Create logs directory if it doesn't exist
if [ ! -d "logs" ]; then
    mkdir logs
    echo "📁 Created logs directory"
fi

# Start the server
echo "🔥 Starting Node.js server..."
npm run dev

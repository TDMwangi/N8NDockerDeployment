#!/bin/bash

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "Please edit the .env file with your actual database credentials before running docker-compose up"
    exit 1
fi

# Start the services
echo "Starting n8n with PostgreSQL..."
docker compose up -d

echo "n8n is starting up..."
echo "Once ready, you can access n8n at http://localhost:5678"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"

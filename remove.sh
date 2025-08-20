#!/bin/bash

# Permanently remove all n8n resources
# WARNING: This will delete all n8n data permanently!

set -e

echo "⚠️  WARNING: This will PERMANENTLY DELETE all n8n data and resources!"
echo "This includes:"
echo "  - All workflows and executions"
echo "  - All credentials and connections"
echo "  - All database data"
echo "  - All Docker volumes"
echo "  - All Docker images"
echo ""

# Confirmation prompt
read -p "Are you absolutely sure you want to continue? (type 'DELETE' to confirm): " confirmation

if [ "$confirmation" != "DELETE" ]; then
    echo "❌ Cleanup cancelled."
    exit 1
fi

echo ""
echo "🧹 Starting cleanup process..."

# Stop and remove containers
echo "🛑 Stopping and removing containers..."
docker compose down --remove-orphans 2>/dev/null || true
docker stop n8n n8n_postgres 2>/dev/null || true
docker rm n8n n8n_postgres 2>/dev/null || true

# Remove any standalone n8n containers
echo "🗑️  Removing any standalone n8n containers..."
docker ps -aq --filter "name=n8n" | xargs -r docker rm -f

# Remove volumes
echo "💾 Removing Docker volumes..."
docker volume rm n8n_data 2>/dev/null || true
docker volume rm postgres_data 2>/dev/null || true
docker volume ls -q --filter "name=n8n" | xargs -r docker volume rm

# Remove networks
echo "🌐 Removing Docker networks..."
docker network ls --filter "name=n8n" -q | xargs -r docker network rm 2>/dev/null || true

# Remove images
echo "🖼️  Removing Docker images..."
docker images --filter "reference=*n8n*" -q | xargs -r docker rmi -f 2>/dev/null || true
docker images --filter "reference=docker.n8n.io/n8nio/n8n*" -q | xargs -r docker rmi -f 2>/dev/null || true
docker images --filter "reference=ghcr.io/*/n8n*" -q | xargs -r docker rmi -f 2>/dev/null || true

# Clean up any dangling resources
echo "🧽 Cleaning up dangling resources..."
docker system prune -f

echo ""
echo "✅ Cleanup completed successfully!"
echo ""
echo "All n8n resources have been permanently removed:"
echo "  ✓ Containers stopped and removed"
echo "  ✓ Volumes deleted"
echo "  ✓ Images removed"
echo "  ✓ Networks cleaned up"
echo "  ✓ Dangling resources pruned"

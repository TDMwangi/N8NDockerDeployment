FROM docker.n8n.io/n8nio/n8n

# Set default environment variables
ENV GENERIC_TIMEZONE=EAT
ENV TZ=EAT
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV N8N_RUNNERS_ENABLED=true
ENV DB_TYPE=postgresdb

# Expose the n8n port
EXPOSE 5678

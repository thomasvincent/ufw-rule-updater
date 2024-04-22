FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y ufw curl

# Create a directory for the script
RUN mkdir /app

# Copy the script to the container
COPY cloudflare-ufw-updater.sh /app/

# Make the script executable
RUN chmod +x /app/cloudflare-ufw-updater.sh

# Set the entrypoint to the script
ENTRYPOINT ["/app/cloudflare-ufw-updater.sh"]
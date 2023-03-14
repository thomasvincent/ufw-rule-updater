# Use a lightweight base image with shell capabilities
FROM alpine:latest

# Install curl and ufw (Uncomplicated Firewall)
RUN apk add --no-cache curl ufw

# Copy the script into the container
COPY cf_ufw.sh /cf_ufw.sh

# Set the script as executable
RUN chmod +x /cf_ufw.sh

# Set the entrypoint to run the script
ENTRYPOINT ["/cf_ufw.sh"]

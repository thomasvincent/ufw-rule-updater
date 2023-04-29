#!/bin/sh

# This script updates the UFW rules to permit only HTTP and HTTPS traffic originating from Cloudflare IP addresses.
# For further information and documentation, visit:
# https://github.com/thomasvincent/cloudflare-ufw-updater/blob/master/README.md

set -eu

# Define variables
TEMP_FILE=$(mktemp)
CLOUDFLARE_IPv4_URL="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_IPv6_URL="https://www.cloudflare.com/ips-v6"
ALLOWED_PORTS="80,443"
RULE_COMMENT="Cloudflare"

# Check if the required tools are installed
check_dependencies() {
  if ! command -v ufw > /dev/null; then
    echo "UFW is not installed. Aborting."
    exit 1
  fi

  if ! command -v curl > /dev/null; then
    echo "curl is not installed. Aborting."
    exit 1
  fi
}

# Check if the user has sufficient permissions
check_permissions() {
  if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Aborting."
    exit 1
  fi
}

# Fetch the latest Cloudflare IP ranges and update UFW rules accordingly
fetch_and_update_ranges() {
  # Retrieve the latest IPv4 and IPv6 IP ranges from Cloudflare.
  if ! curl -s --retry 3 --retry-delay 5 "$CLOUDFLARE_IPv4_URL" -o "$TEMP_FILE"; then
    echo "Failed to fetch IPv4 addresses. Aborting."
    exit 1
  fi

  echo "" >> "$TEMP_FILE"

  if ! curl -s --retry 3 --retry-delay 5 "$CLOUDFLARE_IPv6_URL" >> "$TEMP_FILE"; then
    echo "Failed to fetch IPv6 addresses. Aborting."
    exit 1
  fi

  # Update UFW rules to allow traffic only on ports 80 (TCP) and 443 (TCP) from the fetched IP ranges.
  # If a rule for a specific subnet already exists, UFW will not create a duplicate rule.
  while IFS= read -r ip; do
    ufw allow from "$ip" to any port "$ALLOWED_PORTS" proto tcp comment "$RULE_COMMENT"
  done < "$TEMP_FILE"

  # Remove the temporary file containing the IP ranges.
  rm "$TEMP_FILE"
}

# Main function to run the script
main() {
  check_dependencies
  check_permissions
  fetch_and_update_ranges
  ufw reload
}

main

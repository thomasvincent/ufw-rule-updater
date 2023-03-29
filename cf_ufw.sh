#!/usr/bin/env sh

# This script updates the UFW rules to permit only HTTP and HTTPS traffic originating from Cloudflare IP addresses.
# For further information and documentation, visit:
# https://github.com/thomasvincent/cloudflare-ufw-updater/blob/master/README.md

set -eu

# Define variables
TMP_FILE=$(mktemp)
IPv4_URL="https://www.cloudflare.com/ips-v4"
IPv6_URL="https://www.cloudflare.com/ips-v6"
PORTS="80,443"
COMMENT="Cloudflare"

# Fetch the latest Cloudflare IP ranges and update UFW rules accordingly
fetch_and_update_ranges() {
  # Retrieve the latest IPv4 and IPv6 IP ranges from Cloudflare.
  curl -s "$IPv4_URL" -o "$TMP_FILE"
  echo "" >> "$TMP_FILE"
  curl -s "$IPv6_URL" >> "$TMP_FILE"

  # Update UFW rules to allow traffic only on ports 80 (TCP) and 443 (TCP) from the fetched IP ranges.
  # If a rule for a specific subnet already exists, UFW will not create a duplicate rule.
  while IFS= read -r ip; do
    ufw allow from "$ip" to any port "$PORTS" proto tcp comment "$COMMENT"
  done < "$TMP_FILE"

  # Remove the temporary file containing the IP ranges.
  rm "$TMP_FILE"
}

# Check if UFW is installed
if ! command -v ufw > /dev/null; then
  echo "UFW is not installed. Aborting."
  exit 1
fi

# Check if the user has sufficient permissions
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Aborting."
  exit 1
fi

# Call the fetch_and_update_ranges function to update the UFW rules
fetch_and_update_ranges

# Reload UFW to apply the updated rules
ufw reload

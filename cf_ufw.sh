#!/bin/sh

# This script updates the UFW rules to permit only HTTP and HTTPS traffic originating from Cloudflare IP addresses.
# For further information and documentation, visit:
# https://github.com/thomasvincent/cloudflare-ufw-updater/blob/master/README.md

set -eu

# Define variables
CLOUDFLARE_IP_FILE=$(mktemp)
CLOUDFLARE_IPV4_URL="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_IPV6_URL="https://www.cloudflare.com/ips-v6"
ALLOWED_HTTP_PORTS="80,443"
CLOUDFLARE_RULE_LABEL="Cloudflare"

# Check dependencies
check_dependencies() {
  for cmd in ufw curl; do
    if ! command -v "$cmd" > /dev/null; then
      printf "Command not found in PATH: %s\n" "$cmd"
      exit 1
    fi
  done
}

# Check permissions
check_permissions() {
  if [ "$(id -u)" -ne 0 ]; then
    printf "This script must be run as root. Aborting.\n"
    exit 1
  fi
}

# Fetch latest IPv4 addresses
fetch_ipv4_addresses() {
  if ! curl -s --retry 3 --retry-delay 5 "${CLOUDFLARE_IPV4_URL}" > "$CLOUDFLARE_IP_FILE"; then
    printf "Failed to fetch IPv4 addresses: %s\n" "$(curl -s -o /dev/null -w %{http_code})"
    exit 1
  fi
}

# Fetch latest IPv6 addresses
fetch_ipv6_addresses() {
  if ! curl -s --retry 3 --retry-delay 5 "${CLOUDFLARE_IPV6_URL}" >> "$CLOUDFLARE_IP_FILE"; then
    printf "Failed to fetch IPv6 addresses: %s\n" "$(curl -s -o /dev/null -w %{http_code})"
    exit 1
  fi
}

# Update UFW rules
update_ufw_rules() {
  while IFS= read -r ip; do
    ufw allow from "$ip" to any port "$ALLOWED_HTTP_PORTS" proto tcp comment "$CLOUDFLARE_RULE_LABEL"
  done < "$CLOUDFLARE_IP_FILE"
}

# Main function
main() {
  check_dependencies
  check_permissions
  fetch_ipv4_addresses
  fetch_ipv6_addresses

  # Optional: Close temporary file explicitly
  # cat "$CLOUDFLARE_IP_FILE" | update_ufw_rules

  update_ufw_rules
  rm -f "$CLOUDFLARE_IP_FILE"  # Ensure removal even on errors
  ufw reload
}

main

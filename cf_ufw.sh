#!/usr/bin/env sh

# This script updates the UFW rules to permit only HTTP and HTTPS traffic originating from Cloudflare IP addresses.
# For further information and documentation, visit:
# https://github.com/thomasvincent/cloudflare-ufw-updater/blob/master/README.md
#

set -eu

# Function to fetch the latest Cloudflare IP ranges and update UFW rules accordingly.
fetch_and_update_ranges() {
  tmp_file="/tmp/cf_ips"
  ipv4_url="https://www.cloudflare.com/ips-v4"
  ipv6_url="https://www.cloudflare.com/ips-v6"

  # Retrieve the latest IPv4 and IPv6 IP ranges from Cloudflare.
  curl -s "$ipv4_url" -o "$tmp_file"
  echo "" >> "$tmp_file"
  curl -s "$ipv6_url" >> "$tmp_file"

  # Update UFW rules to allow traffic only on ports 80 (TCP) and 443 (TCP) from the fetched IP ranges.
  # If a rule for a specific subnet already exists, UFW will not create a duplicate rule.
  while IFS= read -r ip; do
    ufw allow from "$ip" to any port 80,443 proto tcp comment 'Cloudflare'
  done < "$tmp_file"

  # Remove the temporary file containing the IP ranges.
  rm "$tmp_file"
}

# Execute the fetch_and_update_ranges function to update the UFW rules.
fetch_and_update_ranges

# Reload UFW to apply the updated rules.
ufw reload

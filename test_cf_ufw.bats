#!/usr/bin/env bats

# BATS test for cf-ufw.sh

setup() {
  # Copy the original script to a temporary file for testing
  cp cf-ufw.sh cf-ufw_test.sh
}

teardown() {
  # Remove temporary files
  rm cf-ufw_test.sh
  rm /tmp/cf_ips 2>/dev/null || true
}

@test "Check if the script fetches IP ranges and updates UFW rules" {
  # Replace curl command with a function to simulate fetching data from Cloudflare
  sed -i 's|curl -s "$ipv4_url" -o "$tmp_file"|echo "192.0.2.1" > "$tmp_file"|' cf-ufw_test.sh
  sed -i 's|curl -s "$ipv6_url" >> "$tmp_file"|echo "2001:db8::1" >> "$tmp_file"|' cf-ufw_test.sh

  # Run the test script
  run bash cf-ufw_test.sh

  # Check if the script execution succeeded
  [ "$status" -eq 0 ]

  # Check if the rules are added
  ufw status numbered | grep -q "192.0.2.1"
  ufw status numbered | grep -q "2001:db8::1"

  # Delete the rules added during the test
  ufw delete "$(ufw status numbered | grep -n '192.0.2.1' | cut -d'[' -f2 | cut -d']' -f1)"
  ufw delete "$(ufw status numbered | grep -n '2001:db8::1' | cut -d'[' -f2 | cut -d']' -f1)"
}

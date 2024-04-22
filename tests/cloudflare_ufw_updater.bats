#!/usr/bin/env bats

setup() {
  # Set up the test environment
  docker-compose up -d
  docker cp ../cloudflare-ufw-updater.sh cloudflare-ufw-updater:/app/
  docker exec cloudflare-ufw-updater chmod +x /app/cloudflare-ufw-updater.sh
}

teardown() {
  # Clean up the test environment
  docker-compose down
}

@test "Cloudflare UFW Updater script updates UFW rules" {
  run docker exec cloudflare-ufw-updater /app/cloudflare-ufw-updater.sh
  assert_success
  assert_output --partial "UFW rules updated successfully"
}

@test "Cloudflare UFW Updater script backs up UFW rules" {
  run docker exec cloudflare-ufw-updater /app/cloudflare-ufw-updater.sh
  assert_success
  run docker exec cloudflare-ufw-updater ls /etc/ufw/cloudflare-ufw-updater.backup
  assert_success
}

@test "Cloudflare UFW Updater script restores UFW rules from backup" {
  run docker exec cloudflare-ufw-updater /app/cloudflare-ufw-updater.sh --restore
  assert_success
  assert_output --partial "Restored UFW rules from backup"
}
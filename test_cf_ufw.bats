#!/usr/bin/env bats

@test "Check if the script fetches IP ranges and updates UFW rules" {
  # Set up a temporary UFW rules file for testing
  export UFW_RULES_FILE="$(mktemp)"
  echo "# temporary UFW rules file for testing" > "$UFW_RULES_FILE"

  # Replace the `ufw` command with a mock that appends the rule to the temporary file
  function ufw() {
    echo "$@" >> "$UFW_RULES_FILE"
  }

  # Run the script
  ./cf_ufw.sh

  # Check if the temporary UFW rules file contains the expected rules
  grep -q "allow from" "$UFW_RULES_FILE"
  [ "$?" -eq 0 ]

  # Clean up
  unset UFW_RULES_FILE
  unalias ufw
}

# Cloudflare UFW Updater

A Bash script to automatically update UFW (Uncomplicated Firewall) rules to allow incoming HTTP and HTTPS traffic only from Cloudflare IP addresses.

## Features

- Fetches the latest Cloudflare IP addresses (IPv4 and IPv6) from the official Cloudflare API.
- Updates UFW rules to allow incoming traffic on specified ports only from Cloudflare IP addresses.
- Supports customization through a configuration file or environment variables.
- Provides logging functionality to track script execution and any errors encountered.
- Includes error handling and dependency checks to ensure smooth operation.
- Supports backup and restore of UFW rules for easy rollback if needed.

## Prerequisites

- UFW (Uncomplicated Firewall) installed and enabled on your system.
- Bash shell environment.
- `curl` command-line tool for fetching Cloudflare IP addresses.

## Installation

1. Clone the repository or download the script file:

   ```bash
   git clone https://github.com/yourusername/cloudflare-ufw-updater.git
   ```

2. Make the script executable:

   ```bash
   chmod +x cloudflare-ufw-updater.sh
   ```

3. (Optional) Create a configuration file at `/etc/cloudflare-ufw-updater.conf` to customize the script's behavior. See the "Configuration" section for more details.

## Usage

Run the script with root privileges:

```bash
sudo ./cloudflare-ufw-updater.sh
```

The script will fetch the latest Cloudflare IP addresses, update the UFW rules, and reload UFW to apply the changes.

## Configuration

The script can be customized through a configuration file or environment variables.

### Configuration File

Create a configuration file at `/etc/cloudflare-ufw-updater.conf` with the following variables:

```bash
# Cloudflare IP address URLs
CLOUDFLARE_IPV4_URL="https://www.cloudflare.com/ips-v4"
CLOUDFLARE_IPV6_URL="https://www.cloudflare.com/ips-v6"

# Allowed HTTP/HTTPS ports
ALLOWED_HTTP_PORTS="80,443,8080"

# Cloudflare UFW rule label
CLOUDFLARE_RULE_LABEL="Cloudflare"

# Log file path
LOG_FILE="/var/log/cloudflare-ufw-updater.log"

# Backup file path
BACKUP_FILE="/etc/ufw/cloudflare-ufw-updater.backup"
```

Adjust the values according to your requirements.

### Environment Variables

You can also set configuration values using environment variables. The script will prioritize environment variables over the values in the configuration file.

Example:

```bash
LOG_FILE="/path/to/custom/log.txt" ./cloudflare-ufw-updater.sh
```

## Logging

The script logs its execution details and any errors encountered to the specified log file (default: `/var/log/cloudflare-ufw-updater.log`). You can customize the log file path in the configuration file or through the `LOG_FILE` environment variable.

## Backup and Restore

The script automatically creates a backup of the current UFW rules before making any changes. The backup file is stored at the path specified by the `BACKUP_FILE` variable (default: `/etc/ufw/cloudflare-ufw-updater.backup`).

To restore the UFW rules from the backup file, run the script with the `--restore` flag:

```bash
sudo ./cloudflare-ufw-updater.sh --restore
```

## License

This script is released under the [MIT License](LICENSE).

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the [GitHub repository](https://github.com/yourusername/cloudflare-ufw-updater).
````
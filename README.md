# Cloudflare UFW Updater

This repository contains a script `cf_ufw.sh` that automatically updates UFW rules to allow only HTTP and HTTPS traffic from Cloudflare IP addresses, ensuring a secure and up-to-date firewall.

## Prerequisites

- UFW (Uncomplicated Firewall) installed and enabled
- `curl` command-line tool installed

## Installation

1. Clone the repository:

`git clone https://github.com/yourusername/cloudflare-ufw-updater.git`

2. Change to the repository directory:

`cd cloudflare-ufw-updater`

3. Make the script executable:

`chmod +x cf_ufw.sh`

## Usage

You can run the script manually:

`./cf_ufw.sh`

To schedule the script to run automatically every day, follow these steps:

1. Open the root user's crontab:

`sudo crontab -e`

2. Add the following line to the end of the file, replacing `/path/to/script` with the actual path to the `cf_ufw.sh` script:

`@daily /path/to/script/cf_ufw.sh &> /dev/null`

3. Save and exit the editor. The script will now run once a day, updating your UFW rules to the latest Cloudflare IP ranges.

## Inspired by
[https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh](https://github.com/Paul-Reed/cloudflare-ufw/blob/master/cloudflare-ufw.sh)

[https://github.com/jakejarvis/cloudflare-ufw-updater/](https://github.com/jakejarvis/cloudflare-ufw-updater/)

## Contributing

If you'd like to contribute to this project, please submit a pull request with your changes or open an issue to discuss your ideas.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

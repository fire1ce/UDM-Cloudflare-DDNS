# UDM-Cloudflare-DDNS

## Change Log

- 2024-07-02 - Added support for Unifi OS v4.x
- 2023-12-14 - Updated installation and uninstallation scripts for better user experience, flexibility, and removed support for v1.x firmware versions.
- 2023-02-10 - Major Update for UDM v2.x and v3.x

## What It Does

This project provides a script to set up a DDNS (Dynamic DNS) service using Cloudflare as the DNS provider on Ubiquiti's UDM devices. The script sets up a systemd service and timer to handle DDNS updates for your main internet IP address at regular intervals.

## Compatibility

- Tested on [UDM PRO][amz-udm-pro-url] with UDM OS v3.2.7

## Requirements

- UDM OS 2.x or 3.x
- ssh root access to the UDM
- Cloudflare API Toke

### Creating a Cloudflare API token

To create a CloudFlare API token for your DNS zone go to [https://dash.cloudflare.com/profile/api-tokens][cloudflare-api-token-url] and follow these steps:

1. Click Create Token
2. Select Create Custom Token
3. Provide the token a name, for example, `example.com-dns-zone`
4. Grant the token the following permissions:
   - Zone - DNS - Edit
5. Set the zone resources to:
   - Include - Specific Zone - `example.com`
6. Complete the wizard.
7. Use the generated token at the `API_KEY` variable for the container

## Installation

Run the following command to install the Cloudflare DDNS service as root on your UDM:

```shell
sudo curl -s -o install.sh https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/install.sh
sudo chmod +x install.sh
sudo ./install.sh
```

This script will:

Determine the appropriate data directory.
Download and install the DDNS script and configuration file.
Set up a systemd service and timer to run the DDNS script at regular intervals (configurable by the user).

## Configuration

After installation, you can find and edit the configuration file typically located at `/data/cloudflare-ddns/update-cloudflare-dns.conf` or `/mnt/data/cloudflare-ddns/update-cloudflare-dns.conf`, depending on your UDM model and firmware version. Update this file with your Cloudflare details.

## Uninstallation

To uninstall the Cloudflare DDNS service, you will need to run an uninstallation script that:

Stops and disables the systemd service and timer.
Removes the DDNS script, configuration files, and systemd files.
Optionally removes log files, if generated by the service.

Run the following command to uninstall the Cloudflare DDNS service as root on your UDM:

```shell
sudo curl -s https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/uninstall.sh | bash
```

## Acknowledgments

This UDM-Cloudflare-DDNS project is based on the [DDNS-Cloudflare-Bash][DDNS-Cloudflare-Bash-git-url] script by the same author. It has been adapted and extended specifically for use with Ubiquiti's UDM devices.

<!-- --- -->

[amz-udm-pro-url]: https://amzn.to/3J4fezk 'Amazon Unifi UDM Pro'
[cloudflare-api-token-url]: https://dash.cloudflare.com/profile/api-tokens 'Cloudflare API Token'
[DDNS-Cloudflare-Bash-git-url]: https://github.com/fire1ce/DDNS-Cloudflare-Bash 'DDNS-Cloudflare-Bash'

<!-- --- -->

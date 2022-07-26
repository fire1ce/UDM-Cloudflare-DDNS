# UDM-Cloudflare-DDNS

## What It Does

This will allow to to span a container with `podman` to handle DDNS updates for main internet IP address.  
The container will run the background without any system permissions.

## Compatibility

- Tested on [UDM PRO][amz-udm-pro-url]

## Requirements

Persistence on Reboot is required.  
This can be accomplished with a boot script. Flow this guide: [UDM Boot Script](https://github.com/unifi-utilities/unifios-utilities/tree/main/on-boot-script)

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

```shell
curl -s https://raw.githubusercontent.com/fire1ce/UDM-Cloudflare-DDNS/main/install.sh | sh
```

## Configuration

Edit the configuration file located at

```shell
/mnt/data/on_boot.d/30-cloudflare-ddns.sh
```

## Parameters

For detailed information on the parameters, see the [oznu/docker-cloudflare-ddns Github Page][oznu-docker-cloudflare-ddns-url]

| Parameter | Description            | Example       | Type                | Required |
| --------- | ---------------------- | ------------- | ------------------- | -------- |
| PI_KEY    | Cloudflare API Token   | change_me     | string              | Yes      |
| ZONE      | Cloudflare Domain      | example.com   | string              | Yes      |
| SUBDOMAIN | Remove Proxied Records | ddns          | string              | Yes      |
| CRON      | Pi-hole hostname/IP    | `"* * * * *"` | string(cron syntax) | Yes      |

## Access DDNS Container Logs

In order to check that everything is working, you can access the logs of the container using the following command:

```shell
podman logs -f cloudflare-ddns
```

## Credit

Based on [oznu/docker-cloudflare-ddns][oznu-docker-cloudflare-ddns-url] by [oznu][oznu-github-page-url],
[unifios-utilities/cloudflare-ddns][unifios-utilities-cloudflare-ddns-url]

<!-- --- -->

[unifios-utilities-cloudflare-ddns-url]: https://github.com/unifi-utilities/unifios-utilities/tree/main/cloudflare-ddns 'unifios-utilities-cloudflare-ddns'
[oznu-docker-cloudflare-ddns-url]: https://github.com/oznu/docker-cloudflare-ddns 'docker-cloudflare-ddns'
[oznu-github-page-url]: https://github.com/oznu 'oznu github page'
[amz-udm-pro-url]: https://amzn.to/3J4fezk 'Amazon Unifi UDM Pro'
[cloudflare-api-token-url]: https://dash.cloudflare.com/profile/api-tokens 'Cloudflare API Token'

<!-- --- -->

# Cloudflare Dynamic DNS Updater
A bash script to automatically update Cloudflare DNS records with your current IP. Useful if your IP changes often.

## Features
- Supports multiple records

## Requirements
- A Cloudflare account.
- `curl` and `jq` installed.

## Get Your API Token & Zone ID
1. **API Token:**
   - Go to [Cloudflare Dashboard](https://dash.cloudflare.com/).
   - Navigate to **My Profile > API Tokens**.
   - Click **Create Token** and choose **Edit DNS Zone**.
   - Copy the token and replace `CF_API_TOKEN` in the script.

2. **Zone ID:**
   - Go to **Cloudflare Dashboard > Your Domain**.
   - Find the **Zone ID** at the bottom of the Overview page.
   - Replace `ZONE_ID` in the script.

## Installation
1. Clone this repository:
   ```sh
   git clone https://github.com/kdrlegend/cloudflare-ddns.git
   cd cloudflare-ddns
   ```
2. Edit the script `cf-update-dns.sh` and update your API token, Zone ID, and domains.

## Usage
Make the script executable:
```sh
chmod +x cf-update-dns.sh
```

Run the script:
```sh
./cf-update-dns.sh
```

To automate updates, add it to a cron job:
```sh
crontab -e
```
Add this line to update every 5 minutes:
```sh
*/5 * * * * /path/to/cf-update-dns.sh >/dev/null 2>&1
```

## License
MIT License

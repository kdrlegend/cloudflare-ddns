#!/bin/bash

# variables
CF_API_TOKEN=""
ZONE_ID=""
RECORDS=("example.com" "sub.example.com" "sub2.example.com")  # Add as many domains as you want

# fetch public IP
CURRENT_IP=$(curl -s http://ipv4.icanhazip.com)

for RECORD_NAME in "${RECORDS[@]}"; do
    echo "Updating $RECORD_NAME..."

    # get existing Cloudflare record 
    RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" | jq -r '.result[0].id')

    if [[ "$RECORD_ID" == "null" ]]; then
        echo "Error: Could not find DNS record for $RECORD_NAME"
        continue
    fi

    # Get the existing IP
    EXISTING_IP=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" | jq -r '.result.content')

    # wether IP is already updated
    if [[ "$CURRENT_IP" == "$EXISTING_IP" ]]; then
        echo "$RECORD_NAME is already up-to-date."
        continue
    fi

    # else update records
    UPDATE_RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $CF_API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}")

    # Check if the update was successful
    if echo "$UPDATE_RESPONSE" | jq -e '.success' >/dev/null; then
        echo "Successfully updated $RECORD_NAME to $CURRENT_IP"
    else
        echo "Failed to update $RECORD_NAME"
    fi
done

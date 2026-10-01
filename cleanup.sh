#!/bin/bash

_dir="$(dirname "$0")"

source "$_dir/config.sh"

# Strip only the top domain to get the zone id
DOMAIN=$(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
[[ -z "$DOMAIN" ]] && DOMAIN="$CERTBOT_DOMAIN"

if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then

	# https://yandex.ru/dev/api360/doc/ref/DomainDNSService/DomainDNSService_Delete.html
	RESULT=$(curl -s -X DELETE "https://api360.yandex.net/directory/v1/org/$ORG_ID/domains/$DOMAIN/dns/$RECORD_ID" \
      -H "Authorization: OAuth $OAUTH_TOKEN" \
      -H "Content-Type: application/json")

    if [[ "$RESULT" == "{}" ]]; then
        echo "ok"
    else
        echo $RESULT
    fi
fi

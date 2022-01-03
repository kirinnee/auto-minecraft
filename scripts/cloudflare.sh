#!/bin/sh

command="$1"
token="$2"
val1="$3"
val2="$4"
val3="$5"

usage=$(
	cat <<-END
		Commands:
		    zones <token> <zone> - list zones
		    dns <token> <zone_id> - list dns
		    update:dns <token> <zone_id> <dns_id> <new_ip> - update DNS to new IP
	END
)

[ "$command" = '' ] && echo "$usage" && exit 1
[ "$command" != 'zones' ] && [ "$command" != 'dns' ] &&
	[ "$command" != 'update:dns' ] &&
	echo "$usage" && exit 1

[ "$token" = '' ] && echo "$usage" && exit 1
[ "$val1" = '' ] && echo "$usage" && exit 1

if [ "$command" = 'zones' ]; then
	curl -X GET "https://api.cloudflare.com/client/v4/zones?name=${val1}&status=active&order=status&direction=desc&match=all" \
		-H "Authorization: Bearer ${token}" \
		-H "Content-Type: application/json" | jq
elif [ "$command" = 'dns' ]; then
	curl -X GET "https://api.cloudflare.com/client/v4/zones/${val1}/dns_records?type=A&order=type&direction=desc&match=all" \
		-H "Authorization: Bearer ${token}" \
		-H "Content-Type: application/json" | jq
elif [ "$command" = 'update:dns' ]; then
	curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${val1}/dns_records/${val2}" \
		-H "Authorization: Bearer ${token}" \
		-H "Content-Type: application/json" \
		--data "{\"content\":\"${val3}\", \"proxied\":false}" | jq
else
	echo "$usage"
fi

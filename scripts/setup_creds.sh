#! /bin/sh

set -e

provider="$1"
token="$2"

usage=$(
	cat <<-END
		  Usage:
		    pls setup -- digitalocean <Digital Ocean API key>
		    pls setup -- gcp <Path to GCP Service Account JSON>
	END
)

[ "$provider" != 'digitalocean' ] && [ "$provider" != 'gcp' ] ||
	[ "$token" = '' ] &&
	echo "${usage}" &&
	exit 1

digo="$(grep <.env DIGITALOCEAN_TOKEN)"
gcp="$(grep <.env GOOGLE_APPLICATION_CREDENTIALS)"

[ "$provider" = 'digitalocean' ] && digo="DIGITALOCEAN_TOKEN: ${token}"
[ "$provider" = 'gcp' ] && gcp="GOOGLE_APPLICATION_CREDENTIALS: ${token}"

echo "$digo" >.env
echo "$gcp" >>.env

echo "cloud_provider = \"${provider}\"" >provider.tfvars

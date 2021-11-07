#! /bin/sh

set -e

command="$1"
name="$2"

usage=$(
	cat <<-END
		  Commands:
		    pls key -- gen <name> - generates a key-val pair with <name>. Must not already exist
		    pls key -- set <name> - select the key used to <name>. Must already exist
	END
)

[ "$command" = '' ] && echo "$usage" && exit 1
[ "$name" = '' ] && echo "$usage" && exit 1

if [ "$command" = 'gen' ]; then
	printf '%s\n' "./keys/$name" | ssh-keygen -t rsa -b 4096
elif [ "$command" = 'set' ]; then
	echo "private_key_path = \"./keys/${name}\"" >keys.tfvars
	echo "public_key_path = \"./keys/${name}.pub\"" >>keys.tfvars
	echo "${name}" >.currentkey
fi

#! /bin/sh

set -e

command="$1"
key="$2"
value="$3"

usage=$(
	cat <<-END
		Commands:
		  save <key> <value> - Saves a key and value
		  load <key> - reads a value from the key
		  delete <key> - deletes a key (and the associated values)
		  exist <key> - check if the given key exists
		  list - list all the keys
		  nuke - nukes the database
	END
)

[ "$command" = '' ] && echo "$usage" && exit 1
[ "$command" != 'save' ] && [ "$command" != 'load' ] &&
	[ "$command" != 'exist' ] && [ "$command" != 'list' ] && [ "$command" != 'nuke' ] && [ "$command" != 'delete' ] && echo "$usage" && exit 1

[ "$command" != 'list' ] && [ "$command" != 'nuke' ] && [ "$key" = '' ] && echo "$usage" && exit 1
[ "$command" = 'save' ] && [ "$value" = '' ] && echo "$usage" && exit 1

# load data
if [ ! -e data.json ]; then
	echo "{}" >>data.json
fi

data="$(cat data.json)"

if [ "$command" = 'list' ]; then
	echo "$data" | jq -r 'keys[]'
elif [ "$command" = 'exist' ]; then
	echo "$data" | jq --arg KEY "$key" 'has($KEY)'
elif [ "$command" = 'save' ]; then
	echo "$data" | jq --arg KEY "$key" --arg VALUE "$value" '. += { "\($KEY)": "\($VALUE)" }' >data.json
elif [ "$command" = 'delete' ]; then
	echo "$data" | jq --arg KEY "$key" 'del(.[$KEY])' >data.json
elif [ "$command" = 'load' ]; then
	echo "$data" | jq -r --arg KEY "$key" '.[$KEY]'
elif [ "$command" = 'nuke' ]; then
	echo "{}" >data.json
fi

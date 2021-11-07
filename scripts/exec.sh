#! /bin/sh

current_key="$(cat ./.currentkey)"
ip=$(terraform output -json | jq -r .server_ip.value)

# shellcheck disable=SC2068
ssh -i "./keys/${current_key}" "mc@${ip}" -t $@

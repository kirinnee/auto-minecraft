#! /bin/sh
ip=$(terraform output -json | jq -r .server_ip.value)

# shellcheck disable=SC2068
ssh -i "./profiles/${CURRENT_KEY}/sshkey" "mc@${ip}" -t $@

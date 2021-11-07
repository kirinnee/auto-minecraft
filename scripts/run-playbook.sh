#! /bin/sh

playbook="$1"

[ "$playbook" = '' ] && echo "Please type in name of playbook" && exit 1

current_key="$(cat ./.currentkey)"
ip=$(terraform output -json | jq -r .server_ip.value)

ansible-playbook -u mc -i "${ip}," --private-key "./keys/${current_key}" "./playbooks/${playbook}.yaml"

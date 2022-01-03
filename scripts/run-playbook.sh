#! /bin/sh

key="$1"
playbook="$2"
variables="$3"

[ "$playbook" = '' ] && echo "Please type in name of playbook" && exit 1

ip=$(terraform output -json | jq -r .server_ip.value)

ansible-playbook -u mc -i "${ip}," --private-key "./profiles/${key}/sshkey" "./playbooks/${playbook}.yaml"

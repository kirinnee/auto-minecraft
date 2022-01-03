#! /bin/sh

set -e

command="$1"
key="$2"

usage=$(
	cat <<-END
		Commands:
		  list - List the profiles that exists
		  setup <key> - Initializes a new folder for the server. Setup Secrets and stuff
		  edit <key> - Re-initialize the settings used for the server.
		  create <key> - Creates necessary infrastructure to host the Minecraft Server
		  destroy <key> - Destory all infrastructure related to hosting the Minecraft Server
		  deploy <key> - Deploys or update the configuration of the server
		  pull <key> - Downloads and save the data back to this computer
		  push <key> - Overwrites the server files that are saved in this server
		  enter <key> - Enter the SSH shell of the server
		  log <key> - Display logs of Minecraft Server
		  rcon <key> - Connect to rcon console
		  configpull <key> - Pull Configuration
		  configpush <key> - Push Configuration
		  worldpull <key> - Pull World
		  worldpush <key> - Push World
		  scriptspull <key> - Pull Scripts
		  scriptspush <key> - Push Scripts
		  modspull <key> - Pull Mods
		  modspush <key> - Push Mods
		  worldconfigpull <key> - Pull World Configuration
		  worldconfigpush <key> - Push World
		  sync <key> - Synchronize Terraform state with target server state
		  reboot <key> - Reboots the host machine
		  shutdown <key> - Shutdowns the host machine
		  boot <key> - Boots up the host machine (after it has been created)
		  restart <key> - Restart Minecraft container in target machine
		  stop <key> - Stop Minecraft container in target machine
		  start <key> - Start Minecraft container in target machine
		  ip <key> - Shows IP of the configuration
		  delete <key> - Deletes the configuration
	END
)

infraq=$(
	cat <<-END
		Please select the infrastructure you need:
		  1. Digital Ocean
		  2. GCP
		  3. AWS
	END
)

[ "$command" = '' ] && echo "$usage" && exit 1
[ "$command" != 'setup' ] && [ "$command" != 'edit' ] &&
	[ "$command" != 'create' ] && [ "$command" != 'destroy' ] &&
	[ "$command" != 'deploy' ] && [ "$command" != 'pull' ] &&
	[ "$command" != 'push' ] && [ "$command" != 'list' ] &&
	[ "$command" != 'enter' ] && [ "$command" != 'rcon' ] &&
	[ "$command" != 'configpush' ] && [ "$command" != 'configpull' ] &&
	[ "$command" != 'worldpush' ] && [ "$command" != 'worldpull' ] &&
	[ "$command" != 'scriptspush' ] && [ "$command" != 'scriptspull' ] &&
	[ "$command" != 'modspush' ] && [ "$command" != 'modspull' ] &&
	[ "$command" != 'worldconfigpush' ] && [ "$command" != 'worldconfigpull' ] &&
	[ "$command" != 'delete' ] && [ "$command" != 'ip' ] &&
	[ "$command" != 'log' ] && [ "$command" != 'sync' ] &&
	[ "$command" != 'stop' ] && [ "$command" != 'start' ] &&
	[ "$command" != 'boot' ] && [ "$command" != 'shutdown' ] &&
	[ "$command" != 'restart' ] && [ "$command" != 'reboot' ] &&
	echo "$usage" && exit 1

[ "$command" != "list" ] && [ "$key" = '' ] && echo "$usage" && exit 1

dir="./profiles/$key"

if [ "$key" != '' ]; then
	exist="$(./scripts/db.sh exist "${key}")"
fi

get_cred() {
	if [ "$exist" != "true" ]; then
		echo "Profile doesn't exist!"
		exit 1
	fi
	token="$(jq <"${dir}/meta.json" -r ".token")"
	aws_key="$(jq <"${dir}/meta.json" -r ".awskey")"
	aws_val="$(jq <"${dir}/meta.json" -r ".awsval")"
	aws_region="$(jq <"${dir}/meta.json" -r ".awsregion")"
	credenv="DIGITALOCEAN_TOKEN=""${token}"" GOOGLE_APPLICATION_CREDENTIALS=""${dir}""/gcpkey.json AWS_ACCESS_KEY_ID=""${aws_key}"" AWS_SECRET_ACCESS_KEY=""${aws_val}"" AWS_DEFAULT_REGION=""${aws_region}"""
}

if [ "$command" = 'setup' ]; then

	# create folder
	if [ "$exist" = "true" ]; then
		echo "Profile already exist!"
		exit 1
	fi
	echo "Setting up a new profile..."
	mkdir -p "$dir/"

	# Obtain infra data
	echo "$infraq"
	read -r server

	if [ "$server" = '1' ]; then

		echo "Please enter your DigitalOcean API Token: "
		read -r dotoken

		# Save DO Token, JSON files and tfvars
		echo "{\"type\": \"service_account\"}" >"$dir/gcpkey.json"
		echo "{ \"token\" : \"${dotoken}\", \"awsregion\" : \"empty\", \"awskey\" : \"${dotoken}\", \"awsval\" : \"${dotoken}\", \"type\": \"do\" }" >"$dir/meta.json"
		echo "cloud_provider = \"digitalocean\"" >"$dir/provider.tfvars"

	elif [ "$server" = '2' ]; then

		echo "Please paste your GCP key.json value: "
		read -r gcpjson

		# Save DO Token, JSON files and tfvars
		echo "$gcpjson" >"$dir/gcpkey.json"
		echo "{ \"token\" : \"empty\", \"awsregion\" : \"empty\", \"awskey\" : \"${dotoken}\", \"awsval\" : \"${dotoken}\", \"type\": \"gcp\" }" >"$dir/meta.json"
		echo "cloud_provider = \"gcp\"" >"$dir/provider.tfvars"

	elif [ "$server" = '3' ]; then

		echo "Please enter your AWS Key: "
		read -r awskey

		echo "Please enter your AWS Secret: "
		read -r awssecret

		echo "Please enter your AWS Region: "
		read -r awsregion

		echo "{\"type\": \"service_account\"}" >"$dir/gcpkey.json"
		echo "{ \"token\" : \"empty\", \"awsregion\" : \"${awsregion}\", \"awskey\" : \"${awskey}\", \"awsval\" : \"${awssecret}\", \"type\": \"aws\" }" >"$dir/meta.json"
		echo "cloud_provider = \"aws\"" >"$dir/provider.tfvars"

	else

		echo "Unknown option. Please type either '1' or '2' or '3'."

	fi

	echo "Setting up SSH key..."
	printf '%s\n' "$dir/sshkey" | ssh-keygen -t rsa -b 4096
	echo "private_key_path = \"${dir}/sshkey\"" >"${dir}/keys.tfvars"
	echo "public_key_path = \"${dir}/sshkey.pub\"" >>"${dir}/keys.tfvars"

	echo "Setup terraform workspace..."
	terraform workspace new "${key}"

	./scripts/db.sh save "${key}" "${key}"

elif [ "$command" = 'delete' ]; then
	echo "Removing terraform workspace..."
	terraform workspace delete "${key}"
	echo "Removing Profile folder"
	rm -rf "${dir}"
	echo "Removing db entry"
	./scripts/db.sh delete "${key}"

elif [ "$command" = 'list' ]; then
	./scripts/db.sh list

elif [ "$command" = 'create' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv terraform apply -var-file="${dir}/keys.tfvars" -var-file="${dir}/provider.tfvars"

elif [ "$command" = 'deploy' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" deploy-playbook

elif [ "$command" = 'push' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" push-playbook

elif [ "$command" = 'pull' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" pull-playbook
elif [ "$command" = 'configpull' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=config ./scripts/run-playbook.sh "${key}" pull-generic-playbook

elif [ "$command" = 'configpush' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=config ./scripts/run-playbook.sh "${key}" push-generic-playbook

elif [ "$command" = 'worldpull' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=world ./scripts/run-playbook.sh "${key}" pull-generic-playbook

elif [ "$command" = 'worldpush' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=world ./scripts/run-playbook.sh "${key}" push-generic-playbook

elif [ "$command" = 'modspull' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=mods ./scripts/run-playbook.sh "${key}" pull-generic-playbook

elif [ "$command" = 'modspush' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=mods ./scripts/run-playbook.sh "${key}" push-generic-playbook

elif [ "$command" = 'scriptspull' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=scripts ./scripts/run-playbook.sh "${key}" pull-generic-playbook

elif [ "$command" = 'scriptspush' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=scripts ./scripts/run-playbook.sh "${key}" push-generic-playbook

elif [ "$command" = 'worldconfigpull' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=world/serverconfig ./scripts/run-playbook.sh "${key}" pull-generic-playbook

elif [ "$command" = 'worldconfigpush' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ANSIBLE_FOLDER_NAME=world/serverconfig ./scripts/run-playbook.sh "${key}" push-generic-playbook

elif [ "$command" = 'restart' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" restart

elif [ "$command" = 'start' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" start

elif [ "$command" = 'stop' ]; then
	get_cred
	terraform workspace select "${key}"
	env $credenv ./scripts/run-playbook.sh "${key}" stop

elif [ "$command" = 'reboot' ]; then
	get_cred
	terraform workspace select "${key}"
	instanceId="$(terraform output -json | jq -r '.instance_id.value')"
	env $credenv aws ec2 reboot-instances --instance-ids "${instanceId}"

elif [ "$command" = 'boot' ]; then
	get_cred
	terraform workspace select "${key}"
	instanceId="$(terraform output -json | jq -r '.instance_id.value')"
	env $credenv aws ec2 start-instances --instance-ids "${instanceId}"

elif [ "$command" = 'shutdown' ]; then
	get_cred
	terraform workspace select "${key}"
	instanceId="$(terraform output -json | jq -r '.instance_id.value')"
	env $credenv aws ec2 stop-instances --instance-ids "${instanceId}"

elif [ "$command" = 'destroy' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv terraform destroy -var-file="${dir}/keys.tfvars" -var-file="${dir}/provider.tfvars"

elif [ "$command" = 'enter' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv CURRENT_KEY="${key}" ./scripts/exec.sh bash

elif [ "$command" = 'log' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv CURRENT_KEY="${key}" ./scripts/exec.sh sudo docker logs minecraft_mc_1 -f
elif [ "$command" = 'ip' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv CURRENT_KEY="${key}" terraform output -json | jq -r '.server_ip.value'

elif [ "$command" = 'sync' ]; then

	get_cred
	terraform workspace select "${key}"
	env $credenv terraform refresh -var-file="${dir}/keys.tfvars" -var-file="${dir}/provider.tfvars"

elif
	[ "$command" = 'rcon' ]
then

	get_cred
	terraform workspace select "${key}"
	env $credenv CURRENT_KEY="${key}" ./scripts/exec.sh sudo docker exec -i minecraft_mc_1 rcon-cli

fi

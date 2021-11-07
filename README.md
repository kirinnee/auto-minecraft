# AutoMinecraft

Toolkit to automatically deploy, update or migrate Minecraft Servers on Digital Ocean or GCP using Shell, Terraform and Ansible (and Docker on target machines).

Uses Nix as environment manager (locally) and [taskfile](https://taskfile.dev) as task runner (using `pls` as alias).

# Pre-req
- Digital Ocean or GCP account with $$
- [Nix](https://nixos.org/download.html) (on Linux) > 2.3.12
- sh

# Getting Started
The generic step is needed:
1. Credentials setup (to access GCP or Digital Ocean)
    Note that you will need to obtain GCP Service account JSON to deploy to GCP and Digital Ocean API key for Digital Ocean

2. Key Management (choose and manage keys between servers)
    Use local keys to setup host servers so you can access them via SSH. Note that when you create host servers via commands, it will use the currently selected RSA key by default, and to access the same server (from anywhere), you will need the exact same key. You can view the keys in keys folder (ignored from git)

3. Deploy, pull or push
    - Deploy refers to provisioning and deploying the Minecraft server for the first time. This includes install Docker among other things
    - Pull stops the server and downloads all the data file into `playbooks/modules/server` and stores everything there
    - Push nukes the server, copy everything from `playbooks/modules/server` to the server and starts it up

### Key management
Create key:
```
pls key -- gen <key_name>
```

Select key:
```
pls key -- set <key_name>
```

### Setting up credentials

Digital Ocean:
```
pls setup -- digitalocean <API Key>
```

GCP:
1. Download Service Account JSON file, and rename it `gcpkey.json`
2. Run:
    ```
    pls setup -- gcp gcpkey.json
    ```
### Managing host server
Create
```
pls create
```
and type `yes` and press `enter`


Delete
```
pls destroy
```
and type `yes` and press `enter`

### Deploy, pull and push
Deploy:
```
pls deploy
```

Pull:
```
pls pull
```

Push:
```
pls push
```

### Utilities
Open SSH tunnel
```
pls enter
```

Show Minecraft Logs
```
pls log
```

Open Minecraft admin console:
```
pls rcon
```

Show Machine usage (CPU/Mem) etc
```
pls usage
```

# Configuring
You can configure both Minecraft and the VM itself

## Minecraft
To configure Minecraft, edit the `docker-compose.yaml` file inside `playbooks/modules/setup`, and the whole folder. This can include modpacks, texture packs etc. The full configuration can be found on Docker's official image of Minecraft [here](https://github.com/itzg/docker-minecraft-server/blob/master/README.md).

## VM
You can configure the VM's configuration in `main.tf`, which range from region to instance type (amount of RAM/CPU)

# Terraform Documentation
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_do_minecraft"></a> [do\_minecraft](#module\_do\_minecraft) | ./droplet | n/a |
| <a name="module_gcp_minecraft"></a> [gcp\_minecraft](#module\_gcp\_minecraft) | ./gcp | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | The cloud provider to use. Either digitalocean or gcp. | `string` | n/a | yes |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to private key | `string` | n/a | yes |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to public key | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_server_ip"></a> [server\_ip](#output\_server\_ip) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

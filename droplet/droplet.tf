# resource "digitalocean_ssh_key" "default" {
#  name       = "Minecraft SSH Key"
#  public_key = var.public_key
#}

resource "digitalocean_droplet" "minecraft" {
  image  = "ubuntu-20-04-x64"
  name   = "minecraft"
  region = var.region
  size   = var.node_type
  user_data = templatefile("${path.module}/../cloud-init.tpl", {
    ssh_key = var.public_key
  })
}

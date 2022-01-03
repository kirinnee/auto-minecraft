output "server_ip" {
  value = digitalocean_droplet.minecraft.ipv4_address
}

output "instance_id" {
  value = digitalocean_droplet.minecraft.id
}

module "do_minecraft" {
  source      = "./droplet"
  count       = (var.cloud_provider == "digitalocean") ? 1 : 0
  public_key  = file(var.public_key_path)
  private_key = file(var.private_key_path)



  region    = "sgp1"
  node_type = "c-4"


}

module "gcp_minecraft" {
  source = "./gcp"

  count       = (var.cloud_provider == "gcp") ? 1 : 0
  public_key  = file(var.public_key_path)
  private_key = file(var.private_key_path)



  region    = "asia-southeast1"
  node_type = "e2-standard-8"
  zone      = "asia-southeast1-b"

  project_id = "ace-ellipse-331407"

}

output "server_ip" {
  value = (var.cloud_provider == "gcp") ? module.gcp_minecraft[0].server_ip : module.do_minecraft[0].server_ip
}

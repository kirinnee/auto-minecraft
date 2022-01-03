module "do_minecraft" {
  source      = "./droplet"
  count       = (var.cloud_provider == "digitalocean") ? 1 : 0
  public_key  = file(var.public_key_path)
  private_key = file(var.private_key_path)

  region    = "sgp1"
  node_type = "s-6vcpu-16gb"
}

module "gcp_minecraft" {
  source = "./gcp"

  count       = (var.cloud_provider == "gcp") ? 1 : 0
  public_key  = file(var.public_key_path)
  private_key = file(var.private_key_path)

  region    = "asia-southeast1"
  node_type = "c2-standard-4"
  zone      = "asia-southeast1-b"

  project_id = "ace-ellipse-331407"

}

module "aws_minecraft" {

  source = "./aws"

  count = (var.cloud_provider == "aws") ? 1 : 0

  public_key  = file(var.public_key_path)
  private_key = file(var.private_key_path)

  project = "v6"
  arch    = "amd64"

  node_type = "c5.2xlarge"
  az        = "ap-southeast-1a"

}


output "server_ip" {
  value = (var.cloud_provider == "gcp") ? module.gcp_minecraft[0].server_ip : ((var.cloud_provider == "digitalocean") ? module.do_minecraft[0].server_ip : module.aws_minecraft[0].server_ip)
}

output "instance_id" {
  value = (var.cloud_provider == "gcp") ? module.gcp_minecraft[0].instance_id : ((var.cloud_provider == "digitalocean") ? module.do_minecraft[0].instance_id : module.aws_minecraft[0].instance_id)
}

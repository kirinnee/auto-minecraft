resource "google_compute_instance" "minecraft" {
  name         = "minecraft"
  machine_type = var.node_type

  zone    = var.zone
  project = var.project_id

  boot_disk {
    initialize_params {
      size  = 100
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }


  metadata = {
    user-data = templatefile("${path.module}/../cloud-init.tpl", {
      ssh_key = var.public_key
    })
  }


  network_interface {

    network = google_compute_network.minecraft_network.self_link

    access_config {
    }

  }
}

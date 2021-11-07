resource "google_compute_network" "minecraft_network" {
  name                    = "minecraft-network"
  auto_create_subnetworks = "true"
  project                 = var.project_id
}


resource "google_compute_firewall" "default" {
  name    = "minecraft-firewall"
  project = var.project_id
  network = google_compute_network.minecraft_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "25565"]
  }

  source_ranges = ["0.0.0.0/0"]
}

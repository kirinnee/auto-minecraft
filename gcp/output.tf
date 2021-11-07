output "server_ip" {
  value = google_compute_instance.minecraft.network_interface.0.access_config.0.nat_ip
}

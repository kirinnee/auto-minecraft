variable "private_key_path" {
  description = "Path to private key"
  type        = string
}

variable "public_key_path" {
  description = "Path to public key"
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider to use. Either digitalocean or gcp."
  type        = string
  validation {
    condition     = var.cloud_provider == "digitalocean" || var.cloud_provider == "gcp"
    error_message = "Only 'digitalocean' and 'gcp' are accepted values."
  }
}

variable "private_key_path" {
  description = "Path to private key"
  type        = string
}

variable "public_key_path" {
  description = "Path to public key"
  type        = string
}

variable "cloud_provider" {
  description = "The cloud provider to use. Either digitalocean or gcp or aws."
  type        = string
  validation {
    condition     = var.cloud_provider == "digitalocean" || var.cloud_provider == "gcp" || var.cloud_provider == "aws"
    error_message = "Only 'digitalocean', 'aws', and 'gcp' are accepted values."
  }
}

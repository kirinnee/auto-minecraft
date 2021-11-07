variable "region" {
  description = "Region to be deployed"
  default     = "sgp1"
  type        = string
}

variable "public_key" {
  description = "SSH Public key for nodes"
  type        = string
}

variable "private_key" {
  description = "SSH Public key for nodes"
  type        = string
}

variable "node_type" {
  description = "Droplet type"
  default     = "s-4vcpu-8gb"
  type        = string
}

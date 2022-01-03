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

variable "az" {
  description = "Availability Zone"
  default     = "	ap-southeast-1"
  type        = string
}

variable "arch" {
  description = "Server architecture"
  type        = string
  default     = "amd64"
}

variable "project" {
  description = "unique ID"
  type        = string
}

variable "region" {
  description = "Region to be deployed"
  default     = "asia-southeast1"
  type        = string
}

variable "zone" {
  description = "Zone to be deployed"
  default     = "asia-southeast1-b"
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
  description = "Linode type"
  default     = "c2-standard-4"
  type        = string
}

variable "project_id" {
  description = "Project ID for GCP"
  type        = string
}

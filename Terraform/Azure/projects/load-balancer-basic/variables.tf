variable "sub_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "tf-demo"
}

variable "location" {
  description = "The region for your resources"
  type        = string
  default     = "UK South"
}

variable "ssh_key" {
  description = "Path to the SSH public key"
  type        = string
}

variable "my_ip_address" {
  description = "Your IP address to allow SSH access"
  type        = string
}

variable "private_key" {
  description = "Path to the SSH private key"
  type        = string
}

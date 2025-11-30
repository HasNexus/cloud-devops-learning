variable "sub_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
}

variable "rg_location" {
  description = "The region for your resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "ssh_key" {
  description = "Path to the SSH public key"
  type        = string
}

variable "my_ip_address" {
  description = "Your Public IP address to allow SSH access"
  type        = string
}

variable "private_key" {
  description = "Path to the SSH private key"
  type        = string
}
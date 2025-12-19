variable "sub_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Deployment region"
  type        = string
  default     = "UK South"
}

variable "prefix" {
  description = "Naming prefix for all resources"
  type        = string
}

variable "ssh_key" {
  description = "Path to your SSH public key"
  type        = string
}

variable "my_ip_address" {
  description = "Public IP with CIDR"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

variable "tags" {
  description = "Map of tags for resources"
  type        = map(string)
}

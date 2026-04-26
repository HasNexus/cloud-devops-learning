variable "resource_group_name" {
  description = "The Resource Group where resources will be created"
  type        = string
}

variable "location" {
  description = "Please enter the Azure location where resources will be created"
  type        = string
}

variable "prefix" {
  description = "Please enter the prefix which will be used for all resources"
  type        = string
}

variable "ssh_key" {
  description = "Please enter SSH public key for VM admin user"
  type        = string
}

variable "my_ip_address" {
  description = "Please enter your public IP address with CIDR notation (e.g.,/32 for single IP)"
  type = string
}

variable "subnet_id" {
    description = "The Subnet ID where the VM will be placed"
    type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "sub_id" {
  description = "Please enter your Subscription ID"
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

variable "location" {
  description = "Please enter the Azure location where resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
}
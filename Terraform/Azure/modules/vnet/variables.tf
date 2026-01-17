variable "sub_id" {
  description = "Please enter your Subscription ID"
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "The Resource Group where resources will be created"
  type        = string
}

variable "location" {
  description = "Please enter the Azure location where resources will be created"
  type        = string
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "prefix" {
  description = "Please enter the prefix which will be used for all resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}


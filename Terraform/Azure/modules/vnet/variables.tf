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

variable "subnet_address_space" {
  description = "The address space for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
  
}

variable "prefix" {
  description = "Please enter the prefix which will be used for all resources"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}


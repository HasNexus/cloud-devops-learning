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

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}


variable "keyvault_pricing_tier" {
  description = "Pricing Tier for Keyvault. Standrad or Premium"
  type        = string
}

variable "retention_days" {
  description = "Days to retain deleted vaults. It can be configured to between 7 to 90 days. Once it has been set, it cannot be changed or removed."
  type        = string
}

variable "keyvault_subnet_id" {
  description = "The subnet ID where the private endpoint will be placed"
  type        = string
}
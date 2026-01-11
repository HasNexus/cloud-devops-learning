variable "sub_id" {
  description = "Please enter your Subscription ID"
  type        = string
  sensitive = true
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

variable "app_service_plan_sku" {
  description = "The SKU of the App Service Plan"
  type        = string
}

variable "docker_image_name" {
  description = "The Docker image to be used for the Web App"
  type        = string
}

variable "docker_registry_url" {
  description = "The Docker registry URL"
  type        = string
}

variable "keyvault_pricing_tier" {
  description = "Pricing Tier for Keyvault. Standrad or Premium"
  type = string  
}

variable "retention_days" {
  description = "Days to retain deleted vaults. It can be configured to between 7 to 90 days. Once it has been set, it cannot be changed or removed."
  type = string
}

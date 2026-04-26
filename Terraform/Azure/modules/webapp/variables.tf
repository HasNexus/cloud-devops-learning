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

variable "webapp_subnet_id" {
  description = "The Subnet ID for the Web App"
  type        = string
}

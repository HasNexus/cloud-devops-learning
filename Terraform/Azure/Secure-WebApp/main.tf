terraform {
  backend "azurerm" {
    resource_group_name  = "RG-HAS-TEST"
    storage_account_name = "hasstgtest"
    container_name       = "tf-state-file"
    key                  = "Secure-WebApp/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

module "web-app" {
  source                = "../web-app-module"
  sub_id                = var.sub_id
  location              = var.location
  prefix                = var.prefix
  app_service_plan_sku  = var.app_service_plan_sku
  docker_image_name     = var.docker_image_name
  docker_registry_url   = var.docker_registry_url
  keyvault_pricing_tier = var.keyvault_pricing_tier
  retention_days        = var.retention_days
  tags                  = var.tags
}

output "default_hostname" {
  description = "The default domain/url of the webapp"
  value       = module.web-app.default_hostname
}
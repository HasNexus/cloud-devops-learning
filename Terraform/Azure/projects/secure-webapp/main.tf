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

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

module "web-app" {
  source               = "../../modules/webapp"
  sub_id               = var.sub_id
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  prefix               = var.prefix
  app_service_plan_sku = var.app_service_plan_sku
  webapp_subnet_id     = azurerm_subnet.webapp_subnet.id
  docker_image_name    = var.docker_image_name
  docker_registry_url  = var.docker_registry_url
  tags                 = var.tags
}

module "vnet" {
  source              = "../../modules/vnet"
  sub_id              = var.sub_id
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  prefix              = var.prefix
  vnet_address_space  = var.vnet_address_space
  tags                = var.tags
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = var.webapp_subnet_address_prefix
  depends_on           = [module.vnet]
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "keyvault_subnet" {
  name                 = "keyvault-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.vnet_name
  address_prefixes     = var.keyvault_subnet_address_prefix
  service_endpoints    = ["Microsoft.KeyVault"]
  depends_on           = [module.vnet]

}

module "keyvault" {
  source                = "../../modules/keyvault"
  sub_id                = var.sub_id
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  prefix                = var.prefix
  keyvault_pricing_tier = var.keyvault_pricing_tier
  retention_days        = var.retention_days
  keyvault_subnet_id    = azurerm_subnet.keyvault_subnet.id
  tags                  = var.tags
}

#Assigning role to the Web App's Managed Identity to access Key Vault
data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "webapp_kv_access" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.web-app.principal_id
  depends_on = [
    module.keyvault,
    module.web-app
  ]
}

output "default_hostname" {
  description = "The default domain/url of the webapp"
  value       = module.web-app.default_hostname
}

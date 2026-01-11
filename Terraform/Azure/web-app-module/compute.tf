#Creating Resource Group for the Web App and the other resources
resource "azurerm_resource_group" "rg" {
    name = "${var.prefix}-rg"
    location = var.location
    tags     = var.tags 
}

#Creating App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.prefix}-appserviceplan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

#Creating Web App and enabling SystemAssigned Managed Identity
resource "azurerm_linux_web_app" "webapp" {
  name                = "${var.prefix}-webapp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_service_plan.appserviceplan.location
  service_plan_id     = azurerm_service_plan.appserviceplan.id
  public_network_access_enabled = true
  virtual_network_subnet_id = azurerm_subnet.webapp_subnet.id
  identity {
    type = "SystemAssigned"
  }
   site_config {
    always_on = false
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name = var.docker_image_name
    }
  }
   depends_on = [ azurerm_service_plan.appserviceplan ]
   tags = var.tags
}

#Assigning role to the Web App's Managed Identity to access Key Vault
data "azurerm_subscription" "primary" {}
data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "webapp_kv_access" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.webapp.identity[0].principal_id
  depends_on = [ 
    azurerm_key_vault.keyvault,
    azurerm_linux_web_app.webapp
  ]
}

#Creating a Key Vault to store secrets and giving access to the Web App
resource "azurerm_key_vault" "keyvault" {
name = "${var.prefix}-kv"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
tenant_id = data.azurerm_client_config.current.tenant_id
sku_name = var.keyvault_pricing_tier
soft_delete_retention_days = var.retention_days
rbac_authorization_enabled = true
public_network_access_enabled = false
network_acls {
  bypass = "AzureServices"
  virtual_network_subnet_ids = [azurerm_subnet.keyvault_subnet.id]
  default_action = "Deny" 
}
tags = var.tags
}


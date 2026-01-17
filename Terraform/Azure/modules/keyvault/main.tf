provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

data "azurerm_client_config" "current" {}

#Creating a Key Vault to store secrets
resource "azurerm_key_vault" "keyvault" {
  name                          = "${var.prefix}-kv"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = var.keyvault_pricing_tier
  soft_delete_retention_days    = var.retention_days
  rbac_authorization_enabled    = true
  public_network_access_enabled = false
  network_acls {
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [var.keyvault_subnet_id]
    default_action             = "Deny"
  }
  tags = var.tags
}

#Creating Private Endpoint for Key Vault
resource "azurerm_private_endpoint" "keyvault_pe" {
  name                = "${var.prefix}-kv-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.keyvault_subnet_id

  private_service_connection {
    name                           = "${var.prefix}-kv-psc"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  tags = var.tags

}
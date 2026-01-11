resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on = [ azurerm_virtual_network.vnet ]
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
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
  service_endpoints = [ "Microsoft.KeyVault" ]
  depends_on = [ azurerm_virtual_network.vnet ]

}

resource "azurerm_private_endpoint" "keyvault_pe" {
    name                = "${var.prefix}-kv-pe"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    subnet_id           = azurerm_subnet.keyvault_subnet.id
    
    private_service_connection {
        name                           = "${var.prefix}-kv-psc"
        private_connection_resource_id = azurerm_key_vault.keyvault.id
        is_manual_connection           = false
        subresource_names              = ["vault"]
    }
    
    tags = var.tags
  
}
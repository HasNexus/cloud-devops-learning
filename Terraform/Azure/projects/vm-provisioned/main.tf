resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-rg"
  location = var.location
  tags     = var.tags
}

data "azurerm_platform_image" "Ubuntu" {
  location  = azurerm_resource_group.rg.location
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
}

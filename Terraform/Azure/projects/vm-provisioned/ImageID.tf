data "azurerm_platform_image" "Ubuntu" {
  location  = azurerm_resource_group.rg.location
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
}

output "Ubuntu" {
  value       = data.azurerm_platform_image.Ubuntu.id
  description = "Azure Image ID of Ubuntu instance"
}
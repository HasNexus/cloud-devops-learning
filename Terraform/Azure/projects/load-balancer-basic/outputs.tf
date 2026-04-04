output "azurerm_public_ip" {
  value = azurerm_public_ip.lb-public_ip.ip_address
}

output "Ubuntu" {
  value       = data.azurerm_platform_image.Ubuntu.id
  description = "Azure Image ID of Ubuntu instance"
}

output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "Ubuntu" {
  value       = data.azurerm_platform_image.Ubuntu.id
  description = "Azure Image ID of Ubuntu instance"
}

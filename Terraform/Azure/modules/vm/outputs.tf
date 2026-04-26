output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "nsg_name" {
  value = azurerm_network_security_group.nsg.name
}

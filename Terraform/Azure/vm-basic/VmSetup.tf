resource "azurerm_linux_virtual_machine" "vm-01" {
  name                  = "${var.prefix}-vm-01"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.network_interface.id]
  source_image_reference {
  publisher = data.azurerm_platform_image.Ubuntu.publisher
  offer     = data.azurerm_platform_image.Ubuntu.offer
  sku       = data.azurerm_platform_image.Ubuntu.sku
  version   = data.azurerm_platform_image.Ubuntu.version
}

  admin_username        = var.admin_username
  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags
}

output "public_ip_address" {
  description = "The public IP address of the virtual machine"
  value       = azurerm_public_ip.public_ip.ip_address
}
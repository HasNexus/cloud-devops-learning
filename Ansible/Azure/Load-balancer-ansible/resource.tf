resource "azurerm_linux_virtual_machine" "azure_vm" {
  name                  = "lb-vm-${count.index + 1}"
  count                 = 3
  resource_group_name   = azurerm_resource_group.lb_rg.name
  location              = azurerm_resource_group.lb_rg.location
  network_interface_ids = [azurerm_network_interface.network_interface[count.index].id]
  size                  = "Standard_B1s"
  source_image_reference {

    publisher = data.azurerm_platform_image.Ubuntu.publisher
    offer     = data.azurerm_platform_image.Ubuntu.offer
    sku       = data.azurerm_platform_image.Ubuntu.sku
    version   = data.azurerm_platform_image.Ubuntu.version
  }

  admin_username = "azureuser"

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

}

resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  sku                 = "Standard"
  sku_tier            = "Regional"

  frontend_ip_configuration {
    name                 = "LB-Front-End-IP"
    public_ip_address_id = azurerm_public_ip.lb-public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "LB-BackEnd-Pool"
  depends_on      = [azurerm_lb.lb]
}

resource "azurerm_network_interface_backend_address_pool_association" "lb_backend_association" {
  count                   = 3
  network_interface_id    = azurerm_network_interface.network_interface[count.index].id
  ip_configuration_name   = "${var.prefix}-ipconfig-${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
  depends_on              = [azurerm_lb_backend_address_pool.lb_backend_pool]
}


resource "azurerm_lb_probe" "lb_health_probe" {
  name                = "HTTP-Health-Probe"
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 15
}

resource "azurerm_lb_rule" "lb_rule" {
  name                           = "Allow-HTTP"
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LB-Front-End-IP"

  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_backend_pool.id]
  probe_id                 = azurerm_lb_probe.lb_health_probe.id
  depends_on               = [azurerm_lb.lb]
}




output "azurerm_lb_public_ip" {
  description = "Here is the public IP of the Load Balancer"
  value       = azurerm_public_ip.lb-public_ip.ip_address
}

output "azurerm_vm_public_ips" {
  description = "Here are the public Ips of the virtual machines"
  value       = azurerm_public_ip.vm_public_ips[*].ip_address
}

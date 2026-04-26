resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  }

  resource "azurerm_network_security_rule" "allow_ssh_from_my_ip" {
    name                       = "Allow-SSH-From-MyIP"
    description                = "Allow SSH from my IP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip_address
    destination_address_prefix = "*"
    resource_group_name        = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.nsg.name
  }


resource "azurerm_public_ip" "public_ip" {
  name                = "${var.prefix}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.prefix}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id =  azurerm_network_security_group.nsg.id
}
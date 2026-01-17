resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.lb_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  depends_on           = [azurerm_virtual_network.vnet]
}

resource "azurerm_network_security_group" "allow_ssh_from_my_ip" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  security_rule {
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
  }

  security_rule {
    name                       = "Allow-HTTP"
    description                = "Allow HTTP inbound"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "network_interface" {
  count               = 3
  name                = "lb-vm-${count.index + 1}-nic"
  resource_group_name = azurerm_resource_group.lb_rg.name
  location            = azurerm_resource_group.lb_rg.location

  ip_configuration {
    name                          = "${var.prefix}-ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm-public_ips[count.index].id
  }
  depends_on = [azurerm_subnet.subnet]

}

resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count                     = 3
  network_interface_id      = azurerm_network_interface.network_interface[count.index].id
  network_security_group_id = azurerm_network_security_group.allow_ssh_from_my_ip.id
  depends_on                = [azurerm_network_interface.network_interface]
}


resource "azurerm_public_ip" "vm-public_ips" {
  count               = 3
  name                = "lb-vm-${count.index + 1}-public-ip"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_public_ip" "lb-public_ip" {
  name                = "${var.prefix}-lb-public-ip"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
terraform {
  backend "azurerm" {
    key = "vm-basic/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "vm" {
  source         = "../vm"
  resource_group_name = var.resource_group_name
  location       = var.location
  prefix         = var.prefix
  ssh_key        = file(var.ssh_key)
  my_ip_address  = var.my_ip_address
  admin_username = var.admin_username
  tags           = var.tags
}
terraform {
  backend "azurerm" {
    resource_group_name  = "RG-HAS-TEST"
    storage_account_name = "hasstgtest"
    container_name       = "tf-state-file"
    key                  = "vm-basic/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.sub_id
}


module "vm-basic" {
  source         = "../vm-basic-module"
  sub_id         = var.sub_id
  location       = var.location
  prefix         = var.prefix
  ssh_key        = file(var.ssh_key)
  my_ip_address  = var.my_ip_address
  admin_username = var.admin_username
  tags           = var.tags
}
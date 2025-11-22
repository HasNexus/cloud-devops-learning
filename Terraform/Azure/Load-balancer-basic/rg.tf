resource "azurerm_resource_group" "lb_rg" {
  name     = "${var.prefix}-rg"
  location = var.location
}
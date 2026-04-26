#Creating App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.prefix}-appserviceplan"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku
  tags                = var.tags
}

#Creating Web App with Docker Container 
resource "azurerm_linux_web_app" "webapp" {
  name                          = "${var.prefix}-webapp"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  service_plan_id               = azurerm_service_plan.appserviceplan.id
  public_network_access_enabled = true
  virtual_network_subnet_id     = var.webapp_subnet_id
  identity {
    type = "SystemAssigned"
  }
  site_config {
    always_on = false
    application_stack {
      docker_registry_url = var.docker_registry_url
      docker_image_name   = var.docker_image_name
    }
  }
  depends_on = [azurerm_service_plan.appserviceplan]
  tags       = var.tags
}
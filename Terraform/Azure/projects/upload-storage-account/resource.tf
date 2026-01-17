resource "azurerm_storage_account" "storage_account" {
  name                     = var.stg_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}


resource "azurerm_storage_account_network_rules" "network_rules" {
  storage_account_id = azurerm_storage_account.storage_account.id
  default_action     = "Allow"
  bypass             = ["AzureServices"]
}


resource "azurerm_storage_container" "upload-container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "container"
}

resource "azurerm_storage_blob" "blob_file" {
  name                   = var.blob_name
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = azurerm_storage_container.upload-container.name
  type                   = "Block"
  source                 = "${path.module}/${var.source_file}"
  content_type           = var.content_type
}

output "blob_url" {
  value       = azurerm_storage_blob.blob_file.url
  description = "The URL of the uploaded blob."
}

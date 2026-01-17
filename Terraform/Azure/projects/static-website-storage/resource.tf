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

resource "azurerm_storage_account_static_website" "website" {
  storage_account_id = azurerm_storage_account.storage_account.id
  index_document     = "index.html"
}

data "azurerm_storage_container" "web-container" {
  name               = "$web"
  storage_account_id = azurerm_storage_account.storage_account.id
  depends_on         = [azurerm_storage_account_static_website.website]
}

locals {
  website_files = fileset("${path.module}/${var.source_folder}", "**")

  file_extensions = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    txt  = "text/plain"
    png  = "image/png"
    jpg  = "image/jpeg"
    gif  = "image/gif"
  }
}

resource "azurerm_storage_blob" "website_files" {
  for_each               = local.website_files
  name                   = each.value
  storage_account_name   = azurerm_storage_account.storage_account.name
  storage_container_name = data.azurerm_storage_container.web-container.name
  type                   = "Block"
  source                 = "${path.module}/${var.source_folder}/${each.value}"
  content_type           = lookup(local.file_extensions, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}

output "primary_web_endpoint" {
  value = azurerm_storage_account.storage_account.primary_web_endpoint
}
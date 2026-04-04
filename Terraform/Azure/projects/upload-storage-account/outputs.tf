output "blob_url" {
  value       = azurerm_storage_blob.blob_file.url
  description = "The URL of the uploaded blob."
}

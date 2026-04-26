output "default_hostname" {
  description = "The default domain/url of the webapp"
  value       = azurerm_linux_web_app.webapp.default_hostname
}

output "principal_id" {
  description = "The system-assigned managed identity principal ID of the Web App"
  value       = azurerm_linux_web_app.webapp.identity[0].principal_id
}
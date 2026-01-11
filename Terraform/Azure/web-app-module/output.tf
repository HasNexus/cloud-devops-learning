output "default_hostname" {
  description = "The default domain/url of the webapp"
  value = azurerm_linux_web_app.webapp.default_hostname
}
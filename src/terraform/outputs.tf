output "primary_web_endpoint" {
  value = azurerm_static_site.main.default_host_name
}
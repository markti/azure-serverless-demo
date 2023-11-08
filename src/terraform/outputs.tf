output "frontend_storage_account_name" {
  value = azurerm_storage_account.frontend.name
}
output "function_name" {
  value = azurerm_linux_function_app.github_crawler.name
}
output "resource_group_name" {
  value = azurerm_resource_group.main.name
}
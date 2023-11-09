resource "random_string" "function_storage" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_storage_account" "function" {
  name                     = "st${var.application_name}${var.environment_name}${random_string.function_storage.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "consumption" {
  name                = "asp-${var.application_name}-${var.environment_name}-${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                       = "func-${var.application_name}-${var.environment_name}-${random_string.main.result}"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  service_plan_id            = azurerm_service_plan.consumption.id
  storage_account_name       = azurerm_storage_account.function.name
  storage_account_access_key = azurerm_storage_account.function.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = true
    }
  }

  app_settings = {
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "false"
    "WEBSITE_RUN_FROM_PACKAGE"       = azurerm_storage_blob.deployment_package.url
    "STORAGE_CONNECTION_STRING"      = azurerm_storage_account.function.primary_connection_string
    "QUEUE_CONNECTION_STRING"        = azurerm_storage_account.function.primary_connection_string
  }
}

resource "azurerm_storage_container" "deployment" {
  name                  = "deployments"
  storage_account_name  = azurerm_storage_account.function.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "deployment_package" {

  count = var.zip_deployment_package == null ? 0 : 1

  name                   = "deployment.zip"
  storage_account_name   = azurerm_storage_account.function.name
  storage_container_name = azurerm_storage_container.deployment.name
  type                   = "Block"
  source                 = var.deployment_package

}
##################################################################################
# RANDOM INTEGER
##################################################################################
# Generates a random 5-digit number to use as a unique suffix if needed
resource "random_integer" "name_suffix" {
  min = 10000
  max = 99999
}

##################################################################################
# LOCALS
##################################################################################
# Define common resource names dynamically using input variables
locals {
  resource_group_name   = "rg-${var.application_name}-${var.environment_name}"
  app_service_plan_name = "asp-${var.application_name}-${var.environment_name}"
  app_service_name      = "app-${var.application_name}-${var.environment_name}"
}

##################################################################################
# APP SERVICE
##################################################################################
# Create a resource group for hosting the App Service resources
resource "azurerm_resource_group" "app_service" {
  name     = local.resource_group_name
  location = var.location
}

# Create an App Service Plan (hosting environment) for the web app
resource "azurerm_service_plan" "app_service" {
  name                = local.app_service_plan_name
  location            = azurerm_resource_group.app_service.location
  resource_group_name = azurerm_resource_group.app_service.name
  os_type             = var.os_type
  sku_name            = var.sku_name

}

# Create a Windows-based Azure Web App using the App Service Plan
resource "azurerm_windows_web_app" "app_service" {
  name                = local.app_service_name
  resource_group_name = azurerm_resource_group.app_service.name
  location            = azurerm_resource_group.app_service.location
  service_plan_id     = azurerm_service_plan.app_service.id

  site_config {
    application_stack {
      current_stack = "node"
      node_version  = "~22" # You can change this based on your needs
    }
  }
}

# Connect the Web App to the specified GitHub repo for deployment
resource "azurerm_app_service_source_control" "app_source_control" {
  app_id                 = azurerm_windows_web_app.app_service.id
  repo_url               = "https://github.com/raradhye/cloud-infra-automation"
  branch                 = "main"
  use_manual_integration = true
  use_mercurial          = false
}

#####################################################################################
# RANDOM INTEGER
# Used to generate a unique suffix for the storage account to ensure name uniqueness
#####################################################################################
resource "random_integer" "sa_num" {
  min = 10000
  max = 99999
}
##################################################################################
# LOCALS
# Define reusable naming conventions for resources
##################################################################################
locals {
  resource_group_name    = "rg-${var.application_name}-${var.environment_name}"
  storage_account_name   = "st${lower(var.application_name)}${random_integer.sa_num.result}"
  service_principal_name = "sp-${var.application_name}-${var.environment_name}"
}

##################################################################################
# DATA SOURCES
# Fetch the current subscription and Azure AD client context
##################################################################################
data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}

##################################################################################
# AZURE AD APPLICATION AND SERVICE PRINCIPAL
# Create a service principal with Contributor role assignment
##################################################################################

# Create Azure AD application for GitHub Actions
resource "azuread_application" "gh_actions" {
  display_name = local.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

# Create service principal for the application
resource "azuread_service_principal" "gh_actions" {
  client_id = azuread_application.gh_actions.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Generate a client secret for the service principal
resource "azuread_service_principal_password" "gh_actions" {
  service_principal_id = azuread_service_principal.gh_actions.id
  start_date           = timestamp()
  end_date             = timeadd(timestamp(), "720h") # 720 hours = 30 days
}

# Assign Contributor role to the service principal
resource "azurerm_role_assignment" "gh_actions" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.gh_actions.object_id
}

##################################################################################
# AZURE STORAGE RESOURCES
# Used by Terraform for remote state storage
##################################################################################

# Create resource group
resource "azurerm_resource_group" "setup" {
  name     = local.resource_group_name
  location = var.location
}

# Create storage account for Terraform state
resource "azurerm_storage_account" "sa" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.setup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

# Create a container within the storage account for state files
resource "azurerm_storage_container" "ct" {
  name               = "terraform-state"
  storage_account_id = azurerm_storage_account.sa.id

}

##################################################################################
# GITHUB ACTIONS SECRETS
# Push required secrets to GitHub for use in the CI/CD pipeline
##################################################################################
resource "github_actions_secret" "actions_secret" {
  for_each = {
    STORAGE_ACCOUNT     = azurerm_storage_account.sa.name
    RESOURCE_GROUP      = azurerm_storage_account.sa.resource_group_name
    CONTAINER_NAME      = azurerm_storage_container.ct.name
    ARM_CLIENT_ID       = azuread_service_principal.gh_actions.client_id
    ARM_CLIENT_SECRET   = azuread_service_principal_password.gh_actions.value
    ARM_SUBSCRIPTION_ID = data.azurerm_subscription.current.subscription_id
    ARM_TENANT_ID       = data.azuread_client_config.current.tenant_id
  }

  repository      = var.github_repository
  secret_name     = each.key
  plaintext_value = each.value
}

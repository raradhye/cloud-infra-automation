##################################################################################
# TERRAFORM CONFIG
##################################################################################
terraform {
  # Specifies required providers and their versions
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Azure Resource Manager provider
      version = "~> 4.35.0"         # Ensures compatibility with version 4.35.x
    }
  }
  # Defines the backend configuration for storing Terraform state remotely in Azure
  backend "azurerm" {
    key = "app.terraform.tfstate" # Name of the state file in the backend storage container
  }
}

##################################################################################
# PROVIDERS
##################################################################################

# Configures the Azure provider with default features
provider "azurerm" {
  features {} # Enables all default AzureRM provider features
}

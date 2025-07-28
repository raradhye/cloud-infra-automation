#############################################################################
# VARIABLES
#############################################################################

# Azure region where resources will be deployed.
variable "location" {
  type    = string
  default = "westus3"
}

# Logical name used to identify the application.
# Used in naming conventions for Azure resources.
variable "application_name" {
  type    = string
  default = "cloudinfra"
}

# Environment name (e.g., dev, test, prod) to help isolate resources.
variable "environment_name" {
  type    = string
  default = "dev"
}
# Operating system type for the App Service (e.g., Windows or Linux).
variable "os_type" {
  type    = string
  default = "Windows"
}
# SKU tier for the App Service Plan (e.g., B1, S1, P1v2).
# Determines pricing and performance characteristics.
variable "sku_name" {
  type    = string
  default = "S1"
}

#############################################################################
# VARIABLES
#############################################################################

# Azure region where resources will be deployed
variable "location" {
  type    = string
  default = "westus3"
}

# Base name of the application used in naming resources
variable "application_name" {
  type    = string
  default = "cloudinfra"
}

# Environment identifier (e.g., dev, test, prod) used in resource names
variable "environment_name" {
  type    = string
  default = "setup"
}

# GitHub repository name used for deploying secrets and integrating source control
variable "github_repository" {
  type    = string
  default = "cloud-infra-automation"
}

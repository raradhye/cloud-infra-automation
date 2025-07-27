#############################################################################
# VARIABLES
#############################################################################

variable "location" {
  type    = string
  default = "westus3"
}

variable "application_name" {
  type    = string
  default = "cloudinfra"
}

variable "environment_name" {
  type    = string
  default = "setup"
}

variable "github_repository" {
  type    = string
  default = "cloud-infra-automation"
}

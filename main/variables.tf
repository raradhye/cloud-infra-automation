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
  default = "dev"
}
variable "os_type" {
  type    = string
  default = "Windows"
}
variable "sku_name" {
  type    = string
  default = "B1"
}

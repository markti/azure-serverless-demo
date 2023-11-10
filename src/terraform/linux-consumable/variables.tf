variable "application_name" {
  type = string
}
variable "environment_name" {
  type = string
}
variable "primary_region" {
  type = string
}
variable "function_app_sku" {
  type = string
}
variable "function_app_os_type" {
  type = string
}
variable "zip_deployment_package" {
  type    = string
  default = null
}
variable "environment" {
  type = string
}
variable "subscription_id" {
  type = string
}
variable "resource_group" {
  type = any
}

variable "dev_center_project_resource_id" {
  type = string
}
variable "azure_devops_organization_name" {
  type = string
}

variable "version_control_system_type" {
  type    = string
  default = "AzureDevOps"
}

variable "fabric_profile_sku_name" {
  type    = string
  default = "Standard_B1s"
}

variable "maximum_concurrency" {
  type = number 
}

variable "subnet_id" {
  type    = string
  default = null
}


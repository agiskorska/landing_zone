variable "environment_info" {
  description = "A map of environment information."
  type        = map(object({
    resource_group_name = string
    location            = string
    maximum_concurrency = number
    subscription_id     = string
    tags                = map(string)
  }))
}

variable "azure_devops_organization_name" {
  type        = string
  description = "Azure DevOps Organisation Name"
}

variable "service_principal_id" {
  type        = string
  description = "Service Principal ID"
}
variable "tenant_id" {
  type        = string
  description = "Tenant ID"
  
}
variable "service_principal_secret" {
  type        = string
  description = "Service Principal Secret"
}
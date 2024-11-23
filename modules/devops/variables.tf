variable "resource_group" {
  type      = any
}

variable "env" {
  type      = string
}

variable "tags" {
  type      = map(string)
}

variable "subscription_name" {
  type      = string
}

variable "service_principal_id" {
  type      = string
}

variable "service_principal_secret" {
  type      = string
}
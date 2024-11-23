terraform {
  
  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
    }
  }
}

data "azurerm_subscription" "current" {
}

resource "azurerm_dev_center" "this" {
  name                = "devcenter-${var.env}"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  tags                = var.tags
}

resource "azurerm_dev_center_project" "this" {
  dev_center_id       = azurerm_dev_center.this.id
  location            = var.resource_group.location
  name                = "proj-fizzbuzz-${var.env}"
  resource_group_name = var.resource_group.name
}

resource "azurerm_user_assigned_identity" "this" {
  location            = var.resource_group.location
  name                = "mi-${var.env}"
  resource_group_name = var.resource_group.name
}

resource "azuredevops_agent_pool" "this" {
  name                = "agent-pool-${var.env}"
  auto_provision = false
  auto_update    = false
}

data "azuredevops_project" "fizzbuzz" {
  name               = "fizzbuzz"
}

resource "azuredevops_serviceendpoint_azurerm" "example" {
  project_id                             = data.azuredevops_project.fizzbuzz.id
  service_endpoint_name                  = "DEPLOYMENT-${upper(var.env)}"
  description                            = "Managed by Terraform"
  service_endpoint_authentication_scheme = "ServicePrincipal"
  credentials {
    serviceprincipalid  = var.service_principal_id
    serviceprincipalkey = var.service_principal_secret
  }
  azurerm_spn_tenantid      = data.azurerm_subscription.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

output "dev_center" {
  value = azurerm_dev_center.this
}

output "dev_center_project" {
  value = azurerm_dev_center_project.this
}

output "managed_identity" {
  value = azurerm_user_assigned_identity.this
}

output "agent_pool" {
  value = azuredevops_agent_pool.this
}
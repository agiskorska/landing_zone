terraform {
  required_version = ">= 1.9"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.14"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = ">= 1.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id = "be21f1da-36c6-4f69-9b2f-56f0a3de3cda"
  features {}
}
provider "azuredevops" {
  org_service_url= "https://dev.azure.com/${var.azure_devops_organization_name}"
  client_id=var.service_principal_id
  tenant_id=var.tenant_id
  client_secret=var.service_principal_secret
}


# az ad sp create-for-rbac --name fb-deployment-np --role contributor --scopes /subscriptions/your-subscription-id

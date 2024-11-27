resource "azurerm_user_assigned_identity" "this" {
  location            = var.resource_group.location
  name                = "mi-${var.environment}"
  resource_group_name = var.resource_group.name
}

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.1.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.14"
    }
  }

}
locals {
  location = "uksouth"
  organizations = [
    { 
      url = "https://dev.azure.com/${var.azure_devops_organization_name}"
      parallelism = 1 
    }
  ]
  permissionProfile = { kind = "CreatorOnly" }

  images = [
    {
      resource_id = "/Subscriptions/${var.subscription_id}/Providers/Microsoft.Compute/Locations/${local.location}/Publishers/MicrosoftWindowsServer/ArtifactTypes/VMImage/Offers/WindowsServer/Skus/2019-Datacenter/versions/latest"
      buffer = "*"
    },
    {
      resource_id = "/Subscriptions/${var.subscription_id}/Providers/Microsoft.Compute/Locations/${local.location}/Publishers/canonical/ArtifactTypes/VMImage/Offers/0001-com-ubuntu-server-focal/Skus/20_04-lts-gen2/versions/latest"
      buffer = "*"
    }
  ]
}

resource "azapi_resource" "managed_devops_pool" {
  type = "Microsoft.DevOpsInfrastructure/pools@2024-10-19"
  body = {
    properties = {
      devCenterProjectResourceId = var.dev_center_project_resource_id
      maximumConcurrency         = var.maximum_concurrency
      organizationProfile = {
        kind              = var.version_control_system_type
        organizations     = local.organizations
        permissionProfile = local.permissionProfile
      }

      agentProfile = {kind = "Stateless"}

      fabricProfile = {
        storageProfile = {
          dataDisks = [
            {
              caching = "None"
              diskSizeGiB = 1
              storageAccountType = "Standard_LRS"
            }
          ]
          osDiskStorageAccountType = "Standard"
        }
        sku = {
          name = var.fabric_profile_sku_name
        }
        images = [for image in local.images : {
          resourceId         = image.resource_id
        }]

        networkProfile = var.subnet_id != null ? {
          subnetId = var.subnet_id
        } : null
        osProfile = {
          logonType = "Service"
        }

        kind = "Vmss"
      }
    }
  }
  location                  = "uksouth"  # Cannot be west europe
  name                      = "ba-${var.environment}-deployment"
  parent_id                 = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group.name}"
  schema_validation_enabled = false
  # tags                      = each.value.tags

  identity {

      type         = "UserAssigned"
      identity_ids = [azurerm_user_assigned_identity.this.id]
    }
}

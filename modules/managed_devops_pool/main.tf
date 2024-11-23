variable "environment_info" {
    type = map(object({
        maximum_concurrency = number
        location            = string
        subscription_id     = string
        tags                = map(string)
    }))
}

variable "version_control_system_type" {
    type    = string
    default = "AzureDevOps"
}

variable "fabric_profile_sku_name" {
    type    = string
    default = "Standard_DS2_v2"
}

variable "fabric_profile_images" {
    type = list(object({
        well_known_image_name = string
        aliases               = list(string)
        buffer                = string
        resource_id           = string
    }))
}

variable "subnet_id" {
    type    = string
    default = null
}

variable "fabric_profile_os_disk_storage_account_type" {
    type    = string
    default = "Standard_LRS"
}

variable "fabric_profile_data_disks" {
    type = list(object({
        disk_size_gigabytes   = number
        caching               = string
        drive_letter          = string
        storage_account_type  = string
    }))
}
variable "agent_profile" {
    type = object({
        name     = string
        version  = string
        pool_id  = string
        pool_name = string
    })
}
resource "azapi_resource" "managed_devops_pool" {
  type = "Microsoft.DevOpsInfrastructure/pools@2024-10-19"
  for_each = var.environment_info
  body = {
    properties = {
      devCenterProjectResourceId = azurerm_dev_center_project[each.key].id
      maximumConcurrency         = each.value.maximum_concurrency
      organizationProfile = {
        kind              = var.version_control_system_type
        organizations     = local.organization_profile.organizations
        permissionProfile = local.organization_profile.permission_profile
      }

      agentProfile = var.agent_profile

      fabricProfile = {
        sku = {
          name = var.fabric_profile_sku_name
        }
        images = [for image in var.fabric_profile_images : {
          wellKnownImageName = image.well_known_image_name
          aliases            = image.aliases
          buffer             = image.buffer
          resourceId         = image.resource_id
        }]

        networkProfile = var.subnet_id != null ? {
          subnetId = var.subnet_id
        } : null
        osProfile = {
          logonType = "Service"
        }
        storageProfile = {
          osDiskStorageAccountType = var.fabric_profile_os_disk_storage_account_type
          dataDisks = [for data_disk in var.fabric_profile_data_disks : {
            diskSizeGiB        = data_disk.disk_size_gigabytes
            caching            = data_disk.caching
            driveLetter        = data_disk.drive_letter
            storageAccountType = data_disk.storage_account_type
          }]
        }
        kind = "Vmss"
      }
    }
  }
  location                  = each.value.location
  name                      = "ba-${each.key}-deployment"
  parent_id                 = "/subscriptions/${each.value.subscription_id}/resourceGroups/${azure_resource_group.this[each.key].name}/providers/Microsoft.DevOpsInfrastructure/pools/${each.key}"
  schema_validation_enabled = false
  tags                      = each.value.tags

  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned

    content {
      type         = azurerm_managed_identity.this[each.key].type
      identity_ids = azurerm_managed_identity.this[each.key].user_assigned_resource_ids
    }
  }
}

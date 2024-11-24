resource "azurerm_resource_group" "this" {
  for_each = var.environment_info
  name     = each.value.resource_group_name
  location = each.value.location
  tags     = each.value.tags
}
module "devops" {
  source = "./modules/devops"
  for_each = var.environment_info
  resource_group = azurerm_resource_group.this[each.key]
  tags = each.value.tags
  env = each.key
  service_principal_id = var.service_principal_id
  service_principal_secret = var.service_principal_secret
}
module "managed_devops_pool" {
  source = "./modules/managed_devops_pool"
  for_each = var.environment_info
  resource_group = azurerm_resource_group.this[each.key]
  subscription_id = each.value.subscription_id
  environment = each.key
  dev_center_project_resource_id = module.devops[each.key].dev_center_project.id
  maximum_concurrency = each.value.maximum_concurrency
  azure_devops_organization_name= var.azure_devops_organization_name
}

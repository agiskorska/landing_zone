
resource "azurerm_resource_group" "current" {
  name     = "rg-dev-fizz-buzz"
  location = "West Europe"
}

resource "azurerm_virtual_network" "base" {
  name                = "vnetfizzbuzz"
  resource_group_name = azurerm_resource_group.current.name
  location            = azurerm_resource_group.current.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_container_registry" "acr" {
  name                = "acrfizzbuzz"
  resource_group_name = azurerm_resource_group.current.name
  location            = azurerm_resource_group.current.location
  sku                 = "Standard"
  admin_enabled       = false
}
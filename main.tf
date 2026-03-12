provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cr460-laurieanne"
  location = "Canada Central"
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cr460-laurieanne"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

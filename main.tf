provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cr460-laurieanne"
  location = "Canada Central"
}
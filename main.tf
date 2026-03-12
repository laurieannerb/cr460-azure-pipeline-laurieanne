provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-cr460-laurieanne"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-cr460-laurieanne"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-cr460-laurieanne"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-cr460-laurieanne"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-cr460-laurieanne"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size = "Standard_D2s_v3"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_password                  = "LaurieAnne1234!"
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
resource "azurerm_container_group" "container" {
  name                = "aci-cr460-laurieanne"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Public"
  dns_name_label      = "aci-laurieanne-cr460"
  os_type             = "Linux"

  container {
    name   = "nginx"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  exposed_port {
    port     = 80
    protocol = "TCP"
  }
}
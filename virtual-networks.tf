resource "azurerm_virtual_network" "vnet_name" {
  name                = var.vnet_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address-space

  ddos_protection_plan {
    enable = true
    id     = azurerm_network_ddos_protection_plan.vnet_ddos_plan.id
  }
  tags = var.tags

}

resource "azurerm_subnet" "snet_1" {
  name                 = var.snet_1_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_1_address_space

  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_subnet" "snet_2" {
  name                 = var.snet_2_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_2_address_space

    delegation {
      name = "dlg-Microsoft.DBforPostgreSQL-flexibleServers"
      service_delegation {
        actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      }
    }

  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_subnet" "snet_3" {
  name                 = var.snet_3_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_3_address_space
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_subnet" "snet_4" {
  name                 = var.snet_4_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_4_address_space
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_subnet" "snet_5" {
  name                 = var.snet_5_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_5_address_space
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_subnet" "snet_6" {
  name                 = var.snet_6_name
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.snet_6_address_space
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}

resource "azurerm_virtual_network_peering" "sub1_to_sub2" {
  provider                     = azurerm.sub_hub
  name                         = var.sub1_to_sub2_name
  resource_group_name          = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  virtual_network_name         = data.azurerm_virtual_network.vnet-cus-hub.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet_name.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
}

resource "azurerm_virtual_network_peering" "sub2_to_sub1" {
  name                         = var.sub2_to_sub1_name
  resource_group_name          = data.azurerm_resource_group.rg_name.name
  virtual_network_name         = data.azurerm_virtual_network.vnet_name.name
  remote_virtual_network_id    = data.azurerm_virtual_network.vnet-cus-hub.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

resource "azurerm_network_ddos_protection_plan" "vnet_ddos_plan" {
  name                = var.vnet_ddos_plan
  resource_group_name = data.azurerm_resource_group.rg_name.name
  location            = var.rg_location
  tags                = var.tags
  depends_on = [
    azurerm_resource_group.rg_name
  ]
}

#NSG
resource "azurerm_network_security_group" "example_nsg" {
  name                = var.snet_nsg_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  security_rule {
    name                       = "example-rule"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = var.tags
  depends_on = [
    azurerm_virtual_network.vnet_name,
    azurerm_subnet.snet_1,
    azurerm_resource_group.rg_name
  ]
}

# subnet-nsg-allocation

resource "azurerm_subnet_network_security_group_association" "snet_1_nsg_association" {
  subnet_id                 = data.azurerm_subnet.snet_1.id
  network_security_group_id = azurerm_network_security_group.example_nsg.id
  depends_on = [
    azurerm_network_security_group.example_nsg
  ]
}

resource "azurerm_nat_gateway" "example" {
  name                    = var.nat_gateway_name
  location                = data.azurerm_resource_group.rg_name.location
  resource_group_name     = data.azurerm_resource_group.rg_name.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}
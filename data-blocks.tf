### Hub data resources ####
# data source for resource group
data "azurerm_resource_group" "rg-mcr-hub-cus-001" {
  name     = "rg-mcr-hub-cus-001"
  provider = azurerm.sub_hub
}


data "azurerm_virtual_network" "vnet-cus-hub" {
  name                = "vnet-cus-hub"
  provider            = azurerm.sub_hub
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
}

data "azurerm_subnet" "snet-hub-acr-01-cus" {
  name                 = "snet-hub-acr-01-cus"
  virtual_network_name = data.azurerm_virtual_network.vnet-cus-hub.name
  resource_group_name  = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider             = azurerm.sub_hub
}


data "azurerm_subnet" "snet-hub-mgmt-01-cus" {
  name                 = "snet-hub-mgmt-01-cus"
  virtual_network_name = data.azurerm_virtual_network.vnet-cus-hub.name
  resource_group_name  = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider             = azurerm.sub_hub
}


data "azurerm_subnet" "snet-hub-appgw-01-cus" {
  name                 = "snet-hub-appgw-01-cus"
  virtual_network_name = data.azurerm_virtual_network.vnet-cus-hub.name
  resource_group_name  = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider             = azurerm.sub_hub
}


data "azurerm_application_gateway" "appgateway" {
  name                = "agw-mi-prod-cus-001"
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider            = azurerm.sub_hub
  depends_on = [
    azurerm_application_gateway.appgateway
  ]
}

// UAT environment data blocks
data "azurerm_resource_group" "rg_name" {
  name = "rg-mi-prod-cus-001"
  #provider = azurerm.sub_cvs_uat
  depends_on = [
    azurerm_resource_group.rg_name
  ]
}
#
data "azurerm_virtual_network" "vnet_name" {
  name                = "vnet-mi-prod-cus-001"
  resource_group_name = data.azurerm_resource_group.rg_name.name
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name
  ]
}
#
data "azurerm_subnet" "snet_1" {
  name                 = "snet-mi-prod-app-cus-001"
  virtual_network_name = data.azurerm_virtual_network.vnet_name.name
  resource_group_name  = data.azurerm_resource_group.rg_name.name
  #   provider = azurerm.sub_pt
  depends_on = [
    azurerm_virtual_network.vnet_name,
    azurerm_resource_group.rg_name
  ]
}

data "azurerm_subnet" "snet_2" {
  name                 = "snet-mi-prod-db-cus-001"
  virtual_network_name = data.azurerm_virtual_network.vnet_name.name
  resource_group_name  = data.azurerm_resource_group.rg_name.name
  #   provider = azurerm.sub_pt
  depends_on = [
    azurerm_virtual_network.vnet_name,
    azurerm_resource_group.rg_name
  ]
}

data "azurerm_container_registry" "acrmcrcusprod" {
  provider            = azurerm.sub_hub
  name                = "acrmcrcusprod"
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
}


data "azurerm_client_config" "subscription_info" {
  # subscription_id = "0ad29408-aca3-4ccf-be27-b6bef32c99de"
  # tenant_id = "86140b50-6e23-4b67-b7fb-4e23fdd33901"
}

data "azurerm_log_analytics_workspace" "law-cus-mcr-hub-001" {
  name                = "law-cus-mcr-hub-001"
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider            = azurerm.sub_hub
}

data "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.centralus.azmk8s.io"
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  provider = azurerm.sub_hub
}
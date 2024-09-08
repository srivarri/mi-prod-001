resource "azurerm_resource_group" "rg_name" {
  name     = var.rg_name
  location = var.rg_location
  //provider = azurerm.sub_pt
  tags = var.tags
}
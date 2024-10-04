resource "azurerm_network_interface" "example_nic1" {
  name                = var.keycloak_vm1_nic1
  location            = data.azurerm_resource_group.rg_name.location
  resource_group_name = data.azurerm_resource_group.rg_name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.snet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example_vm1" {
  name                  = var.keycloak_vm1_name
  resource_group_name   = data.azurerm_resource_group.rg_name.name
  location              = data.azurerm_resource_group.rg_name.location
  size                  = "Standard_E2ads_v5"
  admin_username        = "mcradmin"
  admin_password        = "Med!L0ck2024#"  # Change to a strong password or use a more secure method to handle credentials.
  network_interface_ids = [
    azurerm_network_interface.example_nic1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_network_interface.example_nic1,
    azurerm_resource_group.rg_name,
    azurerm_subnet.snet_1
  ]
  tags = {
    "Created By"  = "Surendra/Sri"
    "Environment" = "MCR PROD"
    "Owner name"  = "@Gali Muralidhar"
  }
}

# VM2
resource "azurerm_network_interface" "example_nic2" {
  name                = var.keycloak_vm2_nic1
  location            = data.azurerm_resource_group.rg_name.location
  resource_group_name = data.azurerm_resource_group.rg_name.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.snet_1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example_vm2" {
  name                  = var.keycloak_vm2_name
  resource_group_name   = data.azurerm_resource_group.rg_name.name
  location              = data.azurerm_resource_group.rg_name.location
  size                  = "Standard_E2ads_v5"
  admin_username        = "mcradmin"
  admin_password        = "Med!L0ck2024#"  # Change to a strong password or use a more secure method to handle credentials.

  network_interface_ids = [
    azurerm_network_interface.example_nic2.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.example_nic1,
    azurerm_resource_group.rg_name,
    azurerm_subnet.snet_1
  ]
  tags = var.tags
}
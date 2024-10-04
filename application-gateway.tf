# Subscription ID is required for AGIC
# Application Gateway
locals {
  backend_address_pool_name      = "${var.vnet_name}-beap"
  frontend_port_name             = "${var.vnet_name}-feport"
  frontend_ip_configuration_name = "${var.vnet_name}-feip"
  http_setting_name              = "${var.vnet_name}-be-htst"
  http_listener_name             = "${var.vnet_name}-httplstn"
  request_routing_rule_name      = "${var.vnet_name}-rqrt"
}

# Public IP
resource "azurerm_public_ip" "appgwpublic_ip" {
  name                = var.APPGW_PUBLIC_IP_NAME
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  location            = data.azurerm_resource_group.rg-mcr-hub-cus-001.location
  allocation_method   = "Static"
  sku                 = "Standard"
  #domain_name_label   = var.domain_name_label # Maps to <domain_name_label>.<region>.cloudapp.azure.com
  provider = azurerm.sub_hub
}

# Application gateway
resource "azurerm_application_gateway" "appgateway" {
  name                = var.APP_GATEWAY_NAME
  resource_group_name = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
  location            = data.azurerm_resource_group.rg-mcr-hub-cus-001.location

  zones = ["1","2","3"]

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = data.azurerm_subnet.snet-hub-appgw-01-cus.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }
  frontend_port {
    name = "httpsPort"
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgwpublic_ip.id
  }

  ssl_certificate {
    name = "mpp-2024"
    key_vault_secret_id = data.azurerm_key_vault_certificate.example.secret_id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = "100"
  }
  depends_on = [azurerm_public_ip.appgwpublic_ip]

  provider = azurerm.sub_hub

    lifecycle {
      ignore_changes = [
        tags,
        backend_address_pool,
        backend_http_settings,
        probe,
        identity,
        request_routing_rule,
        url_path_map,
        frontend_port,
        http_listener,
        redirect_configuration
      ]
    }

  tags = var.tags
}
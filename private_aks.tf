
### Identity
resource "azurerm_user_assigned_identity" "medadv360-terraform-app" {
  name                = "medadv360-terraform-app"
  resource_group_name = data.azurerm_resource_group.rg_name.name
  location            = data.azurerm_resource_group.rg_name.location
}
### Identity role assignment
resource "azurerm_role_assignment" "dns_contributor" {
  scope = data.azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.medadv360-terraform-app.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = data.azurerm_virtual_network.vnet_name.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.medadv360-terraform-app.principal_id
}

resource "azurerm_role_assignment" "Aks-AcrPull" {
  scope                = data.azurerm_container_registry.acrmcrcusprod.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.akscluster.kubelet_identity.0.object_id
}
resource "azurerm_role_assignment" "app-gw-contributor" {
  scope                = data.azurerm_application_gateway.appgateway.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
resource "azurerm_role_assignment" "appgw-contributor" {
  scope                = data.azurerm_subnet.snet-hub-appgw-01-cus.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_kubernetes_cluster.akscluster.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

## AKS cluster creation
resource "azurerm_kubernetes_cluster" "akscluster" {
  name                    = var.AKS_NAME
  location                = data.azurerm_resource_group.rg_name.location
  resource_group_name     = data.azurerm_resource_group.rg_name.name
  kubernetes_version      = var.kubernetes_version
  dns_prefix              = var.DNS_PREFIX
  private_cluster_enabled = var.private_cluster_enabled
  #automatic_channel_upgrade = var.automatic_channel_upgrade
  sku_tier             = var.sku_tier
  azure_policy_enabled = var.azure_policy_enabled
  private_dns_zone_id  = data.azurerm_private_dns_zone.aks.id
  #local_account_disabled = enabled

  default_node_pool {
    name           = var.default_node_pool_name
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = data.azurerm_subnet.snet_1.id
    zones          = var.default_node_pool_availability_zones
    auto_scaling_enabled    = true
    host_encryption_enabled = false
    node_public_ip_enabled  = true
    max_pods                = var.default_node_pool_max_pods
    max_count               = var.default_node_pool_max_count
    min_count               = var.default_node_pool_min_count
    node_count              = var.default_node_pool_node_count
    os_disk_type            = var.default_node_pool_os_disk_type
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }
  linux_profile {
    admin_username = var.admin_username
    ssh_key {
      key_data = var.SSH_PUBLIC_KEY
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.medadv360-terraform-app.id]
  }
  ingress_application_gateway {
    gateway_id = data.azurerm_application_gateway.appgateway.id
  }
  azure_active_directory_role_based_access_control {
    #  managed            = true
    azure_rbac_enabled = true
    tenant_id          = var.tenant_id
  }
  network_profile {
    dns_service_ip    = var.network_dns_service_ip
    network_plugin    = var.network_plugin
    service_cidr      = var.network_service_cidr
    load_balancer_sku = "standard"
  }

  oms_agent {
    msi_auth_for_monitoring_enabled = true
    log_analytics_workspace_id      = data.azurerm_log_analytics_workspace.law-cus-mcr-hub-001.id
  }

  microsoft_defender {
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law-cus-mcr-hub-001.id
  }

  depends_on = [
    azurerm_role_assignment.network_contributor,
    azurerm_role_assignment.dns_contributor
  ]

  lifecycle {
    ignore_changes = [
      default_node_pool
    ]
  }
  tags = var.tags
}

# Create Linux Azure AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  kubernetes_cluster_id   = azurerm_kubernetes_cluster.akscluster.id
  name                    = var.user_linux_node_pool_name
  mode                    = var.user_node_pool_mode
  vm_size                 = var.default_node_pool_vm_size
  vnet_subnet_id          = data.azurerm_subnet.snet_1.id
  zones                   = var.default_node_pool_availability_zones
  auto_scaling_enabled    = true
  host_encryption_enabled = false
  node_public_ip_enabled  = false
  max_pods                = var.default_node_pool_max_pods
  max_count               = var.default_node_pool_max_count
  min_count               = var.default_node_pool_min_count
  node_count              = var.default_node_pool_node_count
  os_disk_type            = var.default_node_pool_os_disk_type
  #temporary_name_for_rotation = "nodepoolrotation"
  node_labels = {
    "nodepool-type" = var.user_node_pool_mode
    "environment"   = var.environment
    "nodepoolos"    = "linux"
    "app"           = "user-apps"
  }
  depends_on = [
    azurerm_resource_group.rg_name,
    azurerm_virtual_network.vnet_name,
  ]
  tags = var.tags
}
#
# resource "azurerm_private_dns_zone_virtual_network_link" "pdzvnl-aks-mgmt" {
#   name                  = var.aks_private_link_name
#   resource_group_name   = data.azurerm_resource_group.rg-mcr-hub-cus-001.name
#   private_dns_zone_name = data.azurerm_private_dns_zone.aks.name
#   virtual_network_id    = data.azurerm_virtual_network.vnet_name.id
#   registration_enabled = true
#   provider = azurerm.sub_hub
#   tags = var.tags
# }

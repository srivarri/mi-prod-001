variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}

variable "vnet_name" {}
variable "vnet_address-space" {}
variable "vnet_ddos_plan" {}

variable "snet_rt" {}

variable "snet_1_name" {}
variable "snet_1_address_space" {}
variable "snet_1_nsg" {}

variable "snet_2_name" {}
variable "snet_2_address_space" {}
variable "snet_2_nsg" {}

variable "snet_3_name" {}
variable "snet_3_address_space" {}
variable "snet_3_nsg" {}

variable "snet_4_name" {}
variable "snet_4_address_space" {}
variable "snet_4_nsg" {}

variable "snet_5_name" {}
variable "snet_5_address_space" {}
variable "snet_5_nsg" {}

variable "snet_6_name" {}
variable "snet_6_address_space" {}
variable "snet_6_nsg" {}

variable "sub1_to_sub2_name" {}
variable "sub2_to_sub1_name" {}
#
variable "APP_GATEWAY_NAME" {}
variable "APPGW_PUBLIC_IP_NAME" {}

variable "nat_gateway_name" {}
#
# variable "redis_cache_name" {}
variable "tags" {
  type = map(string)
}

# # variables.tf
# # variable "created_date" {
# #   description = "The created date of the resource."
# #   type        = string
# # #   default     = timestamp()
# # }
#
# # NSG Name
variable "snet_nsg_name" {}
#
# # tenant_id
variable "tenant_id" {}
#
# # keycloak variables
variable "keycloak_vm1_nic1" {}
variable "keycloak_vm2_nic1" {}
variable "keycloak_vm1_name" {}
variable "keycloak_vm2_name" {}
#
# # AKS Private DNS zone link variable
variable "private_link_name" {}
variable "AKS_NAME" {
  description = "(Required) Specifies the name of the AKS cluster."
  type        = string
}

variable "RESOURCE_GROUP_NAME" {
  description = "(Required) Specifies the name of the resource group."
  type        = string
}

variable "LOCATION" {
  description = "(Required) Specifies the location where the AKS cluster will be deployed."
  type        = string

}
variable "DNS_PREFIX" {
  description = "(Optional) DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
  type        = string
}

variable "private_cluster_enabled" {
  description = "Should this Kubernetes Cluster have its API server only exposed on internal IP addresses? This provides a Private IP Address for the Kubernetes API on the Virtual Network where the Kubernetes Cluster is located. Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}

variable "automatic_channel_upgrade" {
  description = "(Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, and stable."
  type        = string

  validation {
    condition     = contains(["patch", "rapid", "stable"], var.automatic_channel_upgrade)
    error_message = "The upgrade mode is invalid."
  }
}

variable "sku_tier" {
  description = "(Optional) The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  type        = string

  validation {
    condition     = contains(["Free", "Paid", "Standard"], var.sku_tier)
    error_message = "The sku tier is invalid."
  }
}
variable "kubernetes_version" {
  description = "Specifies the AKS Kubernetes version"
  type        = string
}

variable "azure_policy_enabled" {
  description = "(Optional) Should the Azure Policy Add-On be enabled? For more details please visit Understand Azure Policy for Azure Kubernetes Service"
  type        = bool
}
variable "default_node_pool_name" {
  description = "Specifies the name of the default node pool"
  type        = string
}

variable "default_node_pool_vm_size" {
  description = "Specifies the vm size of the default node pool"
  type        = string
}
#
#
# /*
# variable "pod_subnet_id" {
#   description = "(Optional) The ID of the Subnet where the pods in the default Node Pool should exist. Changing this forces a new resource to be created."
#   type        = string
#   default     = null
# }
# */
variable "default_node_pool_enable_auto_scaling" {
  description = "(Optional) Whether to enable auto-scaler. Defaults to false."
  type        = bool
}
variable "default_node_pool_availability_zones" {
  description = "Specifies the availability zones of the default node pool"
  type        = list(string)
}
variable "default_node_pool_enable_host_encryption" {
  description = "(Optional) Should the nodes in this Node Pool have host encryption enabled? Defaults to false."
  type        = bool
}
variable "default_node_pool_enable_node_public_ip" {
  description = "(Optional) Should each node have a Public IP Address? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
}
variable "default_node_pool_max_pods" {
  description = "(Optional) The maximum number of pods that can run on each agent. Changing this forces a new resource to be created."
  type        = number
}
variable "default_node_pool_os_disk_type" {
  description = "(Optional) The type of disk which should be used for the Operating System. Possible values are Ephemeral and Managed. Defaults to Managed. Changing this forces a new resource to be created."
  type        = string
}

variable "default_node_pool_max_count" {
  description = "(Required) The maximum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be greater than or equal to min_count."
  type        = number
}

variable "default_node_pool_min_count" {
  description = "(Required) The minimum number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be less than or equal to max_count."
  type        = number
}

variable "default_node_pool_node_count" {
  description = "(Optional) The initial number of nodes which should exist within this Node Pool. Valid values are between 0 and 1000 and must be a value in the range min_count - max_count."
  type        = number
}

variable "admin_username" {
  description = "(Required) Specifies the Admin Username for the AKS cluster worker nodes. Changing this forces a new resource to be created."
  type        = string
}

variable "SSH_PUBLIC_KEY" {
  description = "(Required) Specifies the SSH public key used to access the cluster. Changing this forces a new resource to be created."
  type        = string
}


variable "network_dns_service_ip" {
  description = "Specifies the DNS service IP"
  type        = string
}

variable "network_service_cidr" {
  description = "Specifies the service CIDR"
  type        = string
}

variable "network_plugin" {
  description = "Specifies the network plugin of the AKS cluster"
  type        = string
}

variable "role_based_access_control_enabled" {
  description = "(Required) Is Role Based Access Control Enabled? Changing this forces a new resource to be created."
  type        = bool
}
variable "user_linux_node_pool_name" {
  description = "Specifies the name of the default node pool"
  type        = string
}
variable "user_win_node_pool_name" {
  description = "Specifies the name of the default node pool"
  type        = string
}
variable "user_node_pool_mode" {
  description = "Specifies the mode of the default node pool"
  type        = string
}
variable "environment" {
  description = "Specifies the name of the environment"
  type        = string
}

//
variable "hub_subscription_id" {
  description = "The subscription ID for the ACR"
  type        = string
}
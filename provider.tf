terraform {
  backend "azurerm" {
    resource_group_name  = "rg-mi-prod-tf-cus-001" # Resource group where the Storage Account is located
    storage_account_name = "sacusmiprodtfstate001"    # Your Storage Account name
    container_name       = "tfstate"               # The container name where the state file will be stored
    key                  = "mi-prod.terraform.tfstate" # The name of the state file
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.1.0"
    }
  }
}

# Provider for the primary subscription where the Private DNS Zone will be created
provider "azurerm" {
  subscription_id = "77941aea-1322-40f8-8aaf-bcf9fa847a12"
  features {}
}

# Provider for the secondary subscription where the VNets or subnets are located
provider "azurerm" {
  alias           = "sub_hub"
  subscription_id = "9ef97c0c-347f-4ece-9853-171a190c884e"
  features {}
}

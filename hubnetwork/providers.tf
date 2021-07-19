# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_connectivity
}

provider "azurerm" {
  features {}
  alias           = "connectivity"
  subscription_id = var.subscription_id_connectivity
}

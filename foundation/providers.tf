# Configure Terraform to set the required AzureRM provider
# version and features{} block.

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.0"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
      version = ">= 1.2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = ">= 2.1.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id  = "${var.subscription_id_management}"
  }
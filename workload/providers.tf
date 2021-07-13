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
  subscription_id  = "1f5f58f7-720c-4415-8107-78676ebfed76"
}

provider "azurerm" {
  features {}
  alias = "management"
  subscription_id  = "1f5f58f7-720c-4415-8107-78676ebfed76"
}

provider "azurerm" {
  features {}
  alias = "identity"
  subscription_id  = "8a0c94ac-a4c3-4f80-9a2f-22ed50121311"
}

provider "azurerm" {
  features {}
  alias = "connectivity"
  subscription_id  = "919c6905-c73b-40c1-bb1f-8d5c5e92d49e"
}

provider "azurerm" {
  features {}
  alias = "workload"
  subscription_id  = "8acd127d-6946-4b0f-a453-4f4aed1c5bc2"
}
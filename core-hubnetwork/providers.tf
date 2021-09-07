terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.46.0"
      configuration_aliases = [ azurerm.connectivity ]
    }
  }
}
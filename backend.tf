terraform {
  backend "azurerm" {
    resource_group_name  = "eslzmg-state"
    storage_account_name = "eslzmgstate01"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
    subscription_id      = "1234567890"
  }
}
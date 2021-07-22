# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "hub_rg" {
  provider = azurerm.connectivity
  name     = "${var.root_id}-${var.location}-hub"
}

data "azurerm_route_table" "return_hop_firewall" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-return-hop-firewall"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_firewall" "firewall" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-firewall"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

data "azurerm_virtual_network" "firewall_vnet" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-network"
  resource_group_name = data.azurerm_resource_group.hub_rg.name
}

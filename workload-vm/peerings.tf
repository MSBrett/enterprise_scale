resource "azurerm_virtual_network_peering" "peer_workload_to_hub" {
  provider                     = azurerm.workload
  name                         = "peer_workload_to_hub"
  resource_group_name          = azurerm_resource_group.workload_rg.name
  virtual_network_name         = azurerm_virtual_network.workload_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.firewall_vnet.id
  allow_forwarded_traffic      = "true"
  use_remote_gateways          = "true"
  allow_virtual_network_access = "true"
}

resource "azurerm_virtual_network_peering" "peer_hub_to_workload" {
  provider                     = azurerm.connectivity
  name                         = "peer_hub_to_workload"
  resource_group_name          = data.azurerm_resource_group.hub_rg.name
  virtual_network_name         = data.azurerm_virtual_network.firewall_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.workload_vnet.id
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  allow_virtual_network_access = "true"
}

/**/

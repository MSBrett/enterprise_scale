resource "azurerm_virtual_network_peering" "peer_domain_to_hub" {
  provider                     = azurerm.identity
  name                         = "peer_domain_to_hub"
  resource_group_name          = azurerm_resource_group.domain_rg.name
  virtual_network_name         = azurerm_virtual_network.domain_vnet.name
  remote_virtual_network_id    = data.azurerm_virtual_network.firewall_vnet.id
  allow_forwarded_traffic      = "true"
  use_remote_gateways          = "true"
  allow_virtual_network_access = "true"
}

resource "azurerm_virtual_network_peering" "peer_hub_to_domain" {
  provider                     = azurerm.connectivity
  name                         = "peer_hub_to_domain"
  resource_group_name          = data.azurerm_resource_group.hub_rg.name
  virtual_network_name         = data.azurerm_virtual_network.firewall_vnet.name
  remote_virtual_network_id    = azurerm_virtual_network.domain_vnet.id
  allow_forwarded_traffic      = "true"
  allow_gateway_transit        = "true"
  allow_virtual_network_access = "true"
}

/**/

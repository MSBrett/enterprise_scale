resource "azurerm_route_table" "return_hop_firewall" {
  provider                      = azurerm.connectivity
  name                          = "${var.root_id}-${var.location}-return-hop-firewall"
  location                      = azurerm_resource_group.hub_rg.location
  resource_group_name           = azurerm_resource_group.hub_rg.name
  disable_bgp_route_propagation = false
  tags                          = var.hub_tags
}

resource "azurerm_subnet_route_table_association" "gateway_subnet" {
  provider       = azurerm.connectivity
  subnet_id      = azurerm_subnet.gateway_subnet.id
  route_table_id = azurerm_route_table.return_hop_firewall.id
}
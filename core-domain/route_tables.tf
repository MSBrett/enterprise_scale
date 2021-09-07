

resource "azurerm_route" "return_hop_domain" {
  provider               = azurerm.connectivity
  name                   = "return-hop-domain"
  resource_group_name    = data.azurerm_resource_group.hub_rg.name
  route_table_name       = data.azurerm_route_table.return_hop_firewall.name
  address_prefix         = azurerm_virtual_network.domain_vnet.address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

resource "azurerm_route_table" "next_hop_firewall" {
  provider                      = azurerm.identity
  name                          = "${var.root_id}-${var.location}-next-hop-firewall"
  location                      = azurerm_resource_group.domain_rg.location
  resource_group_name           = azurerm_resource_group.domain_rg.name
  disable_bgp_route_propagation = true
  tags                          = var.domain_tags
}

resource "azurerm_route" "next_hop_firewall" {
  provider               = azurerm.identity
  name                   = "next-hop-firewall"
  resource_group_name    = azurerm_resource_group.domain_rg.name
  route_table_name       = azurerm_route_table.next_hop_firewall.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

resource "azurerm_subnet_route_table_association" "domain_subnet" {
  provider       = azurerm.identity
  subnet_id      = azurerm_subnet.domain_subnet.id
  route_table_id = azurerm_route_table.next_hop_firewall.id
}

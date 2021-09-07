resource "azurerm_public_ip" "gateway_pip" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-gateway-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = var.hub_tags
}

resource "azurerm_virtual_network_gateway" "gateway" {
  provider            = azurerm.connectivity
  depends_on          = [ azurerm_firewall.firewall ]  
  name                = "${var.root_id}-${var.location}-hub-gateway"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  tags                = var.hub_tags

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw1"

  bgp_settings {
    asn         = 65001
    peer_weight = 10
    peering_addresses {
      ip_configuration_name = "vnetGatewayConfig"
    }
  }


  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.gateway_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway_subnet.id
  }
}

resource "azurerm_local_network_gateway" "onprem" {
  name                = "${var.root_id}-${var.location}-onprem"
  provider            = azurerm.connectivity
  resource_group_name = azurerm_resource_group.hub_rg.name
  location            = azurerm_resource_group.hub_rg.location
  gateway_address     = var.onprem_gateway_ip
  address_space       = [var.onprem_address_space]
  tags                = var.hub_tags
}

resource "azurerm_virtual_network_gateway_connection" "hub_to_onprem" {
  name                = "${var.root_id}-${var.location}-hub-to-onprem"
  provider            = azurerm.connectivity
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  tags                = var.hub_tags

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.onprem.id

  shared_key = var.vpn_key
}
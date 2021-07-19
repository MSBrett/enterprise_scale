resource "azurerm_resource_group" "hub_rg" {
  provider = azurerm.connectivity
  name     = "${var.root_id}-${var.location}-hub"
  location = var.location
  tags     = var.hub_tags
}

resource "azurerm_public_ip" "firewall_pip" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-firewall-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"
  tags                = var.hub_tags
}

resource "azurerm_virtual_network" "firewall_vnet" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-network"
  address_space       = [cidrsubnet(var.subnetprefix, 3, 0)]
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  tags                = var.hub_tags
}

resource "azurerm_subnet" "firewall_subnet" {
  provider             = azurerm.connectivity
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.firewall_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 5, 1)]
}

resource "azurerm_subnet" "gateway_subnet" {
  provider             = azurerm.connectivity
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.firewall_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 6, 1)]
}

resource "azurerm_subnet" "bastion_subnet" {
  provider             = azurerm.connectivity
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.firewall_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 6, 0)]
}

resource "azurerm_public_ip" "gateway_pip" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-gateway-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = var.hub_tags
}

resource "azurerm_firewall" "firewall" {
  provider            = azurerm.connectivity
  name                = "${var.root_id}-${var.location}-hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_tier            = "Standard"
  threat_intel_mode   = "Deny"
  tags                = var.hub_tags

  dns_servers = var.dns_servers
  # firewall_policy_id = azurerm_firewall_policy.default.id

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip.id
  }
}

resource "azurerm_virtual_network_gateway" "gateway" {
  provider            = azurerm.connectivity
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
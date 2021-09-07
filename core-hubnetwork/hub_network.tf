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
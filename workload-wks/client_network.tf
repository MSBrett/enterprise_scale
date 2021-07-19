
resource "azurerm_resource_group" "client_rg" {
  provider = azurerm.workload
  name     = "${var.root_id}-${var.location}-client"
  location = var.location
  tags     = var.client_tags
}

resource "azurerm_virtual_network" "client_vnet" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-client-network"
  address_space       = [cidrsubnet(var.subnetprefix, 3, 1)]
  location            = azurerm_resource_group.client_rg.location
  resource_group_name = azurerm_resource_group.client_rg.name
  dns_servers = [
    data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  ]
  tags = var.client_tags
}

resource "azurerm_subnet" "client_subnet" {
  provider             = azurerm.workload
  name                 = "ClientSubnet"
  resource_group_name  = azurerm_resource_group.client_rg.name
  virtual_network_name = azurerm_virtual_network.client_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 3, 1)]
}

resource "azurerm_network_security_group" "client_nsg" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-client-nsg"
  location            = azurerm_resource_group.client_rg.location
  resource_group_name = azurerm_resource_group.client_rg.name
  tags                = var.client_tags
}

resource "azurerm_subnet_network_security_group_association" "client_nsg" {
  provider                  = azurerm.workload
  subnet_id                 = azurerm_subnet.client_subnet.id
  network_security_group_id = azurerm_network_security_group.client_nsg.id
}

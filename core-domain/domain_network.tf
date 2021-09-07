
resource "azurerm_resource_group" "domain_rg" {
  provider = azurerm.identity
  name     = "${var.root_id}-${var.location}-domain"
  location = var.location
  tags     = var.domain_tags
}

resource "azurerm_virtual_network" "domain_vnet" {
  provider            = azurerm.identity
  name                = "${var.root_id}-${var.location}-domain-network"
  address_space       = [cidrsubnet(var.subnetprefix, 3, 2)]
  location            = azurerm_resource_group.domain_rg.location
  resource_group_name = azurerm_resource_group.domain_rg.name
  dns_servers = [
    data.azurerm_firewall.firewall.ip_configuration[0].private_ip_address
  ]
  tags = var.domain_tags
}

resource "azurerm_subnet" "domain_subnet" {
  provider             = azurerm.identity
  name                 = "domainSubnet"
  resource_group_name  = azurerm_resource_group.domain_rg.name
  virtual_network_name = azurerm_virtual_network.domain_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 3, 2)]
}

resource "azurerm_network_security_group" "domain_nsg" {
  provider            = azurerm.identity
  name                = "${var.root_id}-${var.location}-domain-nsg"
  location            = azurerm_resource_group.domain_rg.location
  resource_group_name = azurerm_resource_group.domain_rg.name
  tags                = var.domain_tags
}

resource "azurerm_subnet_network_security_group_association" "domain_nsg" {
  provider                  = azurerm.identity
  subnet_id                 = azurerm_subnet.domain_subnet.id
  network_security_group_id = azurerm_network_security_group.domain_nsg.id
}

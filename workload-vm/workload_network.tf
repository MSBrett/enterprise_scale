
resource "azurerm_resource_group" "workload_rg" {
  provider = azurerm.workload
  name     = "${var.root_id}-${var.location}-workload"
  location = var.location
  tags     = var.workload_tags
}

resource "azurerm_virtual_network" "workload_vnet" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-workload-network"
  address_space       = [cidrsubnet(var.subnetprefix, 3, 1)]
  location            = azurerm_resource_group.workload_rg.location
  resource_group_name = azurerm_resource_group.workload_rg.name
  dns_servers = [
    data.azurerm_network_interface.dc1_nic1.ip_configuration[0].private_ip_address
  ]
  tags = var.workload_tags
}

resource "azurerm_subnet" "workload_subnet" {
  provider             = azurerm.workload
  name                 = "WorkloadSubnet"
  resource_group_name  = azurerm_resource_group.workload_rg.name
  virtual_network_name = azurerm_virtual_network.workload_vnet.name
  address_prefixes     = [cidrsubnet(var.subnetprefix, 3, 1)]
}

resource "azurerm_network_security_group" "workload_nsg" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-workload-nsg"
  location            = azurerm_resource_group.workload_rg.location
  resource_group_name = azurerm_resource_group.workload_rg.name
  tags                = var.workload_tags
}

resource "azurerm_subnet_network_security_group_association" "workload_nsg" {
  provider                  = azurerm.workload
  subnet_id                 = azurerm_subnet.workload_subnet.id
  network_security_group_id = azurerm_network_security_group.workload_nsg.id
}

    
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
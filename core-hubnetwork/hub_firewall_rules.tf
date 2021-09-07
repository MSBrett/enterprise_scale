resource "azurerm_firewall_network_rule_collection" "network_allow" {
  provider            = azurerm.connectivity
  name                = "network_allow"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  priority            = 500
  action              = "Allow"

  rule {
    name = "allow_tcp"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    destination_ports = [
      "22",
      "53",
      "3389",
      "6516"
    ]

    destination_addresses = [
      var.subnetprefix,
    ]

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "allow_udp"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    destination_ports = [
      "53",
      "3389",
    ]

    destination_addresses = [
      var.subnetprefix,
    ]

    protocols = [
      "UDP"
    ]
  }

  rule {
    name = "allow_icmp"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      var.subnetprefix,
    ]

    protocols = [
      "ICMP"
    ]
  }

  rule {
    name = "time.windows.com"

    source_addresses = [
      var.subnetprefix,
      var.onprem_address_space
    ]

    destination_ports = [
      "123",
    ]

    destination_fqdns = [
      "time.windows.com",
    ]

    protocols = [
      "UDP"
    ]
  }

  rule {
    name = "kms.core.windows.net"

    source_addresses = [
      var.subnetprefix,
      var.onprem_address_space
    ]

    destination_ports = [
      "1688",
    ]

    destination_fqdns = [
      "kms.core.windows.net",
    ]

    protocols = [
      "TCP"
    ]
  }

  rule {
    name = "allow_internal"

    source_addresses = [
      var.subnetprefix
    ]

    destination_ports = [
      "*",
    ]

    destination_addresses = [
      var.subnetprefix,
    ]

    protocols = [
      "Any"
    ]
  }

}

resource "azurerm_firewall_application_rule_collection" "application_deny" {
  provider            = azurerm.connectivity
  name                = "application_deny"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  priority            = 500
  action              = "Deny"

  rule {
    name = "deny_fqdn"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    target_fqdns = [
      "*.ru",
      "*cn",
    ]

    protocol {
      port = "443"
      type = "Https"
    }

    protocol {
      port = "8443"
      type = "Https"
    }

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "8080"
      type = "Http"
    }
  }
}

resource "azurerm_firewall_application_rule_collection" "application_allow" {
  provider            = azurerm.connectivity
  name                = "application_allow"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.hub_rg.name
  priority            = 600
  action              = "Allow"

  rule {
    name = "allow_tags"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    fqdn_tags = [
      "WindowsUpdate",
      "WindowsDiagnostics",
      "WindowsVirtualDesktop",
      "MicrosoftActiveProtectionService",
      "AzureBackup"
    ]
  }

  rule {
    name = "allow_fqdn"

    source_addresses = [
      var.onprem_address_space,
      var.subnetprefix
    ]

    target_fqdns = [
      "*",
    ]

    protocol {
      port = "443"
      type = "Https"
    }

    protocol {
      port = "8443"
      type = "Https"
    }

    protocol {
      port = "80"
      type = "Http"
    }

    protocol {
      port = "8080"
      type = "Http"
    }
  }
}

/*
resource "azurerm_firewall_nat_rule_collection" "rdp" {
  provider            = azurerm.network
  name                = "nat_collection"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = azurerm_resource_group.firewall_rg.name
  priority            = 100
  action              = "Dnat"

  rule {
    name = "client"

    source_addresses = [
      var.allowed_ip,
    ]

    destination_ports = [
      "63389",
    ]

    destination_addresses = [
      azurerm_public_ip.firewall_pip.ip_address
    ]

    translated_port = 3389

    translated_address = azurerm_windows_virtual_machine.client_vm.private_ip_address

    protocols = [
      "TCP",
    ]
  }

  rule {
    name = "server"

    source_addresses = [
      var.allowed_ip,
    ]

    destination_ports = [
      "63390",
    ]

    destination_addresses = [
      azurerm_public_ip.firewall_pip.ip_address
    ]

    translated_port = 3389

    translated_address = azurerm_windows_virtual_machine.dc1_vm.private_ip_address

    protocols = [
      "TCP",
    ]
  }
}
*/
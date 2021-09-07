
resource "azurerm_network_interface" "dc1_nic1" {
  provider            = azurerm.identity
  name                = "${var.root_id}-${var.location}-dc1-nic1"
  resource_group_name = azurerm_resource_group.domain_rg.name
  location            = azurerm_resource_group.domain_rg.location
  tags                = var.domain_tags

  ip_configuration {
    name                          = "primary"
    primary                       = true
    subnet_id                     = azurerm_subnet.domain_subnet.id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(azurerm_subnet.domain_subnet.address_prefixes[0], 4)
  }
}

resource "azurerm_windows_virtual_machine" "dc1" {
  provider            = azurerm.identity
  depends_on          = [azurerm_network_interface.dc1_nic1]
  name                = "${var.root_id}-${var.location}-dc1"
  computer_name       = "${var.root_id}dc1"
  resource_group_name = azurerm_resource_group.domain_rg.name
  location            = azurerm_resource_group.domain_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.domain_tags

  enable_automatic_updates = true
  license_type             = "Windows_Server"

  network_interface_ids = [
    azurerm_network_interface.dc1_nic1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_disk_sku
  }

  source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown_dc1" {
  provider           = azurerm.identity
  virtual_machine_id = azurerm_windows_virtual_machine.dc1.id
  location           = azurerm_resource_group.domain_rg.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "Pacific Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    webhook_url     = "https://sample-webhook-url.microsoft.com"

  }
}

resource "azurerm_virtual_machine_extension" "adforest" {
  provider                   = azurerm.identity
  name                       = "ad-forest-creation"
  virtual_machine_id         = azurerm_windows_virtual_machine.dc1.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  protected_settings = <<PROTECTED_SETTINGS
      {
        "commandToExecute": "powershell.exe -Command \"${local.install_forest}\""
      }
    PROTECTED_SETTINGS
}

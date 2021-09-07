
resource "azurerm_network_interface" "wks1_nic1" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-wks1-nic1"
  resource_group_name = azurerm_resource_group.workload_rg.name
  location            = azurerm_resource_group.workload_rg.location
  tags                = var.workload_tags

  ip_configuration {
    name                          = "primary"
    primary                       = true
    subnet_id                     = azurerm_subnet.workload_subnet.id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(azurerm_subnet.workload_subnet.address_prefixes[0], 6)
  }
}

resource "azurerm_windows_virtual_machine" "wks1" {
  provider            = azurerm.workload
  depends_on          = [azurerm_network_interface.wks1_nic1]
  name                = "${var.root_id}-${var.location}-wks1"
  computer_name       = "${var.root_id}wks1"
  resource_group_name = azurerm_resource_group.workload_rg.name
  location            = azurerm_resource_group.workload_rg.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  tags                = var.workload_tags

  enable_automatic_updates = true
  license_type             = "Windows_Client"

  network_interface_ids = [
    azurerm_network_interface.wks1_nic1.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_disk_sku
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "21h1-ent"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown_wks1" {
  provider           = azurerm.workload
  virtual_machine_id = azurerm_windows_virtual_machine.wks1.id
  location           = azurerm_resource_group.workload_rg.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "Pacific Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    webhook_url     = "https://sample-webhook-url.microsoft.com"

  }
}

resource "azurerm_virtual_machine_extension" "wks1_join_domain" {
  name                 = azurerm_windows_virtual_machine.wks1.name
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  virtual_machine_id   = azurerm_windows_virtual_machine.wks1.id

  settings = <<SETTINGS
    {
        "Name": "${var.active_directory_domain}",
        "OUPath": "",
        "User": "${var.admin_username}@${var.active_directory_domain}",
        "Restart": "true",
        "Options": "3"
    }
SETTINGS

  protected_settings = <<SETTINGS
    {
        "Password": "${var.admin_password}"
    }
SETTINGS

}
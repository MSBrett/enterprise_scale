
resource "azurerm_network_interface" "vm1_nic1" {
  provider            = azurerm.workload
  name                = "${var.root_id}-${var.location}-vm1-nic1"
  resource_group_name = azurerm_resource_group.client_rg.name
  location            = azurerm_resource_group.client_rg.location
  tags                = var.client_tags

  ip_configuration {
    name                          = "primary"
    primary                       = true
    subnet_id                     = azurerm_subnet.client_subnet.id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(azurerm_subnet.client_subnet.address_prefixes[0], 4)
  }
}

resource "azurerm_windows_virtual_machine" "vm1" {
  provider            = azurerm.workload
  depends_on          = [azurerm_network_interface.vm1_nic1]
  name                = "${var.root_id}-${var.location}-vm1"
  computer_name       = "${var.root_id}vm1"
  resource_group_name = azurerm_resource_group.client_rg.name
  location            = azurerm_resource_group.client_rg.location
  size                = var.vm_size
  admin_username      = "${var.root_id}${var.admin_username_suffix}"
  admin_password      = var.admin_password

  enable_automatic_updates = true
  license_type             = "Windows_Client"

  network_interface_ids = [
    azurerm_network_interface.vm1_nic1.id
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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown_vm1" {
  provider           = azurerm.workload
  virtual_machine_id = azurerm_windows_virtual_machine.vm1.id
  location           = azurerm_resource_group.client_rg.location
  enabled            = true

  daily_recurrence_time = "2000"
  timezone              = "Pacific Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    webhook_url     = "https://sample-webhook-url.microsoft.com"

  }
}
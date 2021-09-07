resource "azurerm_linux_virtual_machine_scale_set" "ubuntu_vmss" {
  count               = var.scaleset_instance_count > 0 ? 1 : 0
  name                = "uvmss"
  resource_group_name = azurerm_resource_group.workload_rg.name
  location            = azurerm_resource_group.workload_rg.location
  sku                 = var.vm_size
  instances           = var.scaleset_instance_count
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.vm_disk_sku
  }

  network_interface {
    name    = "uvmssnic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.workload_subnet.id
    }
  }
}
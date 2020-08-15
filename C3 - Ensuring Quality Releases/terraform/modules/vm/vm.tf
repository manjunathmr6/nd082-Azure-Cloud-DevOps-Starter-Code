resource "azurerm_network_interface" "netitf" {
  name                = "netitf_As_3"
  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = ""
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "lxvm" {
  name                  = "lxvm_As_3"
  location              = var.location
  resource_group_name   = var.resource_group
  size                = "Standard_B1s"
  admin_username      = ""
  network_interface_ids = []
  admin_ssh_key {
    username   = ""
    public_key = "file("~/.ssh/id_rsa.pub")"
  }
  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
provider "azurerm" {
  version = "~> 2.16"
  features {}
}

resource "azurerm_resource_group" "Udacity_Assignment_TF_1" {
  name     = "Udacity_Assignment_TFG_1"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "Udacity_Assignment_TF_1" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Udacity_Assignment_TF_1.location
  resource_group_name = azurerm_resource_group.Udacity_Assignment_TF_1.name
  tags     = var.tags
}

resource "azurerm_subnet" "Udacity_Assignment_TF_1" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.Udacity_Assignment_TF_1.name
  virtual_network_name = azurerm_virtual_network.Udacity_Assignment_TF_1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "Udacity_Assignment_TF_1" {
 name                         = "${var.prefix}-PublicIP"
 location                     = azurerm_resource_group.Udacity_Assignment_TF_1.location
 resource_group_name          = azurerm_resource_group.Udacity_Assignment_TF_1.name
 allocation_method            = "Static"
 tags     = var.tags
}

resource "azurerm_lb" "Udacity_Assignment_TF_1" {
 name                = "${var.prefix}-loadBalancer"
 location            = azurerm_resource_group.Udacity_Assignment_TF_1.location
 resource_group_name = azurerm_resource_group.Udacity_Assignment_TF_1.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.Udacity_Assignment_TF_1.id
 }

 tags     = var.tags
}

resource "azurerm_lb_backend_address_pool" "Udacity_Assignment_TF_1" {
 resource_group_name = azurerm_resource_group.Udacity_Assignment_TF_1.name
 loadbalancer_id     = azurerm_lb.Udacity_Assignment_TF_1.id
 name                = "${var.prefix}-bap"
}

resource "azurerm_network_interface" "Udacity_Assignment_TF_1" {
  count               = var.number_of_instance
  name                = "${var.prefix}-nic_${count.index}"
  resource_group_name = azurerm_resource_group.Udacity_Assignment_TF_1.name
  location            = azurerm_resource_group.Udacity_Assignment_TF_1.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Udacity_Assignment_TF_1.id
    private_ip_address_allocation = "Dynamic"
  }
  tags     = var.tags
}

resource "azurerm_network_security_group" "Udacity_Assignment_TF_1" {
    name                = "${var.prefix}-nsg"
    location            = azurerm_resource_group.Udacity_Assignment_TF_1.location
    resource_group_name = azurerm_resource_group.Udacity_Assignment_TF_1.name
    
    security_rule {
    name                       = "AllInbound-Deny"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "VirtualNetwork-Inbound-Allow"
    priority                   = 4056
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "HTTP-Inbound-Allow"
    priority                   = 3859
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }
  
  security_rule {
        name                       = "SSH--Inbound-Allow"
        priority                   = 1026
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
	
  security_rule {
    name                       = "AllOutbound-Deny"
    priority                   = 4096
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "VirtualNetwork-Outbound-Allow"
    priority                   = 4056
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags     = var.tags
}




resource "azurerm_managed_disk" "Udacity_Assignment_TF_1" {
 count                = var.number_of_instance
 name                 = "${var.prefix}-amd-${count.index}"
 location             = azurerm_resource_group.Udacity_Assignment_TF_1.location
 resource_group_name  = azurerm_resource_group.Udacity_Assignment_TF_1.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
 tags     = var.tags
}

resource "azurerm_network_interface_security_group_association" "Udacity_Assignment_TF_1" {
    count                = var.number_of_instance
    network_interface_id = azurerm_network_interface.Udacity_Assignment_TF_1[count.index].id
    network_security_group_id = azurerm_network_security_group.Udacity_Assignment_TF_1.id
}


resource "azurerm_availability_set" "avset" {
 name                         = "${var.prefix}-AvailabilitySet"
 location                     = azurerm_resource_group.Udacity_Assignment_TF_1.location
 resource_group_name          = azurerm_resource_group.Udacity_Assignment_TF_1.name
 platform_fault_domain_count  = 2
 platform_update_domain_count = 2
 managed                      = true
 tags     = var.tags
}

data "azurerm_resource_group" "packerImage" {
  name = "Udacity_Assignment_1"
}

data "azurerm_image" "packerImage" {
  name                = "UdacityPackerImage"
  resource_group_name = var.resource_groupname
}


resource "azurerm_virtual_machine" "Udacity_Assignment_TF_1" {
  count                           = var.number_of_instance
  name                            = "${var.prefix}_UVM_${count.index}" 
  resource_group_name             = azurerm_resource_group.Udacity_Assignment_TF_1.name
  location                        = azurerm_resource_group.Udacity_Assignment_TF_1.location
  vm_size                         = "Standard_DS1_v2"  
  network_interface_ids           = [element(azurerm_network_interface.Udacity_Assignment_TF_1.*.id, count.index)]  
  tags     = var.tags
  
  storage_image_reference {
   id=data.azurerm_image.packerImage.id
 }
  
 os_profile {
   computer_name  = "udacity"
   admin_username = var.username
   admin_password = var.password
 }

  storage_os_disk {
    name              = "${var.prefix}sod_${count.index}"
    caching              = "ReadWrite"
	create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }  
 
  storage_data_disk {
   name            = element(azurerm_managed_disk.Udacity_Assignment_TF_1.*.name, count.index)
   managed_disk_id = element(azurerm_managed_disk.Udacity_Assignment_TF_1.*.id, count.index)
   create_option   = "Attach"
   lun             = 1
   disk_size_gb    = element(azurerm_managed_disk.Udacity_Assignment_TF_1.*.disk_size_gb, count.index)
 }
 
  os_profile_linux_config {
   disable_password_authentication = false
 }
    
}
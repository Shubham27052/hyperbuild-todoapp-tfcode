locals {
  virtual_machine_name        = var.vm_name
  network_security_group_name = "nsg-${var.vm_name}"
  network_interface_name      = "nic-${var.vm_name}"

  security_group_rules = [
    {
      "name" : "allowDevOps",
      "priority" : 200,
      "direction" : "Inbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureDevOps"
      destination_address_prefix = "*"
    },
    {
      "name" : "allowSSH",
      "priority" : 210,
      "direction" : "Inbound"
      "access" : "Allow"
      "protocol" : "Tcp"
      source_port_range          = "*"
      destination_port_range     = 22
      source_address_prefix      = "182.69.180.43"
      destination_address_prefix = "*"
    }
  ]
}



resource "azurerm_network_security_group" "nsg_main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.network_security_group_name

  dynamic "security_rule" {
    for_each = { for rule in local.security_group_rules : rule.name => rule }

    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }

  }

}


resource "azurerm_network_interface_security_group_association" "nic_nsg_associate" {
  network_interface_id      = azurerm_network_interface.nic_main.id
  network_security_group_id = azurerm_network_security_group.nsg_main.id
}

resource "azurerm_network_interface" "nic_main" {
  resource_group_name = var.resource_group_name
  location            = var.location
  name                = local.network_interface_name
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

}



resource "azurerm_linux_virtual_machine" "vm_main" {
  resource_group_name   = var.resource_group_name
  location              = var.location
  name                  = local.virtual_machine_name
  size                  = "Standard_B1ms"
  network_interface_ids = [azurerm_network_interface.nic_main.id]

  admin_username = "azureuser"
  admin_password = var.admin_password
  disable_password_authentication = false

  os_disk {
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64

  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
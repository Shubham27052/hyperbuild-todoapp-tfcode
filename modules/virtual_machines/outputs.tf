output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.vm_main.id
}

output "virtual_machine_private_ip" {
  value = azurerm_linux_virtual_machine.vm_main.private_ip_address
}


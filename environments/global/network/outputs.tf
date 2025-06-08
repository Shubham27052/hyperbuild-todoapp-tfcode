output "global_vnet_id" {
    value = azurerm_virtual_network.vnet_global.id
}


output "subnet_runner_id" {
    value = azurerm_subnet.subnet_runner.id
}
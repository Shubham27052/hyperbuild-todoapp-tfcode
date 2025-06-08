data "terraform_remote_state" "rg_global" {
    backend = "azurerm"
    config = {
      storage_account_name = "noteapprmtbackend01"
      container_name = "remote-backend"
      key = "global.backendsa.terraform.tfstate"
      resource_group_name = "RGglobal"

    }
}

resource "azurerm_virtual_network" "vnet_global" {
    resource_group_name = data.terraform_remote_state.rg_global.outputs.global_rg_name
    location = data.terraform_remote_state.rg_global.outputs.global_rg_location
    name = "global-vnet"
    address_space = [ "172.16.0.0/20" ]
}


resource "azurerm_subnet" "subnet_runner" {
    resource_group_name = data.terraform_remote_state.rg_global.outputs.global_rg_name
    name = "subnet-runner"
    virtual_network_name = azurerm_virtual_network.vnet_global.name
    address_prefixes = ["172.16.0.0/24"]
}

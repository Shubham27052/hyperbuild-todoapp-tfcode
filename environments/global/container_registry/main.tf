data "terraform_remote_state" "global_resource_group" {
  backend = "azurerm"
  config = {
    storage_account_name = "noteapprmtbackend01"
    container_name       = "remote-backend"
    key                  = "global.backendsa.terraform.tfstate"
    resource_group_name  = "RGglobal"
  }

}


resource "azurerm_container_registry" "acr_global" {
  name                = "ACRnoteapp"
  resource_group_name = data.terraform_remote_state.global_resource_group.outputs.resource_group_name
  location            = data.terraform_remote_state.global_resource_group.outputs.resource_group_location
  sku                 = "Basic"

}
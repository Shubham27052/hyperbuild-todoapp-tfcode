data "terraform_remote_state" "global_resource_group" {
  backend = "azurerm"
  config = {
    resource_group_name  = "RGglobal"
    storage_account_name = "noteapprmtbackend01"
    container_name       = "remote-backend"
    key                  = "global.backendsa.terraform.tfstate"

  }
}

data "terraform_remote_state" "global_network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "RGglobal"
    storage_account_name = "noteapprmtbackend01"
    container_name       = "remote-backend"
    key                  = "global.network.terraform.tfstate"

  }

}


module "vm_cicdrunner" {
  source = "../../../modules/virtual_machines"

  resource_group_name = data.terraform_remote_state.global_resource_group.outputs.global_rg_name
  location            = data.terraform_remote_state.global_resource_group.outputs.global_rg_location
  vm_name             = "cicdrunner"
  subnet_id           = data.terraform_remote_state.global_network.outputs.subnet_runner_id
  admin_password      = var.admin_password

}

resource "azurerm_virtual_machine_extension" "vm_runner_extension_terraform" {
  name                 = "InstallTerraform"
  virtual_machine_id   = module.vm_cicdrunner.virtual_machine_id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"  # Consider using the latest supported version

  settings = jsonencode({
    fileUris         = ["https://noteapprmtbackend01.blob.core.windows.net/scripts/install-terraform.sh?${var.sas_token}"]
    commandToExecute = "bash install-terraform.sh"
  })

  protected_settings = jsonencode({})
}


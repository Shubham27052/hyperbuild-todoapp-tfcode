resource "azurerm_resource_group" "rg_dev" {
  name     = "RGdev"
  location = "Central India"

  tags = {
    "Environment" = "Development"
  }
}


data "terraform_remote_state" "global_acr" {
  backend = "azurerm"
  config = {
    resource_group_name  = "RGglobal"
    storage_account_name = "noteapprmtbackend01"
    container_name       = "remote-backend"
    key                  = "global.acr.terraform.tfstate"

  }
}



resource "azurerm_service_plan" "asp_dev" {
  name                = "ASPdev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  os_type             = "Linux"
  sku_name            = "F1"
}


resource "azurerm_linux_web_app" "webapp_dev" {
  name                = "NoteAppDev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  service_plan_id     = azurerm_service_plan.asp_dev.id

  site_config {
    always_on = false
    container_registry_use_managed_identity = true
  
    application_stack {
      docker_image_name = "noteapp/dev:latest"
      docker_registry_url = "https://acrnoteapp.azurecr.io"
    }
  }

  identity {
   type = "SystemAssigned"
  }

}


resource "azurerm_role_assignment" "roleassign_prodwebapp_contributor" {
  scope = data.terraform_remote_state.global_acr.outputs.acr_global_id
  role_definition_name = "Contributor"
  principal_id = azurerm_linux_web_app.webapp_dev.identity.principal_id
  
}


resource "azurerm_role_assignment" "roleassign_prodwebapp_contributor" {
  scope = data.terraform_remote_state.global_acr.outputs.acr_global_id
  role_definition_name = "AcrPull"
  principal_id = azurerm_linux_web_app.webapp_dev.identity.principal_id
  
}

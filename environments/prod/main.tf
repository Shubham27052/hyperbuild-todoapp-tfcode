resource "azurerm_resource_group" "rg_prod" {
  name     = "RGprod"
  location = "Central India"

  tags = {
    "Environment" = "Production"
  }
}




resource "azurerm_service_plan" "asp_prod" {
  name                = "ASPprod"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location            = azurerm_resource_group.rg_prod.location
  os_type             = "Linux"
  sku_name            = "F1"
}


resource "azurerm_linux_web_app" "webapp_prod" {
  name                = "NoteAppProd"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location            = azurerm_resource_group.rg_prod.location
  service_plan_id     = azurerm_service_plan.asp_prod.id
  site_config {
    always_on = false
    container_registry_use_managed_identity = true
  
    application_stack {
      docker_image_name = "noteapp/prod:latest"
      docker_registry_url = "https://acrnoteapp.azurecr.io"
    }
  }

  identity {
   type = "SystemAssigned"
  }
}
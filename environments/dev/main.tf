resource "azurerm_resource_group" "rg_dev" {
  name     = "RGdev"
  location = "Central India"

  tags = {
    "Environment" = "Development"
  }
}


resource "azurerm_service_plan" "asp_dev" {
  name                = "ASPdev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  os_type             = "Linux"
  sku_name            = "B1"
}


resource "azurerm_linux_web_app" "webapp_dev" {
  name                = "NoteAppDev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = azurerm_resource_group.rg_dev.location
  service_plan_id     = azurerm_service_plan.asp_dev.id

  site_config {
    always_on = false

    application_stack {
      docker_image_name = "noteappdev:latest"
      docker_registry_url = "https://acrnoteapp.azurecr.io"


    }
  }

  identity {
   type = "SystemAssigned"
  }

}



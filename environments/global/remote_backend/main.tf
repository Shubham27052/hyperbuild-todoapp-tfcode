resource "azurerm_resource_group" "rg_global"{
    name = "RGglobal"
    location = "Central India"
}


resource "azurerm_storage_account" "sa_remote_backend" {
    resource_group_name = azurerm_resource_group.rg_global.name
    location = azurerm_resource_group.rg_global.location
    name = "noteapprmtbackend01"
    account_tier = "Standard"
    account_replication_type = "LRS"
    blob_properties {
      versioning_enabled = true
    }
}


resource "azurerm_storage_container" "container_remote_backend" {
    storage_account_id = azurerm_storage_account.sa_remote_backend.id
    name = "remote-backend"  
}

resource "azurerm_storage_container" "container_scripts" {
    storage_account_id = azurerm_storage_account.sa_remote_backend.id
    name = "scripts"  
}
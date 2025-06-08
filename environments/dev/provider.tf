terraform {
  backend "azurerm" {
    storage_account_name = "noteapprmtbackend01"
    container_name       = "remote-backend"
    key                  = "dev.terraform.tfstate"
    resource_group_name  = "RGglobal"
  }
}

provider "azurerm" {
  features {}

}



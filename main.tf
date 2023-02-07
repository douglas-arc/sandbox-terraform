terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.28.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "sandbox-infrastructure"
    storage_account_name = "sandboxtfstatedarc"
    container_name       = "terraform"
    key                  = "sandbox.terraform.tfstate"

  }
}

provider "azurerm" {
  subscription_id     = "0fb1f09b-c079-45b2-a7ac-4854485676a9"

  features {}
}

data "azurerm_resource_group" "infrastructure" {
  name = "sandbox-infrastructure"
}

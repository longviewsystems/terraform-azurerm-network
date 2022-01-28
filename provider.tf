terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 2.88.1"
    }
  }
}

provider "azurerm" {
  features {}
}
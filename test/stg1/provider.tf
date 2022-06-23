terraform {
  required_version = ">= 1.1"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.88.1, < 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}
terraform {
  required_version = ">= 1.0.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.87.0"
    }
  }
}

provider "azurerm" {
  features {}
}
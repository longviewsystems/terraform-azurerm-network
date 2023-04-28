terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0, <4.0.0"
    }
  }
}


#This shoudl not be in modules.
# provider "azurerm" {
#   features {}
# }
/*variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
}

variable "resource_group_name" {
  description = "Name of the resource group to be imported."
  type        = string
}

variable "vnet_name" {
  description = "Name of the vnet to create"
  type        = string
}

variable "locations" {
  type        = string
  description = "The location of the resources."
}

variable "address_spaces" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  type        = list(string)
  default     = []
}

variable "subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  type        = list(string)
}

variable "subnet_names" {
  description = "A list of public subnets inside the vNet."
  type        = list(string)
}

variable "subnet_service_endpoints" {
  description = "A map of subnet name to service endpoints to add to the subnet."
  type        = map(any)
}*/

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  type        = string
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
  default     = "westeurope"

}

variable "vnetwork_name" {
  description = "Name of your Azure Virtual Network"
  type        = string
  default     = "vnet-azure-westeurope-001"

}


variable "vnet_address_space" {
  description = "The address space to be used for the Azure virtual network."
  type        = list(any)
  default     = ["10.0.0.0/16"]
}

variable "subnets" {
  description = "For each subnet, create an object that contain fields"
  type        = list(any)
  //default     = {}
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "dns_servers" {
  description = "List of dns servers to use for virtual network"
  type        = list(any)
  default     = []
}

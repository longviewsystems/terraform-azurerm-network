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
  type = map(object({
    subnet_name                                    = string
    subnet_address_prefix                          = list(string)
    nsg_name                                       = string
    enforce_private_link_endpoint_network_policies = string
    service_endpoints                              = list(string)
  }))
  default = {}
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

variable default_subnet_routing {
  type = list
  default = []
}
variable "custom_subnet_routing" {
  type = list
  default = []
}
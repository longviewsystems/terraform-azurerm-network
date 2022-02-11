variable "tags" {
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
}

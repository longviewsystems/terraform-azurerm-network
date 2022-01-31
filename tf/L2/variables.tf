variable "name" {
  description = "Name of the virtual network."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
  default     = null
}

variable "location" {
  description = "The Azure Region in which to create resource."
}

variable "address_space" {
  description = "The address space that is used the virtual network."
  type        = list(string)
}

variable "firewall_ip" {
  description = "Private ip of firewall to route all traffic through."
  default     = null
}

variable "subnets" {
  description = "Subnets to create and their configuration. All values are required, set empty to ignore."
  default     = {}
}


variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "netwatcher_rg" {
  default = "NetworkWatcherRG"
}

variable "netwatcher_name" {
}

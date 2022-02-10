variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
}

/******* NAMING 

Sample:

postgresql_server = {
      name        = "pre-fix-psql-su-fix"

******/

variable "naming_suffix" {
  type        = list(any)
  description = "The suffixes for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash."
}

variable "naming_prefix" {
  type        = list(any)
  description = "The prefix for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash."
}

/***** COMMON VARIABLES *****/

variable "locations" {
  type        = map(string)
  description = "The location of the resources."
}

variable "locations" {
  type        = map(string)
  description = "The location of the resources."
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

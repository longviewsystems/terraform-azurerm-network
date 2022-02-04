variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  #default     = {}
}

/******* NAMING 

Sample:

postgresql_server = {
      name        = "pre-fix-psql-su-fix"

******/

variable "naming_suffix" {
  type        = list(any)
  description = "The suffixes for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash."
  #default     = []

}

variable "naming_prefix" {
  type        = list(any)
  description = "The prefix for the names of the resources.  Use only lowercase characters.  Each item will be seperated by a dash."
  #default     = []

}

/***** COMMON VARIABLES *****/

variable "locations" {
  type        = map(string)
  description = "The location of the resources."
  #default = {}
}


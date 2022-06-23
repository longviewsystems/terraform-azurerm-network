variable "location" {
  type        = string
  description = "Location used to deploy the resources"
  default     = "westus2"
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "tags" {
  type        = map(any)
  description = "Resource tags"
  default = {
    environment = "test"
    managed_by  = "terratest"
  }
}

variable "storage_account_id" {
  type = string
  description = "Storage account for Diagnostic logging."
}
  
variable "log_analytics_workspace_id" {
  type = string
  description = "Log Analytics Workspace id to be used for Diagnostic Logging."
}

variable "route_table1" {
  type = object({
    route_table_name        = string
    route_table_rg_name         = string
  })
  description = "Route Table 1 for this test."
}


variable "route_table2" {
  type = object({
    route_table_name        = string
    route_table_rg_name         = string
  })
  description = "Route Table 2 for this test."
}
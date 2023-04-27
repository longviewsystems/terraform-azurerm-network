locals {
  #Build the list that will be used to map route_tables to subnets
  route_table_list = {
    for name, subnets in var.subnets : name => subnets
    if subnets.route_table_rg_name != null && subnets.route_table_rg_name != "" && subnets.route_table_name != null && subnets.route_table_name != ""
  }
}

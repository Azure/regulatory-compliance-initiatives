data "terraform_remote_state" "eslz" {
  backend = "local"

  config = {
    path = "../landingzone/terraform.tfstate"
  }
  
}

data "azurerm_firewall" "connectivity" {
  name = split("/", data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_firewall.connectivity[0])[8]
  resource_group_name = split("/", data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_firewall.connectivity[0])[4]
}

# output "connectivity_azfirewall_name" {
#   value = split("/", data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_firewall.connectivity[0])[8]
# }

# output "connectivity_azfirewall_ip" {
#   value = data.azurerm_firewall.connectivity.ip_configuration[0].private_ip_address
# }
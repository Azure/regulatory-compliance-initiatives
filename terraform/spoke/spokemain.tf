locals {
  connectivity_hub_vnet_id           = data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_virtual_network.connectivity[0]
  connectivity_hub_vnet_name         = split("/", data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_virtual_network.connectivity[0])[8]
  connectivity_hub_vnet_rg_name      = split("/", data.terraform_remote_state.eslz.outputs.resource_ids.enterprise_scale.azurerm_virtual_network.connectivity[0])[4]
  connectivity_azfirewall_private_ip = data.azurerm_firewall.connectivity.ip_configuration[0].private_ip_address
}
# RG 
resource "azurerm_resource_group" "app1" {
  name     = "app1"
  location = "southeastasia"
}

# Vnet
resource "azurerm_virtual_network" "app1" {
  name                = "app1-vnet"
  resource_group_name = azurerm_resource_group.app1.name
  location            = azurerm_resource_group.app1.location
  address_space       = ["10.102.0.0/16"]
}

# Vnet Peering
resource "azurerm_virtual_network_peering" "app1_hub" {
  name                      = "app1tohub"
  resource_group_name       = azurerm_resource_group.app1.name
  virtual_network_name      = azurerm_virtual_network.app1.name
  remote_virtual_network_id = local.connectivity_hub_vnet_id
}
resource "azurerm_virtual_network_peering" "hub_app1" {
  name                      = "hubtoapp1"
  resource_group_name       = local.connectivity_hub_vnet_rg_name
  virtual_network_name      = local.connectivity_hub_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.app1.id
}

# Subnets
resource "azurerm_subnet" "app1_web" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.app1.name
  virtual_network_name = azurerm_virtual_network.app1.name
  address_prefixes     = ["10.102.1.0/24"]
}

resource "azurerm_subnet" "app1_app" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.app1.name
  virtual_network_name = azurerm_virtual_network.app1.name
  address_prefixes     = ["10.102.2.0/24"]
}

resource "azurerm_subnet" "app1_db" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.app1.name
  virtual_network_name = azurerm_virtual_network.app1.name
  address_prefixes     = ["10.102.3.0/24"]
}

# Route table and association
resource "azurerm_route_table" "app1_rt" {
  name                = "app1-routetable"
  location            = azurerm_resource_group.app1.location
  resource_group_name = azurerm_resource_group.app1.name

  route {
    name                   = "app1_hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = local.connectivity_azfirewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "app1_rt_web" {
  subnet_id      = azurerm_subnet.app1_web.id
  route_table_id = azurerm_route_table.app1_rt.id
}

resource "azurerm_subnet_route_table_association" "app1_rt_app" {
  subnet_id      = azurerm_subnet.app1_app.id
  route_table_id = azurerm_route_table.app1_rt.id
}

resource "azurerm_subnet_route_table_association" "app1_rt_db" {
  subnet_id      = azurerm_subnet.app1_db.id
  route_table_id = azurerm_route_table.app1_rt.id
}
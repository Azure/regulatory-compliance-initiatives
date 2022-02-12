# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "core" {}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.1"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  deploy_management_resources    = var.deploy_management_resources
  subscription_id_management     = data.azurerm_client_config.core.subscription_id
  configure_management_resources = local.configure_management_resources

# This will be used for the deployment of all "Connectivity resources" to default`.
  deploy_connectivity_resources    = var.deploy_connectivity_resources
  subscription_id_connectivity     = data.azurerm_client_config.core.subscription_id
  configure_connectivity_resources = local.configure_connectivity_resources

  # Configuration settings for optional landing zones
  deploy_corp_landing_zones   = false
  deploy_online_landing_zones = false
  deploy_sap_landing_zones    = false
  deploy_demo_landing_zones   = false

  custom_landing_zones = {
    "${var.root_id}-production" = {
      display_name               = "Production"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = ["de40a933-33fc-47a7-afaf-78f0c6edba9a"]
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-pre-production" = {
      display_name               = "Pre-Production"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
    "${var.root_id}-non-production" = {
      display_name               = "Non-Production"
      parent_management_group_id = "${var.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
      # archetype_config = {
      #   archetype_id   = "customer_online"
      #   parameters     = {
      #     Deny-Resource-Locations = {
      #       listOfAllowedLocations = ["eastus",]
      #     }
      #     Deny-RSG-Locations = {
      #       listOfAllowedLocations = ["eastus",]
      #     }
      #   }
      #   access_control = {}
      # }
    }
  }
}

# Pre-requisites
1. Install terraform and add to path for commandline access <br>
Download link: https://www.terraform.io/downloads.html

2. Setting up Identity for terraform
In Azure there are a few identity options to deploy your terraform code.<br>
- **User login**<br>
Start with this if you are not too familiar with other Azure identities, this requires less steps as well.<br>
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli

- Managed Identity (optional alternative)<br>
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/managed_service_identity

- Service Principal (optional alternative)<br>
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret

3. Permission check - assign required roles
In order for you to deploy the terraform code for you will require the following permissions for any of the identity used.

Scope: root management group
role: Management Group Contributor

Scope: subscription (targetted subscription)
role: User Access Administrator
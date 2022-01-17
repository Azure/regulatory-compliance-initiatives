# Azure Landing Zones for Financial Services Industry in Malaysia

## Background

The purpose of the reference implementation is to guide [Bank Negara of Malaysia’s Risk Management in Technology (RMiT) Regulatory Compliance](https://www.bnm.gov.my/documents/20124/963937/Risk+Management+in+Technology+%28RMiT%29.pdf/810b088e-6f4f-aa35-b603-1208ace33619?t=1592866162078). This guide helps to ensure that the Microsoft Malaysian financial institutions customers on building Landing Zones in their Azure environment. The reference implementation is based on [Cloud Adoption Framework for Azure](https://docs.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/) and provides an opinionated implementation that enables to ensure that technology risk management framework (TRMF) 9.2 (e), (f), (g) and cyber resilience framework (CRF) 11.3 (d), (e), (g) remain relevant on an ongoing basis and meet the regulatory compliance by using [NIST SP 800-53 Rev. 4](https://docs.microsoft.com/azure/governance/policy/samples/nist-sp-800-53-r4) and [Risk Management in Technology (RMiT) policies.](https://docs.microsoft.com/en-us/azure/governance/policy/samples/rmit-malaysia)

## Architecture

See architecture documentation for detailed walkthrough of design. (ccoming soon)

Deployment to Azure is supported using Azure DevOps Pipelines and can be adopted for other automated deployment systems like GitHub Actions, Jenkins, etc.

The automation is built with Terraform.

## Onboarding to Azure financial services Landing Zone 

## Goals 
- Establishing the necessary risk frameworks, governance structures, policies, procedures to meet RMiT policies
- Accelerate the use of Azure in financial services through onboarding multiple types of workloads including, Azure IaaS, Lift & Shift, App Dev and Data & AI.
- Simplify compliance management through a single source of compliance, audit reporting and auto remediation.
- Deployment of DevOps frameworks & business processes to improve agility.

## Non-Goals
- Automation does not configure firewalls deployed as Network Virtual Appliance (NVA). In this reference implementation, Fortinet firewalls can be deployed but customer is expected to configure and manage upon deployment.
- Automatic approval / notification for Risk Management in Technology. Customers must collect evidence, customize to meet their regulatory requirements and submit for Authority to Operate based on their risk profile, requirements and process. Refer [Appendix 7 Risk Assessment Report](https://www.bnm.gov.my/documents/20124/963937/Risk+Management+in+Technology+%28RMiT%29.pdf/810b088e-6f4f-aa35-b603-1208ace33619?t=1592866162078)
- Compliant on all Azure Policies when the reference implementation is deployed. This is due to the shared responsibility of cloud and customers can choose the Azure Policies to exclude. For example, using Azure Firewall is an Azure Policy that will be non-compliant since majority of the financial institutions customers use Network Virtual Appliances such as Palo Alto, Check Point, Fortinet. Customers must review [Microsoft Defender for Cloud Regulatory Compliance dashboard](https://docs.microsoft.com/en-gb/azure/defender-for-cloud/update-regulatory-compliance-packages) and apply appropriate exemptions.

## How to test
To add it as a custom initiative:
New-AzPolicySetDefinition -Name "RMIT Test" -GroupDefinition .\groups.json -PolicyDefinition .\policies.json -Parameter .\params.json
You can then further assign it in your Azure Portal in whichever scope.

Note: we’ll need to modify the parameters for some key policies like “allowed location” and “allowed resource type” as they are left empty and will not be able to deploy anything on Azure without it.


## Deployment Guide
### Pre-requisites
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

### Deployment Steps
### 1. Clone the repo and go to terraform directory where the configuration codes reside.
```
git clone git@github.com:Azure/regulatory-compliance-initiatives.git
cd regulatory-compliance-initiatives/terraform/
```

### 2. Login to your identity
You may follow the guide in this documentation for further reference
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli

Run the following command and login via browser
```
az login
```
Check for subscription list given to your user account
```
az account show
```
You should see the output with the following format.
```
[
  {
    "cloudName": "AzureCloud",
    "id": "00000000-0000-0000-0000-000000000000",
    "isDefault": true,
    "name": "PAYG Subscription",
    "state": "Enabled",
    "tenantId": "00000000-0000-0000-0000-000000000000",
    "user": {
      "name": "user@example.com",
      "type": "user"
    }
  }
]
```
[Skip if you are already in the correct subscription]
Here you should make sure you are signed into the correct subscription, otherwise you may use the following command to set to the correct subscription
```
az account list
az account set --subscription="SUB_ID_HERE"
```

### 3. Run Terraform
Once you have logged in, make sure you are in the right directory shown in step 1, and run the following commands.

```
terraform init
terraform plan
```
You may take this opportunity to verify the planned changes after running terraform plan as it does not apply to your environment yet. Otherwise proceed for deployment by running 
```
terraform apply -auto-approve
```
This process may take up to 30 minutes. Once the run is complete, you may review the changes in the portal under "Management Groups" and "Azure Policy"

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.

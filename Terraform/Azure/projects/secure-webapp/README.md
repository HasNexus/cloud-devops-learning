# Secure Web App Project
This Terraform configuration deploys a secure Azure Web App running a Docker container and connected to Azure Key Vault through a private endpoint.

## What it does
- Creates a Resource Group and Virtual Network

- Creates two subnets:
  - Web App Subnet (delegated to Microsoft.Web/serverFarms)
  - Key Vault Subnet (hosts private endpoint)
  - Deploys an App Service Plan (B1 SKU, Linux)

- Deploys a Web App with:
  - System-assigned managed identity
  - Docker container from public registry
  - VNet Integration

- Creates a Key Vault with:
  - Public network access disabled
  - Private endpoint connection to VNet
  - RBAC role: “Key Vault Secrets User” for the Web App
- Stores backend state in Azure Storage

## How to use
- Copy `terraform.tfvars.template` to `terraform.tfvars` or just rename .template to .tfvars
- Fill in your own values (subscription ID, SSH key path, IP address, etc.)
- Run `terraform init` and `terraform apply` to create

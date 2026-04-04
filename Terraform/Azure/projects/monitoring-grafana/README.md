# monitoring-grafana
This Terraform configuration deploys an Azure Web App and a Linux VM with Grafana installed, connected to Azure Monitor as a data source through an Azure AD service principal.

## What it does
- Creates a Resource Group and Virtual Network with two subnets:
  - VM Subnet (for the Grafana host)
  - Web App Subnet (delegated to Microsoft.Web/serverFarms)

- Deploys an **Ubuntu VM** with:
  - Grafana installed and started via a remote provisioner script
  - NSG rule allowing inbound access to Grafana (port 3000) from your IP only

- Deploys a **Web App** running a Docker container with VNet integration

- Runs a traffic generation script (`traffic.sh`) on the VM pointed at the Web App URL

- Creates an **Azure AD App Registration and Service Principal** with:
  - A generated client secret
  - Reader role assigned at the subscription level

- Configures **Grafana's Azure Monitor data source** automatically via the Grafana Terraform provider using the service principal credentials

- Stores backend state in Azure Storage

## How to use
- Copy `backend.hcl.template` to `backend.hcl` and fill in your storage account details
- Copy `terraform.tfvars.template` to `terraform.tfvars` and fill in your own values (subscription ID, SSH key paths, IP address, etc.)
- Run `terraform init -backend-config=backend.hcl`
- Run `terraform apply`
- Access Grafana at `http://<VM_PUBLIC_IP>:3000` (default credentials: `admin` / `admin`)

## Notes
- The Grafana provider connects to the VM's public IP on port 3000 — the VM and Grafana must be fully running before the provider resources are applied
- The `null_resource` provisioner handles copying and executing the setup scripts over SSH, so your private key path must be correct and the VM must be reachable
- The service principal password is marked sensitive in outputs — use `terraform output -raw grafana_client_secret` to retrieve it
- Change the default Grafana admin password after first login

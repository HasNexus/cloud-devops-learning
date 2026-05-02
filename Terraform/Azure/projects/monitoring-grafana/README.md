# monitoring-grafana
This Terraform configuration deploys an Azure Web App and a Linux VM with Grafana installed, connected to Azure Monitor as a data source through an Azure AD service principal.

# What it does
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

## Prerequisites

Before running this project (either locally or via the pipeline), you need to create a **service principal in Azure** for GitLab to use. This service principal needs the following permissions:

### Azure RBAC (Subscription level)
- **Contributor** — allows Terraform to create and manage all infrastructure resources
- **User Access Administrator** — allows Terraform to assign the Reader role to the Grafana service principal. Set a condition restricting this to only assigning the **Reader** role, so it cannot grant broader permissions

### Microsoft Entra ID roles
- **Cloud Application Administrator** — allows Terraform to create the Grafana app registration and service principal

Once created, store the service principal's credentials as GitLab CI/CD variables (see [Required GitLab CI/CD Variables](#required-gitlab-cicd-variables) below).

## How to use
- Copy `backend.hcl.template` to `backend.hcl` and fill in your storage account details
- Copy `terraform.tfvars.template` to `terraform.tfvars` and fill in your own values (subscription ID, SSH key paths, IP address, etc.)
- Run `terraform init -backend-config=backend.hcl`
- Run `terraform apply`
- Access Grafana at `http://<VM_PUBLIC_IP>:3000` (default credentials: `admin` / `admin`)

## Pipeline (GitLab CI/CD)
This project includes a `.gitlab-ci.yml` pipeline with five stages:
- **Validate** - runs `terraform validate`
- **Plan** - runs `terraform plan`
- **Deploy** - runs `terraform apply`, generates Ansible inventory. Auto-destroys resources if the job fails.
- **Configure** - runs Ansible playbook to update and restart the traffic script (only triggers when `grafana-traffic.yaml` or `traffic.sh` change)
- **Cleanup** - reserved for manual teardown jobs

### Required GitLab CI/CD Variables
Set these in **Settings → CI/CD → Variables**:

| Variable | Description | Sensitive |
|----------|-------------|-----------|
| `ARM_CLIENT_ID` | Service principal client ID | Yes |
| `ARM_CLIENT_SECRET` | Service principal secret | Yes |
| `ARM_TENANT_ID` | Azure tenant ID | Yes |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID (`TF_VAR_sub_id` is derived from this automatically) | Yes |
| `TF_BACKEND_RG` | Backend resource group name | No |
| `TF_BACKEND_SA` | Backend storage account name | No |
| `TF_BACKEND_CONTAINER` | Backend container name | No |
| `TF_VAR_location` | Azure region | No |
| `TF_VAR_ssh_key` | SSH public key contents | Yes |
| `TF_VAR_private_ssh_key` | SSH private key contents | Yes |

## Notes
- The Grafana provider connects to the VM's public IP on port 3000 — the VM and Grafana must be fully running before the provider resources are applied
- The `null_resource` provisioner handles copying and executing the setup scripts over SSH, so your private key path must be correct and the VM must be reachable
- The service principal password is marked sensitive in outputs — use `terraform output -raw grafana_client_secret` to retrieve it
- Change the default Grafana admin password after first login
- `TF_VAR_my_ip_address` is set to `0.0.0.0/0` in the pipeline since GitLab runners have dynamic IPs and your local IP would not work in CI. This opens Grafana port 3000 to the internet which is fine for now. A future improvement would be to restrict this to the GitLab runner IP range or use a VPN/bastion approach. I will try to update this in the future.



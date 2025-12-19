# vm-basic
This Terraform configuration creates a basic **Azure Virtual Machine** using modular structure with a:
- Resource group
- Virtual network, subnet, and NSG (SSH Only from Your IP)
- A static Public IP and network interface card
- Ubuntu 22.04 LTS VM

The configuration in this folder (`vm-basic`) calls the reusable resources defined in the **vm-basic-module** directory.

# What it does
- Creates a new **Resource Group** in your chosen region  
- Deploys a **Virtual Network**, **Subnet**, and **Network Security Group (NSG)** with inbound SSH limited to your IP  
- Creates a **Static Public IP** and **Network Interface Card (NIC)**  
- Provisions an **Ubuntu 22.04 LTS** VM  
- Outputs the **Public IP** of the VM for browser or SSH access  


# How to use
- Copy `terraform.tfvars.template` to `terraform.tfvars` or just rename .template to .tfvars
- Fill in your own values (subscription ID, SSH key path, IP address, etc.) 
- Run `terraform init` and `terraform apply` to create

# Notes
- All Variables are provided interactively through the CLI
- See 'vm-provisioned' project for a somewhat improved version of this with automated provisioning
- Variables are defined in the root variables.tf file and passed to the vm-basic-module automatically.
- Ensure your SSH key file exists at the path you specified.

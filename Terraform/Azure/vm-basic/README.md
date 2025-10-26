# vm-basic

This Terraform config creates a basic Azure Virtual Machine with a:
- Resource group
- Virtual network, subnet, and NSG (SSH Only from Your IP)
- A static Public IP and network interface card
- Ubuntu 22.04 LTS VM


# How to use
- Run `terraform init` and `terraform apply` to create

# Notes
- All Variables are provided interactively through the CLI
- This version does **not** use a .tfvars file
- See 'vm-provisioned' project for a somewhat improved version of this with automated provisioning and variable files

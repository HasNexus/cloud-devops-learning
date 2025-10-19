#vm-basic

This Terraform config creates a basic Azure Virtual Machine with a:
- Resource group
- Virtual network, subnet, and NSG (SSH Only from Your IP)
- A static Public IP and network interface card
- Ubuntu 22.04 LTS VM


#Notes
- All Variables are provided interactively through the CLI
- This version does **not** use a .tfvars file
- See 'vm-provisioned' for a somewhat improved version of this with automated provisioning and variable files
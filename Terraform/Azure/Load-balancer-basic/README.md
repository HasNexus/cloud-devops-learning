# Load-balancer-basic
This Terraform configuration demonstrates how to set up and configure a Load balancer.

# What it does:
1. Creates a new Resource Group in your chosen Azure region
2. Creates a Virtual Network, Subnet, and Network Security Group (NSG) to manage inbound SSH and HTTP access
3. Deploys three Linux Virtual Machines (VMs) based on the count function in Terraform
4. Creates Public IPs for each VM so Terraform can connect to them via SSH
5. Uses the remote-exec provisioner to install Apache2, update system packages, and configure an index.html file with a unique message for each VM
6. Creates a Public Load Balancer with a Frontend IP, Backend Pool, Health Probe, and Load Balancing Rule that distributes incoming HTTP traffic (port 80)across all VMs
7. Outputs the Load Balancer’s public IP address for web access


# How to use:
1. Copy `terraform.tfvars.template` to `terraform.tfvars`, or rename it directly  
2. Replace the placeholders with your values  
3. Run `terraform init` and `terraform apply` to create

# Things to know:
1. Each VM has its own Public IP for Terraform to SSH into during provisioning
2. A futre setup would use an Ansible configuration for post-deployment actions instead of multiple Public IPs
3. Future versions of this project will integrate Ansible to configure the VMs automatically.
4. Occasionally, during the first run, Terraform may display a “remote-exec provisioner error” caused by temporary SSH or provisioning delays. If this occurs, simply rerun `terraform apply` andd the deployment will continue successfully.

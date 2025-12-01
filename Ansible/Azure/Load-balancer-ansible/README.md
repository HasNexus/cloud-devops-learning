# Load-balancer-ansible
This Terraform configuration demonstrates how to set up and configure a Load balancer using Ansible.

# What it does:
1. Creates a new Resource Group in your chosen Azure region  
2. Creates a Virtual Network, Subnet, and Network Security Group (NSG) to manage inbound SSH and HTTP access  
3. Deploys three Linux Virtual Machines (VMs) using Terraform's count function  
4. Creates Public IPs for each VM so Ansible can connect to them via SSH  
5. Creates a Public Load Balancer with a Frontend IP configuration, Backend Pool, Health Probe, and Load Balancing Rule that distributes incoming HTTP (port 80) traffic across all VMs  
6. Outputs the Load Balancer's Public IP for web access and also outputs the Public IPs of the VMs to be added in the Ansible inventory file  
7. Ansible then connects to each VM via SSH to update packages, install Apache2, and write custom content to the `/var/www/html/index.html` file on each VM  

# Prerequisites:
1. This project must be used on a Linux system as Ansible does not work reliably on Windows  
2. Ansible must be installed before use on the control machine. You can follow the official installation guide:  
   https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html  
3. Generate or provide your own SSH keypair before deployment:  
   `ssh-keygen -t rsa -b 4096 -f tf-demo`  
4. Ensure the private key has restricted read-only permissions:  
   `chmod 400 tf-demo`  
5. After Terraform completes, you will see four Public IP outputs:  
   - The first three are for the VMs (used by Ansible)  
   - The fourth is for the Load Balancer  
6. Open `inventory.yaml.template` and replace the placeholder IPs with the actual VM Public IPs from Terraform’s output
7. Update the `ansible_ssh_private_key_file` path inside the same template.  
   If the key is stored in the same directory, use `./tf-demo`  
8. Rename the file from `inventory.yaml.template` to `inventory.yaml` once the edits are complete  

# How to use:
1. Copy `terraform.tfvars.template` to `terraform.tfvars`, or rename it directly  
2. Replace the placeholders with your own values  
3. Run the following commands:  
   `terraform init`  
   `terraform apply`  
4. After deployment, edit `inventory.yaml.template` as explained above and rename it to `inventory.yaml`  
5. From within the same directory, run the Ansible playbook on your control node which is the machine anisble was installed on:  
   `ansible-playbook web.yaml`  
   The `ansible.cfg` file already references the correct inventory file, so there’s no need to specify it manually.  
6. If you rename your inventory file or move it, update the `inventory` line in `ansible.cfg` to reflect the new path.  

# Things to know:
1. Each VM has its own Public IP to allow Ansible to SSH into them during post-deployment setup  
2. The `index.html` file written by Ansible contains unique content for each VM to demonstrate load balancing in action  
3. Future setups will focus on removing multiple Public IPs  
4. If you encounter an SSH handshake or "connection refused" error during the first run, rerun `terraform apply` and the deployment will continue successfully  
5. If Ansible reports a permission-related error, ensure your private key file permissions are set correctly with `chmod 400`
6. If Ansible mentions something related to a package missing it's most likely `ansible-core` which you can simply install. It will let you know the specifc error which you can resolve.
7. If the control node is a virtual machine in the cloud, remember to update the security rule in `network.tf` to allow ssh from it's IP. Otherwise it won't be able to reach the other VM's

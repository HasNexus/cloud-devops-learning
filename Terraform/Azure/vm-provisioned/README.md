#VM provision

Upgraded version of VM basic that adds:
- Provisioners to install apache2 and some packages to deploy a HMTL / CSS template
- NSG rule for inbound port 80 (HTTP)
- A .tfvars file to skip the tiring manual variable entry through the CLI
- Private and Public key paths instead of pasting the keys directly in the CLI


#What it does:
1. Creates a VM from Ubuntu 22.04 image
2. Connects to the vm through SSH using your private key
3. Runs 'web.sh' file to install apache 2, other packages and downloads a HTML / CSS template where it then unzips and copies/pastes it to /var/www/html location and then restarts apache2
4. Finally the public IP will show the website in your browser

#How to use:
1. Copy 'terraform.tfvars.template' to 'terraform.tfvars' or you can rename to terraform.tfvars instead
2. Replace the placeholders with your values
3. Run terraform init and terraform apply to create
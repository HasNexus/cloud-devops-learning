# Static-website-storage
This Terraform configuration demonstrates how to set up and configure a static website on an Azure Storage Account.

#What it does:
1. Creates a new Resource Group in your chosen Azure region  
2. Creates a Storage Account within that Resource Group  
3. Enables the static website feature on the Storage Account  
4. Uploads website files from your local folder into the `$web` container, which is automatically created when the static website is enabled (files will not be uploaded to `$web` until the static website resource has been created, as it `depends_on` it)  
5. Assigns the correct content type to the uploaded files (e.g., text/html) so they can be viewed correctly online  
6. Outputs the `primary web endpoint` so you can view the files directly in your browser using the generated URL  

To upload different files:
1. Place your folder containing the files in this directory  
2. Update `source_folder` in `terraform.tfvars`  
3. Run `terraform apply`  

#How to use:
1. Copy `terraform.tfvars.template` to `terraform.tfvars`, or rename it directly  
2. Replace the placeholders with your values  
3. Run `terraform init` and `terraform apply` to create

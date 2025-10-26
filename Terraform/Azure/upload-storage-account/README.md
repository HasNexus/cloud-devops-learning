# upload-storage-account
This Terraform configuration demonstrates how to upload a file to an Azure Storage Account.

#What it does:
1. Creates a new Resource Group in your chosen Azure region  
2. Creates a Storage Account within that Resource Group  
3. Creates a container inside the Storage Account to store uploaded files  
4. Uploads a single file (default: README.md) from your local folder into the container  
5. Assigns the correct content type to the uploaded file (e.g., text/plain) so it can be viewed correctly online  
6. Optionally, you can make the container public and view the file directly in your browser using its blob URL

To upload a different file:
1. Place your file in this folder.
2. Update "source_file" and "blob_name" in "terraform.tfvars".
3. Run `terraform apply`.

#How to use:
1. Copy 'terraform.tfvars.template' to 'terraform.tfvars' or you can rename to terraform.tfvars instead
2. Replace the placeholders with your values
3. Run terraform init and terraform apply to create

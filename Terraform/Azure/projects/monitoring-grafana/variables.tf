variable "sub_id" {
  description = "Please enter your Subscription ID"
  type        = string
}

variable "resource_group_name" {
  description = "The Resource Group where resources will be created"
  type        = string
  default = "monitoring-rg"
}

variable "location" {
  description = "Please enter the Azure location where resources will be created"
  type        = string
}

variable "prefix" {
  description = "Please enter the prefix which will be used for all resources"
  type        = string
  default = "tf-demo"
}

variable "ssh_key" {
  description = "Please enter SSH public key for VM admin user"
  type        = string
}

variable "private_ssh_key" {
  description = "Please enter the path to the private SSH key for VM admin user"
  type        = string
}

variable "my_ip_address" {
  description = "Please enter your public IP address with CIDR notation (e.g.,/32 for single IP)"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default = "azureuser"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    environment = "terraform"
    project     = "monitoring"
  }
}

variable "vnet_address_space" {
  description = "The address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_space" {
  description = "The address space for the Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "webapp_subnet_address_prefix" {
  description = "The address prefixes for the Web App Subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "app_service_plan_sku" {
  description = "The SKU of the App Service Plan"
  type        = string
  default     = "S1"
}

variable "docker_image_name" {
  description = "The Docker image to be used for the Web App"
  type        = string
  default     = "nginxdemos/hello:latest"
}


variable "docker_registry_url" {
  description = "The Docker registry URL"
  type        = string
  default     = "https://index.docker.io"
}

# variable "grafana_auth" {
#   description = "Authentication details for Grafana provider"
#   type        = map(string)
#   sensitive   = true
# }




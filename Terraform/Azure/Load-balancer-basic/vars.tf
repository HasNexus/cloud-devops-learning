variable "sub_id" {
  description = "The Subscription ID for the Azure Account"
  type        = string
  default     = "ecb50d31-507e-4df2-8e72-0100c3257230"
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "tf-demo"
}

variable "location" {
  description = "The region for your resources"
  type        = string
  default     = "UK South"
}

variable "ssh_key" {
  description = "Path to the SSH public key"
  type        = string
  default     = "tf-demo.pub"
}

variable "my_ip_address" {
  description = "Your IP address to allow SSH access"
  type        = string
  default     = "152.37.101.89/32"
}

variable "private_key" {
  description = "Path to the SSH private key"
  type        = string
  default     = "tf-demo"
}
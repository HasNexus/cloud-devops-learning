variable "sub_id" {
  description = "Please enter your Azure Subscription ID"
  type        = string
}

variable "rg_name" {
  description = "Please enter a name for the Resource Group"
  type        = string
}

variable "rg_location" {
  description = "Please enter a location for the Resource Group"
  type        = string
}

variable "stg_name" {
  description = "Please enter a name for the Storage Account"
  type        = string
}


variable "source_folder" {
  description = "Please enter the source folder containing the website files"
  type        = string
}


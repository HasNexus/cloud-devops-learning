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

variable "container_name" {
  description = "Please enter a name for the Storage Container"
  type        = string
}

variable "container_access" {
  description = "Please enter the access type for the Storage Container"
  type        = string
}

variable "blob_name" {
  description = "Please enter a name for the Blob"
  type        = string
}

variable "source_file" {
  description = "Please enter source file for the blob"
  type        = string
}

variable "content_type" {
  description = "Please enter the content type for the blob"
  type        = string
}
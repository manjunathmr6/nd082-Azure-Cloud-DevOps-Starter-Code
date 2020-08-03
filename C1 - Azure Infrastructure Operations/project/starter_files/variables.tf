variable "prefix" {
  type 	  = string
  description = "The prefix which should be used for all resources in this example"
  default = "udacitynd_assignement1"
}

variable "location" {
  type 	  = string
  description = "The Azure Region in which all resources in this example should be created."
  default     = "East US"
}

variable "admin_username" {
    type 	  = string
    description = "Default username for admin"
    default = "adminuser"
}

variable "admin_password" {
    type 	  = string
    description = "Default password for admin"
    default = "P@ssw0rd1234!"
}

variable "resource_groupname" {
  type 	  = string
  description = "The name of the resource group in which the resources are created"
  default     = "Udacity_Assignment_1"
}

variable "tags" {
    description = "Map the tags to use the resources that are deployed"
    type        = map(string)

    default = {
    Udacity = "Course1"
    
 }
}

variable "number_of_instance" {
    description = "The number of instance(s) that the vm sets will create"
    type 	  = number
    default       = 2
}
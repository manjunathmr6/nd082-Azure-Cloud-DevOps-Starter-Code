provider "azurerm" {
  version = "~> 2.16"
  features {
  }
}

terraform {
  backend "azurerm" {
    storage_account_name = "tstate31350"
    container_name       = "tstate"
    access_key           = "nqRFTEd9Sp3hcNSRkP3NFpXsrxhsCYeahwKtR8680J3ReT7x25U1e0Fs1FNfr31k8pXFH4d/DSG1eHQxOfGryQ=="
    key                  = "terraform.tfstate"
  }    
}

locals {
  tags = {
    tier       = var.tier
    deployment = var.deployment
  }
}

module "resource_group" {
  source         = "../../modules/resource_group"
  resource_group = var.resource_group
  location       = var.location
}

module "appservice" {
  source           = "../../modules/appservice"
  location         = var.location
  application_type = var.application_type
  resource_type    = "AppService"
  resource_group   = module.resource_group.resource_group_name
}

module "network" {
  source               = "../../modules/network"
  address_space        = var.address_space
  location             = var.location
  virtual_network_name = var.virtual_network_name
  application_type     = var.application_type
  resource_type        = "NET"
  resource_group       = module.resource_group.resource_group_name
  address_prefix_test  = var.address_prefix_test
  tags                 = var.tier
}

module "nsg" {
  source              = "../../modules/nsg"
  location            = var.location
  resource_group      = module.resource_group.resource_group_name
  resource_type       = "NSG"
  subnet_id           = module.network.subnet_id_test
  address_prefix_test = var.address_prefix_test
  application_type    = var.application_type
}

module "public_ip" {
  source           = "../../modules/public_ip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "public_ip"
  resource_group   = "${module.resource_group.resource_group_name}"
}

# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, you will write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

## Deploy a Policy
1. Login to Azure portal to create and apply Tagging Policy.
2. Go to Resources -> Policy -> Assign Policy -> Select the relevant policy which is required. 
3. Use `az policy assignment list` to verify the tag
For instructions on how to create and apply policy in Azure, click here: https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/tag-resources

#### Output
Output `az policy assignment list`
![alt text] https://github.com/manjunathmr6/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/Policy.png

## Build Packer Template
1. Create and alter the content present in `server.json` present in the local directory. (If not present, create the file)
2. Enter the valid values in the server.json by using `code server.json`
3. Run `packer build server.json` to create a machine image. 
Note: This would take few minutes to build

#### Output
Output of `packer build server.json`
![alt text] https://github.com/manjunathmr6/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/Packer.png


## Create the Infrastructure using Terraform Template
1. Create and alter the content present in `main.tf` and `variables.tf` present in the local directory. (If not present, create the file)
2. Enter the valid values in the server.json by using `code main.tf` and `variables.tf`.
3. Run `terraform init` to initialize  the Terraform environment.
4. Run `terraform  plan -out solution.plan` to review  and validate Terraform template.
5. Run `terraform apply solution.plan` to scan the current directory for the configuration and applies the changes appropriately.
6. Ensure that both plan and apply should execute with out any error.

#### Output
Output of `terraform  plan -out solution.plan`

![alt text]https://github.com/manjunathmr6/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/terraformapply.png

Output of `terraform apply solution.plan`

![alt text]https://github.com/manjunathmr6/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/terraformplan.png

Output of `terraform show`

![alt text]https://github.com/manjunathmr6/nd082-Azure-Cloud-DevOps-Starter-Code/blob/master/C1%20-%20Azure%20Infrastructure%20Operations/project/starter_files/terraformshow.png

Reference:
Microsoft Azure website                            
https://docs.microsoft.com/en-us/azure



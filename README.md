# Dev environment with Terraform & Azure

This project uses Terraform, to deploy an Azure Linux VM to serve as a remote development environment. Azure customdata is also used to bootstrap the VM with Docker. The infrastructure includes a virtual network, subnet, security group and more. 



## Prerequisites

- VScode
- Terraform installed 
- Azure subscription


## Run Locally

Clone the project

```bash
  git clone <https://link-to-project>
```

Go to the project directory

```bash
  cd <project directory>
```

Initialize Terraform
```bash
  Terraform Init 
```

Validate the configuration
```bash
  Terraform Validate
```
Plan the infrastructure
```bash
  Terraform plan
```
Apply the configuration
```bash
  Terraform apply
```
Access the resources
```bash
    use SSH as we created a keypair. ssh -i ~/.ssh/projectazkey adminuser@<public-ip> 
```
Check for Docker installation
```bash
  Docker --version
```
Destroy the infrastructure
```bash
  Terraform Destroy
```


## File Structure


`providers.tf` Contains providers used

`main.tf` Main Terraform configuration for the infrastructure. 

`outputs.tf` Defines the outputs that can be called

`variables.tf` Stores configurable variables for the project 

`terraform.tfvars` Contains values to be used for each   variable, overriding any default values set in variables.tf

`customdate.tpl` A script to bootstrap Docker onto the VM

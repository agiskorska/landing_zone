#!/bin/bash
environments=(dev prod)
rg_name=tfstate-rg-fizzbuzz
storage_name=tfstatestoragefizzbuzz
location=westeurope
# az login

az group create --name $rg_name --location $location
az storage account create --name $storage_name --resource-group $rg_name --location $location

az storage container create --name landintfstate --account-name $storage_name --auth-mode login
az storage container create --name infrtfstate --account-name $storage_name --auth-mode login
terraform init \
  -backend-config="resource_group_name=$rg_name" \
  -backend-config="storage_account_name=$storage_name" \
  -backend-config="container_name=landintfstate" \
  -backend-config="key=terraform.tfstate" 
terraform apply -var-file=variables.tfvars -auto-approve 

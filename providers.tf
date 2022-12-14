terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.39.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.31.0"
    }
    
  }
}

# Configure the AWS Provider
provider "aws" {
   access_key  = "${var.accesskey}"
   secret_key  = "${var.secretkey}"
   region      = "${var.awsregion}"
}

provider "azurerm" {
  client_id = "${var.clientid}"
  subscription_id ="${var.subscriptionid}"
  tenant_id = "${var.tenantid}"
  client_secret ="${var.clientsecret}"
  skip_provider_registration = "true"
  features {}
}

  #The configuration for the remote backend.
    
     terraform {
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "amat-tf"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
        workspaces {
           name = "aws-dev"
         }
       }
     }

 # terraform {
 #   backend "s3" {
 #    bucket = "backendtfamat"
 #    key    = "amattf.tfstate"
 #    region = "us-west-2"
 #    dynamodb_table = "amattf"
 #  }
 # }

##ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
##export ARM_ACCESS_KEY=$ACCOUNT_KEY

/*terraform {
  backend "azurerm" {
    resource_group_name  = "backendrg"
    storage_account_name = "backendsa"
    container_name       = "tfstatefile"
    key                  = "amat.tfapply.tfstate"
  }
}*/

provider "null" {
 
}

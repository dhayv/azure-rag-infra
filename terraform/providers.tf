# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.63"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.11.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.rg_name

}




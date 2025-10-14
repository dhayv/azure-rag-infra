# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
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

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Exposed ArgoCD API - authenticated using authentication token.
provider "argocd" {
  server_addr = "argocd.local:443"
  auth_token  = "1234..."
}

# Exposed ArgoCD API - authenticated using `username`/`password`
provider "argocd" {
  server_addr = "argocd.local:443"
  username    = "foo"
  password    = local.password
}
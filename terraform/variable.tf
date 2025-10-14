variable "rg_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "aks_name" {
  type        = string
  description = "Name for the AKS cluster"
}

variable "aks_dns_prefix" {
  type        = string
  description = "DNS prefix for the AKS cluster"
}

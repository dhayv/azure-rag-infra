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


variable "workload_sa_name" {
  type        = string
  description = "Kubernetes service account to permit"
}

variable "workload_sa_namespace" {
  type        = string
  description = "Kubernetes service account namespace to permit"
}

variable "azure_openai_api_key" {
  type        = string
  description = "Azure OpenAI API Key"
  sensitive   = true
}

variable "azure_openai_endpoint" {
  type        = string
  description = "Azure OpenAI Endpoint URL"
}

variable "azure_openai_api_version" {
  type        = string
  description = "Azure OpenAI API Version"
}

variable "azure_openai_embed_deployment" {
  type        = string
  description = "Azure OpenAI Embeddings Deployment Name"
}

variable "azure_openai_chat_deployment" {
  type        = string
  description = "Azure OpenAI Chat Deployment Name"
}

variable "azure_search_endpoint" {
  type        = string
  description = "Azure Search Endpoint URL"
}

variable "azure_search_api_key" {
  type        = string
  description = "Azure Search API Key"
  sensitive   = true
}

variable "azure_search_index" {
  type        = string
  description = "Azure Search Index Name"
}


data "azurerm_subscription" "current" {}

variable "workload_sa_name" {
  type        = string
  description = "Kubernetes service account to permit"
}

variable "workload_sa_namespace" {
  type        = string
  description = "Kubernetes service account namespace to permit"
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix
  kubernetes_version  = "1.26.3"

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}

resource "azurerm_user_assigned_identity" "myworkload_identity" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name                = "myworkloadidentity"
}

resource "azurerm_federated_identity_credential" "myworkload_identity" {
  name                = azurerm_user_assigned_identity.myworkload_identity.name
  resource_group_name = azurerm_user_assigned_identity.myworkload_identity.resource_group_name
  parent_id           = azurerm_user_assigned_identity.myworkload_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.default.oidc_issuer_url
  subject             = "system:serviceaccount:${var.workload_sa_namespace}:${var.workload_sa_name}"
}

data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

resource "azurerm_role_assignment" "example" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.contributor.role_definition_id
  principal_id       = azurerm_user_assigned_identity.myworkload_identity.principal_id
}

output "myworkload_identity_client_id" {
  description = "The client ID of the created managed identity to use for the annotation 'azure.workload.identity/client-id' on your service account"
  value       = azurerm_user_assigned_identity.myworkload_identity.client_id
}

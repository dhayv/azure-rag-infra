data "azurerm_subscription" "current" {}


data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = var.aks_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix

  default_node_pool {
    name            = "default"
    node_count      = 2
    vm_size         = "Standard_D2_v2"
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled = true

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

resource "azurerm_role_assignment" "acr-pull" {
  principal_id                     = azurerm_kubernetes_cluster.default.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = data.azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "default" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = data.azurerm_role_definition.contributor.role_definition_id
  principal_id       = azurerm_user_assigned_identity.myworkload_identity.principal_id
}


output "myworkload_identity_client_id" {
  description = "The client ID of the created managed identity to use for the annotation 'azure.workload.identity/client-id' on your service account"
  value       = azurerm_user_assigned_identity.myworkload_identity.client_id
}

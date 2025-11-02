provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.default.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.default.kube_config[0].host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate)
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  
  depends_on = [azurerm_kubernetes_cluster.default]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
}

resource "kubernetes_manifest" "platform_root" {
  manifest = yamldecode(file("${path.module}/../argocd/dev/platform-root.yaml"))
  
  depends_on = [helm_release.argocd]
}
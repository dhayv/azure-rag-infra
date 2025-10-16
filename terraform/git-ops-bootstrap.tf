data "azurerm_kubernetes_cluster" "main" {
  name                = var.aks_name
  resource_group_name = var.rg_name
}



provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }

  registries = [
    {
      url      = var.acr_name
      username = "username"
      password = "password"
    }
  ]
}


resource "kubernetes_namespace" "argocd" {
  metadata {
    annotations = {
      name = "argocd"
    }

  }

}

resource "helm_release" "argocd" {
  name        = "argocd"
  namespace   = kubernetes_namespace.argocd.metadata[0].name
  repository  = "https://argoproj.github.io/argo-helm"
  version     = "1.2.3"
  chart       = "argo-cd"
  values     = [file("${path.module}/values/argocd-values.yaml")]
}


# Exposed ArgoCD API - authenticated using `username`/`password`
provider "argocd" {
  server_addr = "argocd.local:443"
  username    = "foo"
  password    = local.password
}


resource "argocd_application" "kustomize" {
  metadata {
    name      = "kustomize-app"
    namespace = "argocd"
    labels = {
      test = "true"
    }
  }

  spec {
    project = "myproject"

    source {
      repo_url        = "https://github.com/dhayv/azure-rag-infra"
      path            = "examples/helloWorld"
      target_revision = "master"
      kustomize {
        name_prefix = "foo-"
        name_suffix = "-bar"
        images      = ["hashicorp/terraform:light"]
        common_labels = {
          "this.is.a.common" = "la-bel"
          "another.io/one"   = "true" 
        }
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "foo"
    }

    sync_policy {
      automated = {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit   = "5"
        backoff = {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }

    ignore_difference {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }

    ignore_difference {
      group         = "apps"
      kind          = "StatefulSet"
      name          = "someStatefulSet"
      json_pointers = [
        "/spec/replicas",
        "/spec/template/spec/metadata/labels/bar",
      ]
      # Only available from ArgoCD 2.1.0 onwards
      jq_path_expressions = [
        ".spec.replicas",
        ".spec.template.spec.metadata.labels.bar",
      ]
    }
  }
}


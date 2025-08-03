# RAG Infra – Azure GitOps Platform

This repository defines the **GitOps deployment layer** using ArgoCD's App-of-Apps pattern to deploy the RAG app Helm charts into AKS.

🔗 **Part of the full project:**  
→ [azure-gitops-platform](https://github.com/dhayv/azure-gitops-platform)

---

## 🧱 Structure


---

## 🚀 Responsibilities

- Deploys Helm charts from [`rag-app`](https://github.com/dhayv/azure-rag-app)
- Uses ArgoCD App-of-Apps for scalable multi-app management
- Manages environment config + chart version bumps

> This repo owns **declarative deployment** to AKS using GitOps.

---

## 🧪 Coming Soon

- Environment overlays (dev/staging/prod)  
- Kustomize or Jsonnet templating  
- ArgoCD auto-sync strategies


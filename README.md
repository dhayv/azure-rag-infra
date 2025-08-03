# RAG Infra – Azure GitOps Platform

This repository owns the **GitOps deployment layer** of the Azure RAG Platform. It simulates how real teams manage Kubernetes app delivery at scale — using ArgoCD's App-of-Apps pattern, Helm chart versioning, and modular rollout logic.

> Built for reproducibility, not demos. This system deploys production-ready workloads declaratively into AKS clusters.

🔗 **Part of the full project:**  → [azure-gitops-platform](https://github.com/dhayv/azure-gitops-platform)

---

## 🧱 Structure


---

## 🧠 Why This Repo?

Most engineers ship pipelines. **Fewer build deploy orchestration systems**. This repo is where infra meets strategy — owning **what deploys, when, and how.**

This marks the shift from executor to platform operator.

---

## 🚀 Responsibilities

- 🌀 Orchestrates **ArgoCD App-of-Apps** for multi-app environments
- 🎯 References Helm charts from [`rag-app`](https://github.com/dhayv/azure-rag-app)
- 🔁 Owns **chart version bump logic**, config overlays, and sync rules
- 📦 Simulates **real platform modularity** across dev/staging/prod

> This repo owns **declarative deployment** to AKS using GitOps.

---

## 🧪 Coming Soon

- Environment overlays (dev/staging/prod)  
- Kustomize or Jsonnet templating  
- ArgoCD auto-sync strategies


# RAG Infra – Azure GitOps Control Layer

**Azure | AKS | Kubernetes | GitOps | Argo CD | CI/CD | Platform Architecture | Declarative Infrastructure**

This repository governs the **GitOps control plane** for the Azure RAG Platform.  
It defines the reproducible pattern of **declarative application delivery** into AKS, with Argo CD orchestrating Kubernetes workloads at scale.

> A delivery system by design — professional, reproducible, and structured to extend into multi-service platform operations.

🔗 **System Architecture** → This repository governs the **delivery control layer** of the Azure GitOps Platform.  
The companion repo [azure-rag-app](https://github.com/dhayv/azure-rag-app) manages the **workload layer**.  
Together, they form a unified platform architecture for declarative delivery into AKS.  

---

## 🧱 Structure

- **Namespace** → isolates the RAG application (`ragapp`)  
- **Deployment** → FastAPI app with replicas + health checks  
- **Service** → exposes the app internally and via LoadBalancer  
- **Secrets** → manages Azure credentials for RAG integration  
- **Argo CD Root App** → directs this repo declaratively into AKS  

---

## 🧠 Why This Repo?

Most engineers ship pipelines. **Fewer design the control layer that governs delivery.**  
This repo shows how to own **what ships, when, and how** — with Git as the source of truth, Argo CD as the orchestrator, and AKS as the execution platform.  

It marks the shift from executor to **platform operator and architect**.

---

## 🚀 Responsibilities

- ✅ Installs and configures **Argo CD** in AKS  
- ✅ Deploys the RAG API into a dedicated namespace  
- ✅ Owns manifests for Deployment, Service, Namespace, and Secrets  
- ✅ Directs the **GitOps reconciliation loop**: Git → Argo CD → AKS  

---

## 🧪 Roadmap

- Extend into **App-of-Apps orchestration** for rag-infra + rag-app separation  
- Introduce **Helm chart packaging** to manage versioned rollouts  
- Add **environment overlays** (dev/staging/prod) for controlled promotion  
- Expand repo to govern **multi-app deployments** beyond ragapp  
- Layer **policy guardrails** (RBAC, sync rules, compliance checks) for enterprise delivery  

---

## 📌 Takeaway

This repo is the **GitOps control entry point** for the Azure RAG Platform.  
It governs delivery with **declarative manifests + Argo CD orchestration**, structured to scale into multi-service, multi-environment operations.  

A delivery system, owned declaratively, and architected for forward growth.
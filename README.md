# RAG Infra – Azure GitOps Control Layer

**Azure | AKS | Kubernetes | Workload Identity | Terraform | Argo CD | GitOps**

The `infra/` directory is the standalone `azure-rag-infra` repository.  
It owns everything required to stand up the cluster, install Argo CD, and keep the `rag-app` workload synchronized across environments.

---

## 📁 What Lives Here

| Path | Purpose |
| --- | --- |
| `apps/apps.yaml` | Root Argo CD Application (app-of-apps) that points at this repo. |
| `apps/{dev,staging,prod}/*.yaml` | Environment-specific Applications that sync `rag-app/argocd/<env>` from the workload repo. |
| `argo-cdnamespace.yaml` | Namespace bootstrap for the Argo CD control plane. |
| `terraform/` | Azure + AKS bootstrap: cluster, namespaces, workload identity, AcrPull role, and per-env secrets. |
| `commands.env` | Helper CLI snippets for provisioning Azure OpenAI deployments. |

---

## 🚀 Bootstrap AKS + Argo CD (Terraform)
1. `cd infra/terraform`
2. Populate `terraform.tfvars` with your subscription, resource group, AKS name, ACR name, and Azure OpenAI / AI Search credentials.
3. `terraform init`
4. `terraform apply`

What Terraform does:
- Creates/reads the resource group and ACR you specify.
- Provisions the AKS cluster with OIDC + workload identity enabled.
- Grants the cluster `AcrPull`, plus deploys a user-assigned identity and federated credential for your service account.
- Creates namespaces: `argocd`, `ragapp-dev`, `ragapp-staging`, `ragapp-prod`.
- Injects the `rag-api-env` secret into each environment using the `AZURE_*` variables from `terraform.tfvars`.

`output.myworkload_identity_client_id` is printed at the end; annotate your Kubernetes service account with this value if you expand to workload identity–based Azure SDK auth.

---

## 🔁 Wire Up the GitOps Loop
1. Ensure the Argo CD namespace exists: `kubectl apply -f infra/argo-cdnamespace.yaml`.
2. Install Argo CD (helm, manifests, or the official install method).
3. Register the root application:
   ```bash
   kubectl apply -n argocd -f infra/apps/apps.yaml
   ```
4. The root app creates the environment apps defined in `apps/{dev,staging,prod}` which in turn sync the manifests living in the workload repo (`rag-app/argocd/<env>`).
5. Edit the image tag or configuration in the workload repo, merge to `main`, and let Argo CD reconcile.

---

## 🔐 Secrets & Config
- `kubernetes_secret.rag_api_env_*` in Terraform sources all required Azure keys per environment.
- Secrets are written as `Opaque` and referenced by the workload Deployment via `envFrom`.
- Update secret values by editing `terraform.tfvars` and reapplying; Argo CD will roll pods once Kubernetes reports the new secret.

---

## ➕ Extending the Control Plane
- **New environment** → add another namespace + secret in Terraform, create a matching `apps/<env>/<env>-apps.yaml`, and point it at a new `rag-app/argocd/<env>` folder.
- **Additional workloads** → add Applications under `apps/` that reference other repos or paths; Argo CD handles the rest.
- **Policies / RBAC** → layer them via additional Terraform resources or Kubernetes manifests in this repo to keep governance declarative.

This folder is the contract between Azure and Git. Keep it lean, declarative, and versioned so platform operations stay repeatable.

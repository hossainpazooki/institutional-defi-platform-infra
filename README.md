# institutional-defi-platform-infra

Infrastructure-as-Code for the Institutional DeFi Platform. Manages AWS resources and Kubernetes deployments.

> **Topology (2026-08-02):** `institutional-defi-platform-api` is
> **decommissioned**. Its `api`/`worker` deployments, `api` service,
> ServiceAccount, ExternalSecret, HPAs, PDBs, ECR repositories, ingress routes
> and CD pipelines have been removed from this repo. The shared platform (VPC,
> EKS, ElastiCache, Secrets Manager) remains, and `regulatory-workbench` is now
> the only workload deployed here. The `local` and `prod` overlays were removed
> with the API — both existed solely to deploy `api`/`worker`, and the `prod`
> namespace was never created on the cluster. The EKS→Vercel cross-border
> cutover staged in `terraform/dns-vercel-cutover.tf.disabled` was **abandoned,
> not completed** (see `dev/briefs/phase-summaries/F-eks-cleanup.md`).

> **Do not run a bare `terraform apply` on this repo.** As of 2026-08-02 the
> committed configuration has drifted far from remote state: both RDS instances
> were deleted out-of-band, the IRSA roles have been refactored under
> `module.pod_roles` without ever being applied, and a full plan wants to
> **replace the EKS managed node group** — which would take down every running
> pod. Scope every apply with `-target` until that drift is reconciled
> deliberately.

## Repository Structure

```
terraform/          Terraform root module (VPC, EKS, RDS, ElastiCache, ECR, Secrets Manager)
  envs/             Environment-specific variable overrides (dev.tfvars, prod.tfvars)
modules/iam/        IAM role modules
  builder/          GitHub Actions OIDC role for ECR push
  provisioner/      GitHub Actions OIDC role for Terraform + kubectl (infra repo)
  pod/              IRSA roles (ALB controller, ESO, application SA)
kube/               Kubernetes manifests (Kustomize)
  base/             Base resources (regulatory-workbench, namespace, network policies)
  overlays/         Environment overlays (dev)
  cluster/          Cluster-scoped resources (ClusterSecretStore)
  temporal/         Temporal Helm chart values
.github/workflows/  CD pipeline (dev) + security scanning
```

## Terraform

`app_db_password` and `temporal_db_password` are not in the tfvars files — set
them as `TF_VAR_*` environment variables at plan/apply time.

```bash
cd terraform
terraform init
terraform plan -var-file=envs/dev.tfvars -target=<resource>   # see drift warning above
```

## Kubernetes Deployment

```bash
# Dev (EKS)
kubectl apply -k kube/overlays/dev/
```

## IAM Role Architecture

| Role | Purpose | Trust |
|------|---------|-------|
| `institutional-defi-build-cd-role` | ECR push | GitHub OIDC → `var.api_repo_name` (still the decommissioned API repo — retarget before use) |
| `institutional-defi-provision-cd-role` | EKS + kubectl | GitHub OIDC → infra repo |
| `institutional-defi-alb-controller` | ALB management | IRSA → kube-system SA |
| `institutional-defi-eso` | Secrets Manager read | IRSA → external-secrets SA |
| `institutional-defi-idpa-sa` | App secrets access | IRSA → idpa-sa SA |
| `institutional-defi-ebs-csi` | EBS volume management | IRSA → ebs-csi SA |

## Related Repositories

- [institutional-defi-platform-api](https://github.com/hossainpazooki/institutional-defi-platform-api) — **decommissioned 2026-08-02**, archived locally under `dev/archive/`. Historical only.
- `regulatory-rule-engine` / ATLAS — owns the `regulatory-workbench` frontend this repo deploys.

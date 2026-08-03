# institutional-defi-platform-infra

> # DECOMMISSIONED — 2026-08-03
>
> **This repository is a historical record. Nothing it describes is running.**
> The entire AWS footprint was destroyed on 2026-08-03 to terminate billing.
> `terraform state list` returns **0 resources**.
>
> Verified destroyed (probed against the AWS API, not read from the apply log):
> EKS cluster `institutional-defi-eks`, VPC `vpc-02e984d4935c6f79d` and its 9
> subnets, the NAT gateway and its Elastic IP, the ElastiCache replication group
> `institutional-defi-redis`, all 3 Secrets Manager secrets, the cluster log
> group, and all project IAM roles, policies and the OIDC provider.
> Both RDS instances had already been deleted out-of-band beforehand.
>
> **Do not run `terraform apply` on this repo.** State is empty, so an apply
> would not reconcile anything — it would **recreate the entire platform from
> scratch** and restart billing.

## What survived the teardown

| Item | Why | Cost |
|---|---|---|
| KMS CMK `d1be8a51…` (EKS encryption) | `PendingDeletion`, 30-day window; a customer-managed key bills until the window expires | ~$1/mo, then $0 |
| RDS final snapshots `final-institutional-defi-{app,temporal}…` | Not terraform-managed; the last remaining copy of the database contents | ~$3.80/mo |
| S3 bucket `institutional-defi-terraform-state` | Holds the (now empty) state file, 1 object | negligible |
| Container images | Archived locally at `dev/archive/institutional-defi-ecr-images/`, proven restorable before ECR was destroyed | $0 |

The RDS snapshots are a **data-retention decision, not a billing one** — deleting
them discards the only surviving database contents.

## Prior history

`institutional-defi-platform-api` was decommissioned first (2026-08-02): its
`api`/`worker` deployments, service, ServiceAccount, ExternalSecret, HPAs, PDBs,
ECR repositories, ingress routes and CD pipelines were removed from this repo,
leaving `regulatory-workbench` as the only workload. The `local` and `prod`
overlays went with it — both existed solely to deploy `api`/`worker`, and the
`prod` namespace was never created on the cluster. The EKS→Vercel cross-border
cutover staged in `terraform/dns-vercel-cutover.tf.disabled` was **abandoned,
not completed** (see `dev/briefs/phase-summaries/F-eks-cleanup.md`).

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

## Terraform (historical)

`dns.tf` was removed during teardown — it was never applied, nothing referenced
it, and its `data "aws_lb"` pointed at an ALB that had already been deleted.

`app_db_password` and `temporal_db_password` were never in the tfvars files —
they were supplied as `TF_VAR_*` environment variables at plan/apply time.

## Kubernetes Deployment (historical)

The `dev` overlay targeted the now-destroyed EKS cluster. `kubectl apply -k
kube/overlays/dev/` has no cluster to talk to.

## IAM Role Architecture (all destroyed 2026-08-03)

| Role | Purpose | Trust |
|------|---------|-------|
| `institutional-defi-build-cd-role` | ECR push | GitHub OIDC → `var.api_repo_name` |
| `institutional-defi-provision-cd-role` | EKS + kubectl | GitHub OIDC → infra repo |
| `institutional-defi-alb-controller` | ALB management | IRSA → kube-system SA |
| `institutional-defi-eso` | Secrets Manager read | IRSA → external-secrets SA |
| `institutional-defi-idpa-sa` | App secrets access | IRSA → idpa-sa SA |
| `institutional-defi-ebs-csi` | EBS volume management | IRSA → ebs-csi SA |

## Related Repositories

- [institutional-defi-platform-api](https://github.com/hossainpazooki/institutional-defi-platform-api) — **decommissioned 2026-08-02**, archived locally under `dev/archive/`. Historical only.
- `regulatory-rule-engine` / ATLAS — owns the `regulatory-workbench` frontend this repo deploys.

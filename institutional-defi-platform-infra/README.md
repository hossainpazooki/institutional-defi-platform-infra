# institutional-defi-platform-infra

Infrastructure-as-Code for the Institutional DeFi Platform. Manages AWS resources and Kubernetes deployments.

## Repository Structure

```
terraform/          Terraform root module (VPC, EKS, RDS, ElastiCache, ECR, Secrets Manager)
  envs/             Environment-specific variable overrides (dev.tfvars, prod.tfvars)
modules/iam/        IAM role modules
  builder/          GitHub Actions OIDC role for ECR push (API repo)
  provisioner/      GitHub Actions OIDC role for Terraform + kubectl (infra repo)
  pod/              IRSA roles (ALB controller, ESO, application SA)
kube/               Kubernetes manifests (Kustomize)
  base/             Base resources (deployments, services, HPAs, PDBs, network policies)
  overlays/         Environment overlays (local, dev, prod)
  cluster/          Cluster-scoped resources (ClusterSecretStore)
  temporal/         Temporal Helm chart values
.github/workflows/  CD pipelines (dev, staging, production) + security scanning
```

## Terraform

```bash
cd terraform
terraform init
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```

## Kubernetes Deployment

```bash
# Local (Minikube)
kustomize build kube/overlays/local | kubectl apply -f -

# Dev (EKS)
kubectl apply -k kube/overlays/dev/

# Production (EKS) — uses envsubst for image tags
export ECR_REGISTRY=547729607601.dkr.ecr.us-east-1.amazonaws.com
export IMAGE_TAG=v1.0.0
kustomize build kube/overlays/prod | envsubst | kubectl apply -f -
```

## IAM Role Architecture

| Role | Purpose | Trust |
|------|---------|-------|
| `institutional-defi-build-cd-role` | ECR push | GitHub OIDC → API repo |
| `institutional-defi-provision-cd-role` | EKS + kubectl | GitHub OIDC → infra repo |
| `institutional-defi-alb-controller` | ALB management | IRSA → kube-system SA |
| `institutional-defi-eso` | Secrets Manager read | IRSA → external-secrets SA |
| `institutional-defi-idpa-sa` | App secrets access | IRSA → idpa-sa SA |
| `institutional-defi-ebs-csi` | EBS volume management | IRSA → ebs-csi SA |

## Related Repositories

- [institutional-defi-platform-api](https://github.com/hossa/institutional-defi-platform-api) — Application code, CI pipeline

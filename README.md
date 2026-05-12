# 🌍 Terraform Multiple Environments

A hands-on reference project demonstrating **two battle-tested strategies** for managing multiple deployment environments (dev, staging, prod) using Terraform — without duplicating your configuration.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Repository Structure](#repository-structure)
- [Approach 1 — tfvars Files](#approach-1--tfvars-files)
- [Approach 2 — Terraform Workspaces](#approach-2--terraform-workspaces)
- [Comparison](#comparison)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Best Practices](#best-practices)

---

## Overview

Managing infrastructure across multiple environments is one of the most common challenges in DevOps. This project explores two native Terraform approaches side-by-side:

| Strategy | Folder |
|---|---|
| Variable files (`.tfvars`) | `tfvars/` |
| Terraform Workspaces | `workspaces/` |

Both approaches let you maintain a **single source of truth** for your infrastructure code while deploying environment-specific configurations independently.

---

## Repository Structure

```
terraform-multiple-environment/
├── tfvars/               # Approach 1: Environment-specific .tfvars files
│   ├── main.tf
│   ├── variables.tf
│   ├── dev.tfvars
│   ├── staging.tfvars
│   └── prod.tfvars
│
└── workspaces/           # Approach 2: Terraform Workspaces
    ├── main.tf
    └── variables.tf
```

---

## Approach 1 — tfvars Files

Each environment gets its own `.tfvars` file that overrides variable defaults. The Terraform configuration (`main.tf`, `variables.tf`) remains shared and unchanged across all environments.

### How it works

```hcl
# variables.tf
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}
```

```hcl
# dev.tfvars
instance_type = "t3.small"
environment   = "dev"
```

```hcl
# prod.tfvars
instance_type = "t3.xlarge"
environment   = "prod"
```

### Deploy with tfvars

```bash
# Development
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Staging
terraform plan  -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"

# Production
terraform plan  -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

## Approach 2 — Terraform Workspaces

Workspaces create isolated state files for the same configuration. The active workspace name is accessible via `terraform.workspace`, allowing you to branch logic inside your HCL.

### How it works

```hcl
# main.tf
locals {
  instance_types = {
    dev     = "t3.small"
    staging = "t3.medium"
    prod    = "t3.xlarge"
  }

  instance_type = local.instance_types[terraform.workspace]
}
```

### Deploy with Workspaces

```bash
# Create workspaces (one-time setup)
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod

# Switch to a workspace and apply
terraform workspace select dev
terraform init
terraform plan
terraform apply

terraform workspace select prod
terraform plan
terraform apply
```

### List and check workspaces

```bash
terraform workspace list     # List all workspaces
terraform workspace show     # Show current workspace
```

---

## Comparison

| Feature | tfvars Files | Workspaces |
|---|---|---|
| State isolation | Manual (separate backends) | Built-in per workspace |
| Config reuse | ✅ Same `.tf` files | ✅ Same `.tf` files |
| Environment visibility | Via `-var-file` flag | Via `terraform.workspace` |
| Best for | Environments with very different configs | Environments that are mostly identical |
| CI/CD integration | Straightforward | Straightforward |
| Risk of cross-env impact | Low (explicit flag required) | Low (isolated state) |

> **Rule of thumb:** Use **tfvars** when environments differ significantly in structure. Use **workspaces** when environments share the same shape but differ only in values.

---

## Getting Started

### Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.0`
- An AWS account with credentials configured (or the relevant cloud provider)
- AWS CLI configured (`aws configure`) or environment variables set:

```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

---

## Usage

### Using the tfvars approach

```bash
cd tfvars/

terraform init

# Plan and apply for a specific environment
terraform plan  -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"

# Destroy when done
terraform destroy -var-file="dev.tfvars"
```

### Using the workspaces approach

```bash
cd workspaces/

terraform init

# Create and use a workspace
terraform workspace new dev
terraform workspace select dev
terraform plan
terraform apply

# Switch environments
terraform workspace select prod
terraform plan
terraform apply
```

---

## Best Practices

- **Never apply prod without a plan review.** Always run `terraform plan` first, especially in production.
- **Use remote state** (e.g. S3 + DynamoDB for AWS) to enable team collaboration and state locking.
- **Separate backends per environment** when using tfvars — avoids accidental state overwrites.
- **Tag resources** with the environment name for cost tracking and clarity.
- **Use CI/CD pipelines** to automate `plan` on pull requests and `apply` on merge to the target branch.

---

## Author

**Shankar** — [@Shankar-codes](https://github.com/Shankar-codes)

---

## License

This project is open source and available under the [MIT License](LICENSE).

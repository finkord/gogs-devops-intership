
# Terraform Gogs Infrastructure Deployment

This repository provisions and manages cloud infrastructure to deploy the **Gogs** self-hosted Git service on **Amazon Web Services (AWS)**. It is developed as part of a DevOps internship project using **Terraform** for Infrastructure as Code and **GNU Make** for workflow automation.

The architecture is container-based, using **Amazon ECS with Fargate**, and integrates CI/CD pipelines and secure networking. The infrastructure is modular, reproducible, and suitable for production use.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [GNU Make](https://www.gnu.org/software/make/)
- AWS CLI configured with valid credentials (`aws configure`)

## Directory Structure

```text
├── envs/         # Environment-specific configurations (e.g., dev/, global/)
├── modules/      # Reusable infrastructure modules (VPC, ECS, etc.)
├── Makefile      # Task automation for all common actions
└── README.md
```

## Usage

All infrastructure actions are performed using `make` commands. The main variables are:

- `ENV` — Environment (default: `dev`)
- `SERVICE` — Service/component (e.g., `vpc`, `alb`, `rds`, etc.)

### Common Commands

1. **Initialize Terraform for a Service**

   ```sh
   make init ENV=dev SERVICE=vpc
   ```

2. **Plan Infrastructure Changes**

   ```sh
   make plan ENV=dev SERVICE=vpc
   ```

3. **Apply Changes**

   ```sh
   make apply ENV=dev SERVICE=vpc
   ```

4. **Show Outputs**

   ```sh
   make output ENV=dev SERVICE=vpc
   ```

5. **Destroy Infrastructure**

   ```sh
   make destroy ENV=dev SERVICE=vpc
   ```

### Convenience Shortcuts

You can use shortcut targets for common services, e.g.:

```sh
make vpc-init
make vpc-plan
make vpc-apply
make vpc-destroy
```

See the [Makefile](Makefile) for all available shortcuts.

### Full Deployment Order

To deploy the full stack, run the following in order (adjust as needed for your environment):

1. **Global resources (e.g., ECR, S3):**
   ```sh
   make ecr-apply
   make s3-apply
   ```

2. **Networking and security:**
   ```sh
   make vpc-apply
   make sg-apply
   ```

3. **Core infrastructure:**
   ```sh
   make rds-apply
   make efs-apply
   make alb-apply
   make endpoints-apply
   make route53-apply
   ```

4. **Application and supporting services:**
   ```sh
   make ecs-apply
   make iam-apply
   make jenkins-apply
   make ebs-apply
   ```

**Tip:** Always run `make plan` before `make apply` to review changes.

## Cleaning Up

To remove all resources for a service:

```sh
make destroy ENV=dev SERVICE=<service>
```

Or use the shortcut:

```sh
make vpc-destroy
```

## Help

List all available commands:

```sh
make help
```

---

For more details, see the [Makefile](Makefile) and the `envs/` directory for service-specific configurations.


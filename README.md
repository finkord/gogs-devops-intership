
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
   make apply-auto ENV=global SERVICE=ecr
   make apply-auto ENV=global SERVICE=s3
   ```

2. **Networking and security:**
   ```sh
   make apply-auto ENV=dev SERVICE=vpc
   make apply-auto ENV=dev SERVICE=sg
   ```

3. **Core infrastructure:**
   ```sh
   make apply-auto ENV=dev SERVICE=rds
   make apply-auto ENV=dev SERVICE=efs
   make apply-auto ENV=dev SERVICE=alb
   make apply-auto ENV=dev SERVICE=endpoints
   make apply-auto ENV=dev SERVICE=route53
   make apply-auto ENV=dev SERVICE=iam
   ```

4. **Application:**
   ```sh
   make apply-auto ENV=dev SERVICE=ecs
   ```


```
   make apply-auto ENV=dev SERVICE=jenkins
   make apply-auto ENV=dev SERVICE=ebs
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


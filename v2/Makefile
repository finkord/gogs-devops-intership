# Terraform Makefile for Windows
# Usage: make <command> ENV=dev SERVICE=ecr

# Default values
ENV ?= dev
SERVICE ?= 
TERRAFORM_DIR = envs\$(ENV)\$(SERVICE)

# Check if required parameters are set
check-params:
ifeq ($(SERVICE),)
	@echo Error: SERVICE parameter is required
	@echo Usage: make plan ENV=dev SERVICE=ecr
	@exit 1
endif

# Initialize Terraform
init: check-params
	@echo Initializing Terraform in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform init

# Plan Terraform changes
plan: check-params
	@echo Planning Terraform changes in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform plan

# Apply Terraform changes
apply: check-params
	@echo Applying Terraform changes in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform apply

# Apply with auto-approve
apply-auto: check-params
	@echo Auto-applying Terraform changes in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform apply -auto-approve

# Destroy Terraform resources
destroy: check-params
	@echo Destroying Terraform resources in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform destroy

# Destroy with auto-approve
destroy-auto: check-params
	@echo Auto-destroying Terraform resources in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform destroy -auto-approve

# Validate Terraform configuration
validate: check-params
	@echo Validating Terraform configuration in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform validate

# Format Terraform files
fmt: check-params
	@echo Formatting Terraform files in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform fmt -recursive

# Show current state
show: check-params
	@echo Showing current state in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform show

# Show output values
output: check-params
	@echo Showing output values in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform output

# Clean up Terraform files
clean: check-params
	@echo Cleaning up Terraform files in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && if exist .terraform rmdir /s /q .terraform
	cd $(TERRAFORM_DIR) && if exist terraform.tfstate.backup del terraform.tfstate.backup
	cd $(TERRAFORM_DIR) && if exist .terraform.lock.hcl del .terraform.lock.hcl

# Workspace commands
workspace-list: check-params
	@echo Listing workspaces in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform workspace list

workspace-new: check-params
	@echo Creating new workspace $(WORKSPACE) in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform workspace new $(WORKSPACE)

workspace-select: check-params
	@echo Selecting workspace $(WORKSPACE) in $(TERRAFORM_DIR)
	cd $(TERRAFORM_DIR) && terraform workspace select $(WORKSPACE)

# Convenience commands for your current structure
# ECR commands
ecr-init:
	@$(MAKE) init ENV=dev SERVICE=ecr

ecr-plan:
	@$(MAKE) plan ENV=dev SERVICE=ecr

ecr-apply:
	@$(MAKE) apply ENV=dev SERVICE=ecr

ecr-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=ecr

# ECS commands
ecs-init:
	@$(MAKE) init ENV=dev SERVICE=ecs

ecs-plan:
	@$(MAKE) plan ENV=dev SERVICE=ecs

ecs-apply:
	@$(MAKE) apply ENV=dev SERVICE=ecs

ecs-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=ecs

# VPC commands
vpc-init:
	@$(MAKE) init ENV=dev SERVICE=vpc

vpc-plan:
	@$(MAKE) plan ENV=dev SERVICE=vpc

vpc-apply:
	@$(MAKE) apply ENV=dev SERVICE=vpc

vpc-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=vpc

# RDS commands
rds-init:
	@$(MAKE) init ENV=dev SERVICE=rds

rds-plan:
	@$(MAKE) plan ENV=dev SERVICE=rds

rds-apply:
	@$(MAKE) apply ENV=dev SERVICE=rds

rds-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=rds

# Endpoints commands
endpoints-init:
	@$(MAKE) init ENV=dev SERVICE=endpoints

endpoints-plan:
	@$(MAKE) plan ENV=dev SERVICE=endpoints

endpoints-apply:
	@$(MAKE) apply ENV=dev SERVICE=endpoints

endpoints-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=endpoints

# SG commands
sg-init:
	@$(MAKE) init ENV=dev SERVICE=sg

sg-plan:
	@$(MAKE) plan ENV=dev SERVICE=sg

sg-apply:
	@$(MAKE) apply ENV=dev SERVICE=sg

sg-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=sg

# s3 commands
s3-init:
	@$(MAKE) init ENV=dev SERVICE=s3

s3-plan:
	@$(MAKE) plan ENV=dev SERVICE=s3

s3-apply:
	@$(MAKE) apply ENV=dev SERVICE=s3

s3-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=s3

# EFS commands
efs-init:
	@$(MAKE) init ENV=dev SERVICE=efs

efs-plan:
	@$(MAKE) plan ENV=dev SERVICE=efs

efs-apply:
	@$(MAKE) apply ENV=dev SERVICE=efs

efs-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=efs

# ALB commands
alb-init:
	@$(MAKE) init ENV=dev SERVICE=alb

alb-plan:
	@$(MAKE) plan ENV=dev SERVICE=alb

alb-apply:
	@$(MAKE) apply ENV=dev SERVICE=alb

alb-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=alb

# Route53 commands
route53-init:
	@$(MAKE) init ENV=dev SERVICE=route53

route53-plan:
	@$(MAKE) plan ENV=dev SERVICE=route53

route53-apply:
	@$(MAKE) apply ENV=dev SERVICE=route53

route53-destroy:
	@$(MAKE) destroy ENV=dev SERVICE=route53

# Help command
help:
	@echo Available commands:
	@echo   init         - Initialize Terraform
	@echo   plan         - Plan Terraform changes
	@echo   apply        - Apply Terraform changes
	@echo   apply-auto   - Apply with auto-approve
	@echo   destroy      - Destroy Terraform resources
	@echo   destroy-auto - Destroy with auto-approve
	@echo   validate     - Validate Terraform configuration
	@echo   fmt          - Format Terraform files
	@echo   show         - Show current state
	@echo   output       - Show output values
	@echo   clean        - Clean up Terraform files
	@echo   workspace-*  - Workspace management commands
	@echo Convenience commands:
	@echo   ecr-init, ecr-plan, ecr-apply, ecr-destroy
	@echo   vpc-init, vpc-plan, vpc-apply, vpc-destroy
	@echo   rds-init, rds-plan, rds-apply, rds-destroy
	@echo   endpoints-init, endpoints-plan, endpoints-apply, endpoints-destroy
	@echo   sg-init, sg-plan, sg-apply, sg-destroy
	@echo   s3-init, s3-plan, s3-apply, s3-destroy
	@echo   efs-init, efs-plan, efs-apply, efs-destroy	
	@echo   alb-init, alb-plan, alb-apply, alb-destroy
	@echo   route53-init, route53-plan, route53-apply, route53-destroy
	@echo Usage examples:
	@echo   make plan ENV=dev SERVICE=ecr
	@echo   make apply ENV=dev SERVICE=vpc
	@echo   make ecr-plan
	@echo   make vpc-apply

.PHONY: check-params init plan apply apply-auto destroy destroy-auto validate fmt show output clean workspace-list workspace-new workspace-select ecr-init ecr-plan ecr-apply ecr-destroy ecs-init ecs-plan ecs-apply ecs-destroy vpc-init vpc-plan vpc-apply vpc-destroy rds-init rds-plan rds-apply rds-destroy endpoints-init endpoints-plan endpoints-apply endpoints-destroy sg-init sg-plan sg-apply sg-destroy s3-init s3-plan s3-apply s3-destroy efs-init efs-plan efs-apply efs-destroy alb-init alb-plan alb-apply alb-destroy route53-init route53-plan route53-apply route53-destroy help


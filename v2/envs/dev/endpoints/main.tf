# ------------------------------------------------------------------------------
# VPC Interface Endpoints for ECS, ECR, CloudWatch, and SSM
#
# This module provisions the required AWS VPC Interface Endpoints to allow ECS
# tasks running in private subnets to interact with the following services
# **without requiring internet access**:
#
# - Amazon ECR (Elastic Container Registry):
#     * ecr.dkr         — for pulling Docker images
#     * ecr.api         — for ECR API access
#
# - Amazon CloudWatch:
#     * logs            — for ECS/EC2 container/service log delivery
#
# - AWS Systems Manager (SSM):
#     * ssm             — for Parameter Store access and SSM API calls
#     * ssmmessages     — for SSM Session Manager and ExecuteCommand
#     * ec2messages     — for agent communication with SSM backend
#
# These endpoints are created as Interface Endpoints using AWS PrivateLink,
# with private DNS enabled. They are deployed into the same private subnets
# used by ECS tasks, and attached to a shared security group controlled outside
# of this module.
#
# Required Module:
# https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/modules/vpc-endpoints
# ------------------------------------------------------------------------------

module "endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc_id
  security_group_ids = [data.terraform_remote_state.sg.outputs.endpoints_sg_id]

  endpoints = {
    ecr_dkr = {
      service             = "ecr.dkr"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "ecr-dkr-gogs-vpc-endpoint"
      }
    }

    ecr_api = {
      service             = "ecr.api"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "ecr-api-gogs-vpc-endpoint"
      }
    }

    logs = {
      service             = "logs"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "logs-gogs-vpc-endpoint"
      }
    }

    ssm = {
      service             = "ssm"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "ssm-gogs-vpc-endpoint"
      }
    }

    ssmmessages = {
      service             = "ssmmessages"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "ssmmessages-gogs-vpc-endpoint"
      }
    }

    ec2messages = {
      service             = "ec2messages"
      service_type        = "Interface"
      private_dns_enabled = true
      subnet_ids          = data.terraform_remote_state.vpc.outputs.private_subnet_ids
      tags = {
        Name = "ec2messages-gogs-vpc-endpoint"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

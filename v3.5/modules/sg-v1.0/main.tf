module "endpoints_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-endpoints-sg"
  vpc_id = var.vpc_id

  ingress_cidr_blocks = [var.vpc_cidr]
  ingress_rules       = ["https-443-tcp"]
  egress_rules        = ["all-all"]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-endpoints-sg"
  }
}

module "alb_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-alb-sg"
  vpc_id = var.vpc_id

  # Allow HTTP/HTTPS from anywhere
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  # Specific egress to backend services only
  # egress_with_source_security_group_id = [
  #   {
  #     from_port                = 3000
  #     to_port                  = 3000
  #     protocol                 = "tcp"
  #     source_security_group_id = module.ecs_tasks_sg.security_group_id
  #   },
  #   {
  #     from_port                = 8080
  #     to_port                  = 8080
  #     protocol                 = "tcp"
  #     source_security_group_id = module.jenkins_sg.security_group_id
  #   }
  # ]

  egress_rules = ["all-all"]

  # Add HTTPS egress for health checks 
  #   egress_cidr_blocks = ["0.0.0.0/0"]
  #   egress_rules       = ["https-443-tcp"]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-alb-sg"
  }
}

module "ecs_tasks_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-ecs-tasks-sg"
  vpc_id = var.vpc_id

  # Allow traffic from ALB
  ingress_with_source_security_group_id = [
    {
      from_port                = 3000
      to_port                  = 3000
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
    }
  ]

  # Specific egress to rds and efs  services
  egress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.rds_sg.security_group_id
    },
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.efs_sg.security_group_id
    }
  ]

  # Allow HTTPS for external API calls, package downloads, etc.
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["https-443-tcp", "http-80-tcp"]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-ecs-tasks-sg"
  }
}

module "rds_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-rds-sg"
  vpc_id = var.vpc_id

  # Only allow database access from ECS tasks
  ingress_with_source_security_group_id = [
    {
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      source_security_group_id = module.ecs_tasks_sg.security_group_id
    }
  ]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-rds-sg"
  }
}

module "efs_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-efs-sg"
  vpc_id = var.vpc_id

  # Only allow NFS access from ECS tasks
  ingress_with_source_security_group_id = [
    {
      from_port                = 2049
      to_port                  = 2049
      protocol                 = "tcp"
      source_security_group_id = module.ecs_tasks_sg.security_group_id
    }
  ]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-efs-sg"
  }
}

###############
#   JENKINS   #
###############
module "jenkins_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name   = "${var.vpc_name}-jenkins-sg"
  vpc_id = var.vpc_id

  # SSH access from specific IP and Jenkins port from ALB
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "193.56.13.53/32"
      description = "SSH access from admin IP"
    }
  ]

  # Jenkins port access from ALB
  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.alb_sg.security_group_id
      description              = "Jenkins web interface from ALB"
    }
  ]

  # Jenkins needs internet access for plugins, Git repos, etc.
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["http-80-tcp", "https-443-tcp"]

  # SSH access for Git operations
  egress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "SSH for Git operations"
    }
  ]

  tags = {
    Environment = var.env
    Name        = "${var.vpc_name}-jenkins-sg"
  }
}

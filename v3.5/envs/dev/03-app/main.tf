########################

# ALB/ expensive ✅

# ECS/ expensive ✅

# ENDPOINTS/ very expensive ✅

##########################

module "endpoints" {
  source = "../../../modules/endpoints"
}

module "alb" {
  source = "../../../modules/alb"
}

module "ecs" {
  source = "../../../modules/ecs"
}


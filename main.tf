# =============================================================================
# Local Values
# =============================================================================
locals {
  cluster_name = var.cluster_name
  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# =============================================================================
# S3 Bucket for Metrics/Logs Storage
# =============================================================================
module "s3" {
  source = "./modules/s3"

  bucket_name                = "${local.cluster_name}-metrics-storage"
  transition_to_ia_days      = var.s3_retention_days
  transition_to_glacier_days = 90
  expiration_days            = 365
  create_waf_logs_bucket     = true
}

# =============================================================================
# VPC Module
# =============================================================================
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  cluster_name       = local.cluster_name
  flow_log_role_arn  = module.iam.flow_logs_role_arn
  flow_log_group_arn = module.iam.flow_logs_log_group_arn

  depends_on = [module.iam]
}

# =============================================================================
# IAM Module (Initial - without OIDC)
# =============================================================================
module "iam" {
  source = "./modules/iam"

  cluster_name       = local.cluster_name
  oidc_provider      = ""
  oidc_provider_arn  = ""
  metrics_bucket_arn = module.s3.bucket_arn
}

# =============================================================================
# Bastion Host
# =============================================================================
module "bastion" {
  source = "./modules/bastion"

  cluster_name          = local.cluster_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_id      = module.vpc.public_subnet_ids[0]
  allowed_cidr_blocks   = var.bastion_allowed_cidr
  instance_type         = "t3.micro"
  instance_profile_name = module.iam.bastion_instance_profile_name
  aws_region            = var.aws_region

  depends_on = [module.vpc, module.iam]
}

# =============================================================================
# EKS Cluster
# =============================================================================
module "eks" {
  source = "./modules/eks"

  cluster_name       = local.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  cluster_role_arn   = module.iam.eks_cluster_role_arn
  ebs_csi_role_arn   = module.iam.ebs_csi_driver_role_arn

  depends_on = [module.vpc, module.iam]
}

# =============================================================================
# Update IAM with OIDC Provider
# =============================================================================
module "iam_irsa" {
  source = "./modules/iam"

  cluster_name       = local.cluster_name
  oidc_provider      = module.eks.oidc_provider
  oidc_provider_arn  = module.eks.oidc_provider_arn
  metrics_bucket_arn = module.s3.bucket_arn

  depends_on = [module.eks]
}

# =============================================================================
# Spot Node Groups
# =============================================================================
module "node_groups" {
  source = "./modules/node-groups"

  cluster_name       = local.cluster_name
  node_role_arn      = module.iam.eks_node_group_role_arn
  private_subnet_ids = module.vpc.private_subnet_ids
  instance_types     = var.node_instance_types
  desired_size       = var.node_group_desired_size
  min_size           = var.node_group_min_size
  max_size           = var.node_group_max_size
  disk_size          = var.ebs_volume_size

  depends_on = [module.eks]
}

# =============================================================================
# ECR Repository
# =============================================================================
module "ecr" {
  source = "./modules/ecr"

  repository_name    = "${local.cluster_name}-apps"
  allowed_principals = ["*"]
}

# =============================================================================
# Secrets Manager
# =============================================================================
module "secrets" {
  source = "./modules/secrets-manager"

  cluster_name           = local.cluster_name
  grafana_admin_password = var.grafana_admin_password
}

# =============================================================================
# WAF
# =============================================================================
module "waf" {
  source = "./modules/waf"

  cluster_name         = local.cluster_name
  rate_limit           = 2000
  blocked_ip_addresses = []
  allowed_ip_addresses = []
}

# =============================================================================
# Kubernetes Resources (Monitoring Stack)
# =============================================================================
module "kubernetes" {
  source = "./kubernetes"

  cluster_name            = local.cluster_name
  aws_region              = var.aws_region
  vpc_id                  = module.vpc.vpc_id
  alb_controller_role_arn = module.iam_irsa.alb_controller_role_arn
  prometheus_role_arn     = module.iam_irsa.prometheus_role_arn
  grafana_role_arn        = module.iam_irsa.grafana_role_arn
  waf_acl_arn             = module.waf.web_acl_arn
  grafana_admin_password  = module.secrets.grafana_admin_password
  prometheus_storage_size = 500
  grafana_storage_size    = 50

  depends_on = [
    module.eks,
    module.node_groups,
    module.iam_irsa,
    module.waf
  ]
}

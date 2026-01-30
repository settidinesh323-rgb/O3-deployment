# =============================================================================
# VPC Outputs
# =============================================================================
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ip" {
  description = "NAT Gateway public IP"
  value       = module.vpc.nat_gateway_ip
}

# =============================================================================
# Bastion Outputs
# =============================================================================
output "bastion_public_ip" {
  description = "Bastion host public IP"
  value       = module.bastion.public_ip
}

output "bastion_ssh_key_secret_arn" {
  description = "ARN of secret containing bastion SSH key"
  value       = module.bastion.ssh_key_secret_arn
}

output "bastion_connection_command" {
  description = "Command to connect to bastion"
  value       = module.bastion.ssh_connection_command
}

# =============================================================================
# EKS Outputs
# =============================================================================
output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS cluster version"
  value       = module.eks.cluster_version
}

output "eks_oidc_provider_arn" {
  description = "EKS OIDC provider ARN"
  value       = module.eks.oidc_provider_arn
}

output "eks_update_kubeconfig_command" {
  description = "Command to update kubeconfig"
  value       = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}

# =============================================================================
# Node Group Outputs
# =============================================================================
output "node_group_names" {
  description = "EKS node group names"
  value       = module.node_groups.node_group_names
}

# =============================================================================
# ECR Outputs
# =============================================================================
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

# =============================================================================
# S3 Outputs
# =============================================================================
output "metrics_bucket_arn" {
  description = "S3 metrics bucket ARN"
  value       = module.s3.bucket_arn
}

output "metrics_bucket_name" {
  description = "S3 metrics bucket name"
  value       = module.s3.bucket_id
}

# =============================================================================
# Monitoring Outputs
# =============================================================================
output "grafana_url" {
  description = "Grafana public URL (ALB)"
  value       = module.kubernetes.grafana_url
}

output "grafana_admin_password_secret_arn" {
  description = "ARN of secret containing Grafana admin password"
  value       = module.secrets.grafana_admin_secret_arn
}

output "prometheus_endpoint" {
  description = "Prometheus internal endpoint"
  value       = module.kubernetes.prometheus_service
}

# =============================================================================
# WAF Outputs
# =============================================================================
output "waf_web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = module.waf.web_acl_arn
}

# =============================================================================
# IAM Role ARNs
# =============================================================================
output "iam_roles" {
  description = "IAM role ARNs"
  value = {
    eks_cluster         = module.iam.eks_cluster_role_arn
    eks_node_group      = module.iam.eks_node_group_role_arn
    alb_controller      = module.iam_irsa.alb_controller_role_arn
    ebs_csi_driver      = module.iam.ebs_csi_driver_role_arn
    prometheus          = module.iam_irsa.prometheus_role_arn
    grafana             = module.iam_irsa.grafana_role_arn
    cluster_autoscaler  = module.iam_irsa.cluster_autoscaler_role_arn
    external_dns        = module.iam_irsa.external_dns_role_arn
    secrets_manager     = module.iam_irsa.secrets_manager_role_arn
    cloudwatch_logs     = module.iam_irsa.cloudwatch_logs_role_arn
    ecr_access          = module.iam_irsa.ecr_access_role_arn
    s3_access           = module.iam_irsa.s3_access_role_arn
    bastion             = module.iam.bastion_role_arn
    flow_logs           = module.iam.flow_logs_role_arn
    waf_logging         = module.iam.waf_logging_role_arn
  }
}

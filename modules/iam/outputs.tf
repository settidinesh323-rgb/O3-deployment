# Cluster Roles
output "eks_cluster_role_arn" {
  description = "EKS cluster role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_node_group_role_arn" {
  description = "EKS node group role ARN"
  value       = aws_iam_role.eks_node_group.arn
}

# Bastion
output "bastion_instance_profile_name" {
  description = "Bastion instance profile name"
  value       = aws_iam_instance_profile.bastion.name
}

output "bastion_role_arn" {
  description = "Bastion role ARN"
  value       = aws_iam_role.bastion.arn
}

# IRSA Roles
output "alb_controller_role_arn" {
  description = "ALB controller role ARN"
  value       = aws_iam_role.alb_controller.arn
}

output "ebs_csi_driver_role_arn" {
  description = "EBS CSI driver role ARN"
  value       = aws_iam_role.ebs_csi_driver.arn
}

output "prometheus_role_arn" {
  description = "Prometheus role ARN"
  value       = aws_iam_role.prometheus.arn
}

output "grafana_role_arn" {
  description = "Grafana role ARN"
  value       = aws_iam_role.grafana.arn
}

output "cluster_autoscaler_role_arn" {
  description = "Cluster autoscaler role ARN"
  value       = aws_iam_role.cluster_autoscaler.arn
}

output "external_dns_role_arn" {
  description = "External DNS role ARN"
  value       = aws_iam_role.external_dns.arn
}

output "secrets_manager_role_arn" {
  description = "Secrets Manager access role ARN"
  value       = aws_iam_role.secrets_manager.arn
}

output "s3_access_role_arn" {
  description = "S3 access role ARN"
  value       = aws_iam_role.s3_access.arn
}

output "cloudwatch_logs_role_arn" {
  description = "CloudWatch logs role ARN"
  value       = aws_iam_role.cloudwatch_logs.arn
}

output "ecr_access_role_arn" {
  description = "ECR access role ARN"
  value       = aws_iam_role.ecr_access.arn
}

# VPC Flow Logs
output "flow_logs_role_arn" {
  description = "VPC flow logs role ARN"
  value       = aws_iam_role.flow_logs.arn
}

output "flow_logs_log_group_arn" {
  description = "VPC flow logs CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.flow_logs.arn
}

# WAF
output "waf_logging_role_arn" {
  description = "WAF logging role ARN"
  value       = aws_iam_role.waf_logging.arn
}

# CloudWatch
output "eks_log_group_arn" {
  description = "EKS CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.eks.arn
}

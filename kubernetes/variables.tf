variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_controller_role_arn" {
  description = "IAM role ARN for ALB controller"
  type        = string
}

variable "prometheus_role_arn" {
  description = "IAM role ARN for Prometheus"
  type        = string
}

variable "grafana_role_arn" {
  description = "IAM role ARN for Grafana"
  type        = string
}

variable "waf_acl_arn" {
  description = "WAF ACL ARN"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

variable "grafana_host" {
  description = "Grafana hostname for ingress"
  type        = string
  default     = ""
}

variable "alb_controller_version" {
  description = "AWS Load Balancer Controller Helm chart version"
  type        = string
  default     = "1.7.1"
}

variable "prometheus_stack_version" {
  description = "kube-prometheus-stack Helm chart version"
  type        = string
  default     = "56.6.2"
}

variable "grafana_version" {
  description = "Grafana Helm chart version"
  type        = string
  default     = "7.3.0"
}

variable "prometheus_storage_size" {
  description = "Prometheus storage size in GB"
  type        = number
  default     = 100
}

variable "grafana_storage_size" {
  description = "Grafana storage size in GB"
  type        = number
  default     = 10
}

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "eks-monitoring"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-monitoring-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.29"
}

variable "bastion_allowed_cidr" {
  description = "CIDR blocks allowed to SSH to bastion"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "node_instance_types" {
  description = "Instance types for spot node groups"
  type        = list(string)
  default     = ["t3.medium", "t3.large", "m5.large"]
}

variable "node_group_desired_size" {
  description = "Desired number of nodes per node group"
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  description = "Minimum number of nodes per node group"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of nodes per node group"
  type        = number
  default     = 5
}

variable "ebs_volume_size" {
  description = "EBS volume size in GB for nodes"
  type        = number
  default     = 100
}

variable "s3_retention_days" {
  description = "Days to retain objects in S3 before transitioning to IA"
  type        = number
  default     = 30
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
  default     = ""
}

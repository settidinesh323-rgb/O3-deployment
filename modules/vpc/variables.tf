variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "flow_log_role_arn" {
  description = "IAM role ARN for VPC flow logs"
  type        = string
  default     = ""
}

variable "flow_log_group_arn" {
  description = "CloudWatch log group ARN for VPC flow logs"
  type        = string
  default     = ""
}

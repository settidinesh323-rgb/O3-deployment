variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_provider" {
  description = "OIDC provider URL (without https://)"
  type        = string
  default     = ""
}

variable "oidc_provider_arn" {
  description = "OIDC provider ARN"
  type        = string
  default     = ""
}

variable "metrics_bucket_arn" {
  description = "S3 bucket ARN for metrics storage"
  type        = string
  default     = ""
}

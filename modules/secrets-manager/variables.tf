variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "grafana_admin_password" {
  description = "Grafana admin password (optional, will be auto-generated if not provided)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "create_prometheus_secret" {
  description = "Create Prometheus remote write secret"
  type        = bool
  default     = false
}

variable "create_database_secret" {
  description = "Create database credentials secret"
  type        = bool
  default     = false
}

variable "application_secrets" {
  description = "List of application secret names to create"
  type        = list(string)
  default     = []
}

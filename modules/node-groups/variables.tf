variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_role_arn" {
  description = "IAM role ARN for node group"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "instance_types" {
  description = "Instance types for spot nodes"
  type        = list(string)
  default     = ["t3.medium", "t3.large", "m5.large"]
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 5
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

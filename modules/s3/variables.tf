variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "transition_to_ia_days" {
  description = "Days before transitioning to IA"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Days before transitioning to Glacier"
  type        = number
  default     = 90
}

variable "expiration_days" {
  description = "Days before object expiration"
  type        = number
  default     = 365
}

variable "create_waf_logs_bucket" {
  description = "Create separate bucket for WAF logs"
  type        = bool
  default     = true
}

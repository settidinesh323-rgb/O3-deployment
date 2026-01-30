variable "repository_name" {
  description = "ECR repository name"
  type        = string
}

variable "allowed_principals" {
  description = "AWS principals allowed to pull images"
  type        = list(string)
  default     = ["*"]
}

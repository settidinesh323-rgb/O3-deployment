output "grafana_admin_secret_arn" {
  description = "Grafana admin secret ARN"
  value       = aws_secretsmanager_secret.grafana_admin.arn
}

output "grafana_admin_secret_name" {
  description = "Grafana admin secret name"
  value       = aws_secretsmanager_secret.grafana_admin.name
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = var.grafana_admin_password != "" ? var.grafana_admin_password : random_password.grafana_admin.result
  sensitive   = true
}

output "prometheus_secret_arn" {
  description = "Prometheus remote write secret ARN"
  value       = var.create_prometheus_secret ? aws_secretsmanager_secret.prometheus_remote_write[0].arn : ""
}

output "database_secret_arn" {
  description = "Database credentials secret ARN"
  value       = var.create_database_secret ? aws_secretsmanager_secret.database[0].arn : ""
}

output "application_secret_arns" {
  description = "Application secret ARNs"
  value       = { for k, v in aws_secretsmanager_secret.application : k => v.arn }
}

# Random password for Grafana admin
resource "random_password" "grafana_admin" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Grafana Admin Password Secret
resource "aws_secretsmanager_secret" "grafana_admin" {
  name                    = "${var.cluster_name}/grafana-admin-password"
  description             = "Grafana admin password"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.cluster_name}-grafana-admin"
  }
}

resource "aws_secretsmanager_secret_version" "grafana_admin" {
  secret_id = aws_secretsmanager_secret.grafana_admin.id
  secret_string = jsonencode({
    username = "admin"
    password = var.grafana_admin_password != "" ? var.grafana_admin_password : random_password.grafana_admin.result
  })
}

# Prometheus Remote Write Credentials (if needed)
resource "aws_secretsmanager_secret" "prometheus_remote_write" {
  count                   = var.create_prometheus_secret ? 1 : 0
  name                    = "${var.cluster_name}/prometheus-remote-write"
  description             = "Prometheus remote write credentials"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.cluster_name}-prometheus-remote-write"
  }
}

# Database Credentials (for future use)
resource "aws_secretsmanager_secret" "database" {
  count                   = var.create_database_secret ? 1 : 0
  name                    = "${var.cluster_name}/database-credentials"
  description             = "Database credentials"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.cluster_name}-database"
  }
}

# Generic Application Secrets
resource "aws_secretsmanager_secret" "application" {
  for_each                = toset(var.application_secrets)
  name                    = "${var.cluster_name}/${each.value}"
  description             = "Application secret: ${each.value}"
  recovery_window_in_days = 7

  tags = {
    Name = "${var.cluster_name}-${each.value}"
  }
}

# Prometheus Stack using kube-prometheus-stack Helm chart
resource "helm_release" "prometheus_stack" {
  name       = "prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.prometheus_stack_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Prometheus configuration
  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "30d"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.storageClassName"
    value = "gp3-prometheus"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "${var.prometheus_storage_size}Gi"
  }

  # Service account for Prometheus
  set {
    name  = "prometheus.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "prometheus.serviceAccount.name"
    value = "prometheus"
  }

  set {
    name  = "prometheus.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.prometheus_role_arn
  }

  # Alertmanager configuration
  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.storageClassName"
    value = "gp3"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.storage.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  # Disable default Grafana (we'll deploy separately with ALB)
  set {
    name  = "grafana.enabled"
    value = "false"
  }

  # Node exporter
  set {
    name  = "nodeExporter.enabled"
    value = "true"
  }

  # Tolerate spot instances
  set {
    name  = "prometheus.prometheusSpec.tolerations[0].key"
    value = "spotInstance"
  }

  set {
    name  = "prometheus.prometheusSpec.tolerations[0].operator"
    value = "Equal"
  }

  set {
    name  = "prometheus.prometheusSpec.tolerations[0].value"
    value = "true"
  }

  set {
    name  = "prometheus.prometheusSpec.tolerations[0].effect"
    value = "PreferNoSchedule"
  }

  # Node selector for monitoring nodes
  set {
    name  = "prometheus.prometheusSpec.nodeSelector.role"
    value = "monitoring"
  }

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_storage_class.gp3_prometheus,
    helm_release.aws_load_balancer_controller
  ]
}

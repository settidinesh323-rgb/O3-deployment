# Grafana Helm Release with ALB Ingress
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = var.grafana_version
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Admin credentials
  set {
    name  = "adminUser"
    value = "admin"
  }

  set_sensitive {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  # Service account for IRSA
  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "grafana"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.grafana_role_arn
  }

  # Persistence
  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.storageClassName"
    value = "gp3-grafana"
  }

  set {
    name  = "persistence.size"
    value = "${var.grafana_storage_size}Gi"
  }

  # Ingress with ALB
  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.ingressClassName"
    value = "alb"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internet-facing"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/listen-ports"
    value = "[{\"HTTP\": 80}]"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/healthcheck-path"
    value = "/api/health"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/success-codes"
    value = "200"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/wafv2-acl-arn"
    value = var.waf_acl_arn
  }

  set {
    name  = "ingress.hosts[0]"
    value = var.grafana_host != "" ? var.grafana_host : "grafana.local"
  }

  set {
    name  = "ingress.path"
    value = "/*"
  }

  set {
    name  = "ingress.pathType"
    value = "ImplementationSpecific"
  }

  # Datasources - Prometheus
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-stack-kube-prom-prometheus:9090"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].access"
    value = "proxy"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
    value = "true"
  }

  # CloudWatch datasource
  set {
    name  = "datasources.datasources\\.yaml.datasources[1].name"
    value = "CloudWatch"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[1].type"
    value = "cloudwatch"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[1].jsonData.authType"
    value = "default"
  }

  set {
    name  = "datasources.datasources\\.yaml.datasources[1].jsonData.defaultRegion"
    value = var.aws_region
  }

  # Tolerate spot instances
  set {
    name  = "tolerations[0].key"
    value = "spotInstance"
  }

  set {
    name  = "tolerations[0].operator"
    value = "Equal"
  }

  set {
    name  = "tolerations[0].value"
    value = "true"
  }

  set {
    name  = "tolerations[0].effect"
    value = "PreferNoSchedule"
  }

  # Node selector for monitoring nodes
  set {
    name  = "nodeSelector.role"
    value = "monitoring"
  }

  # Dashboard providers
  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.apiVersion"
    value = "1"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].name"
    value = "default"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].orgId"
    value = "1"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].folder"
    value = ""
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].type"
    value = "file"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].disableDeletion"
    value = "false"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].editable"
    value = "true"
  }

  set {
    name  = "dashboardProviders.dashboardproviders\\.yaml.providers[0].options.path"
    value = "/var/lib/grafana/dashboards/default"
  }

  # Default dashboards from Grafana.com
  set {
    name  = "dashboards.default.kubernetes-cluster.gnetId"
    value = "7249"
  }

  set {
    name  = "dashboards.default.kubernetes-cluster.revision"
    value = "1"
  }

  set {
    name  = "dashboards.default.kubernetes-cluster.datasource"
    value = "Prometheus"
  }

  set {
    name  = "dashboards.default.node-exporter.gnetId"
    value = "1860"
  }

  set {
    name  = "dashboards.default.node-exporter.revision"
    value = "31"
  }

  set {
    name  = "dashboards.default.node-exporter.datasource"
    value = "Prometheus"
  }

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_storage_class.gp3_grafana,
    helm_release.prometheus_stack,
    helm_release.aws_load_balancer_controller
  ]
}

# Output the Grafana ALB URL
data "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  depends_on = [helm_release.grafana]
}

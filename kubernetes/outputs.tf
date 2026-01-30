output "grafana_url" {
  description = "Grafana ALB URL"
  value       = try("http://${data.kubernetes_ingress_v1.grafana.status[0].load_balancer[0].ingress[0].hostname}", "Pending - ALB being created")
}

output "prometheus_service" {
  description = "Prometheus service endpoint"
  value       = "prometheus-stack-kube-prom-prometheus.monitoring.svc.cluster.local:9090"
}

output "alertmanager_service" {
  description = "Alertmanager service endpoint"
  value       = "prometheus-stack-kube-prom-alertmanager.monitoring.svc.cluster.local:9093"
}

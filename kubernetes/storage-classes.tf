# GP3 Storage Class (default)
resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp3"
    encrypted = "true"
    fsType    = "ext4"
  }

  allow_volume_expansion = true
}

# GP3 Storage Class for Prometheus
resource "kubernetes_storage_class" "gp3_prometheus" {
  metadata {
    name = "gp3-prometheus"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp3"
    encrypted = "true"
    fsType    = "ext4"
    iops      = "3000"
    throughput = "125"
  }

  allow_volume_expansion = true
}

# GP3 Storage Class for Grafana
resource "kubernetes_storage_class" "gp3_grafana" {
  metadata {
    name = "gp3-grafana"
  }

  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    type      = "gp3"
    encrypted = "true"
    fsType    = "ext4"
  }

  allow_volume_expansion = true
}

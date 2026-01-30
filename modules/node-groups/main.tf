# Launch Template for Spot Node Groups
resource "aws_launch_template" "spot_nodes" {
  name = "${var.cluster_name}-spot-nodes-lt"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.disk_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name                                        = "${var.cluster_name}-spot-node"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      "k8s.io/cluster-autoscaler/enabled"         = "true"
      "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    }
  }

  tags = {
    Name = "${var.cluster_name}-spot-nodes-lt"
  }
}

# Spot Node Group 1 - General workloads
resource "aws_eks_node_group" "spot_general" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-spot-general"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  capacity_type = "SPOT"

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.spot_nodes.id
    version = aws_launch_template.spot_nodes.latest_version
  }

  instance_types = var.instance_types

  labels = {
    role     = "general"
    capacity = "spot"
  }

  taint {
    key    = "spotInstance"
    value  = "true"
    effect = "PREFER_NO_SCHEDULE"
  }

  tags = {
    Name                                              = "${var.cluster_name}-spot-general"
    "k8s.io/cluster-autoscaler/enabled"               = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}"   = "owned"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [aws_launch_template.spot_nodes]
}

# Spot Node Group 2 - Application workloads
resource "aws_eks_node_group" "spot_application" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-spot-application"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  capacity_type = "SPOT"

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.spot_nodes.id
    version = aws_launch_template.spot_nodes.latest_version
  }

  instance_types = var.instance_types

  labels = {
    role     = "application"
    capacity = "spot"
  }

  taint {
    key    = "spotInstance"
    value  = "true"
    effect = "PREFER_NO_SCHEDULE"
  }

  tags = {
    Name                                              = "${var.cluster_name}-spot-application"
    "k8s.io/cluster-autoscaler/enabled"               = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}"   = "owned"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [aws_launch_template.spot_nodes]
}

# Spot Node Group 3 - Monitoring workloads
resource "aws_eks_node_group" "spot_monitoring" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-spot-monitoring"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  capacity_type = "SPOT"

  scaling_config {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 1
  }

  launch_template {
    id      = aws_launch_template.spot_nodes.id
    version = aws_launch_template.spot_nodes.latest_version
  }

  instance_types = var.instance_types

  labels = {
    role     = "monitoring"
    capacity = "spot"
  }

  taint {
    key    = "spotInstance"
    value  = "true"
    effect = "PREFER_NO_SCHEDULE"
  }

  tags = {
    Name                                              = "${var.cluster_name}-spot-monitoring"
    "k8s.io/cluster-autoscaler/enabled"               = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}"   = "owned"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  depends_on = [aws_launch_template.spot_nodes]
}

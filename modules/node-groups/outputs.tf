output "node_group_arns" {
  description = "ARNs of all node groups"
  value = [
    aws_eks_node_group.spot_general.arn,
    aws_eks_node_group.spot_application.arn,
    aws_eks_node_group.spot_monitoring.arn
  ]
}

output "node_group_names" {
  description = "Names of all node groups"
  value = [
    aws_eks_node_group.spot_general.node_group_name,
    aws_eks_node_group.spot_application.node_group_name,
    aws_eks_node_group.spot_monitoring.node_group_name
  ]
}

output "node_group_statuses" {
  description = "Statuses of all node groups"
  value = {
    general     = aws_eks_node_group.spot_general.status
    application = aws_eks_node_group.spot_application.status
    monitoring  = aws_eks_node_group.spot_monitoring.status
  }
}

output "launch_template_id" {
  description = "Launch template ID"
  value       = aws_launch_template.spot_nodes.id
}

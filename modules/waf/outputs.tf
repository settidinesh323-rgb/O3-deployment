output "web_acl_arn" {
  description = "WAF Web ACL ARN"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_id" {
  description = "WAF Web ACL ID"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_capacity" {
  description = "WAF Web ACL capacity"
  value       = aws_wafv2_web_acl.main.capacity
}

output "blocked_ip_set_arn" {
  description = "Blocked IP set ARN"
  value       = aws_wafv2_ip_set.blocked.arn
}

output "allowed_ip_set_arn" {
  description = "Allowed IP set ARN"
  value       = aws_wafv2_ip_set.allowed.arn
}

output "log_group_arn" {
  description = "WAF CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.waf.arn
}

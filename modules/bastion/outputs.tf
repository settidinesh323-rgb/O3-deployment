output "public_ip" {
  description = "Bastion public IP address"
  value       = aws_instance.bastion.public_ip
}

output "instance_id" {
  description = "Bastion instance ID"
  value       = aws_instance.bastion.id
}

output "security_group_id" {
  description = "Bastion security group ID"
  value       = aws_security_group.bastion.id
}

output "ssh_key_secret_arn" {
  description = "ARN of the secret containing SSH private key"
  value       = aws_secretsmanager_secret.bastion_key.arn
}

output "ssh_connection_command" {
  description = "SSH connection command"
  value       = "ssh -i bastion-key.pem ec2-user@${aws_instance.bastion.public_ip}"
}

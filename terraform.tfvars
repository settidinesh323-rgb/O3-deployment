# AWS Configuration
aws_region  = "us-east-1"
environment = "production"
project_name = "eks-monitoring"

# VPC Configuration
vpc_cidr = "10.0.0.0/16"

# EKS Configuration
cluster_name    = "eks-monitoring-cluster"
cluster_version = "1.29"

# Bastion Configuration
bastion_allowed_cidr = ["0.0.0.0/0"]  # Restrict to your IP in production

# Node Group Configuration
node_instance_types     = ["t3.medium", "t3.large", "m5.large"]
node_group_desired_size = 3
node_group_min_size     = 1
node_group_max_size     = 5
ebs_volume_size         = 100

# S3 Configuration
s3_retention_days = 30

# Grafana Configuration (optional - auto-generated if not provided)
# grafana_admin_password = "your-secure-password"

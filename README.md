# O3-deployment
# EKS Monitoring Infrastructure

Complete Terraform infrastructure for AWS EKS with Prometheus and Grafana monitoring stack.

## Architecture

- **VPC**: 6 subnets (3 public, 3 private) across 3 AZs
- **EKS**: Kubernetes 1.29 with OIDC for IRSA
- **Node Groups**: 3 spot node groups (9 total instances)
- **Monitoring**: Prometheus + Grafana with public ALB access
- **Security**: WAF, 15 IAM roles, Secrets Manager
- **Storage**: EBS CSI driver + S3 for long-term storage

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.5.0
- kubectl
- helm

## Quick Start

1. **Clone and configure**:
   ```bash
   cd terraform-eks-infra
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your values
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Review the plan**:
   ```bash
   terraform plan
   ```

4. **Apply the infrastructure**:
   ```bash
   terraform apply
   ```

5. **Configure kubectl**:
   ```bash
   aws eks update-kubeconfig --name eks-monitoring-cluster --region us-east-1
   ```

6. **Verify deployment**:
   ```bash
   kubectl get nodes
   kubectl get pods -n monitoring
   ```

## Accessing Grafana

After deployment, get the Grafana URL:
```bash
terraform output grafana_url
```

Get the admin password:
```bash
aws secretsmanager get-secret-value \
  --secret-id eks-monitoring-cluster/grafana-admin-password \
  --query SecretString --output text | jq -r .password
```

## Accessing Bastion

Get SSH key and connect:
```bash
aws secretsmanager get-secret-value \
  --secret-id eks-monitoring-cluster/bastion-ssh-key \
  --query SecretString --output text > bastion-key.pem
chmod 400 bastion-key.pem
ssh -i bastion-key.pem ec2-user@$(terraform output -raw bastion_public_ip)
```

## Module Structure

```
terraform-eks-infra/
├── main.tf                 # Root module
├── variables.tf            # Input variables
├── outputs.tf              # Output values
├── providers.tf            # Provider configuration
├── modules/
│   ├── vpc/                # VPC, subnets, NAT, IGW
│   ├── iam/                # 15 IAM roles
│   ├── bastion/            # Bastion EC2
│   ├── eks/                # EKS cluster
│   ├── node-groups/        # Spot node groups
│   ├── ecr/                # Container registry
│   ├── s3/                 # Storage buckets
│   ├── secrets-manager/    # Secrets
│   └── waf/                # WAF rules
└── kubernetes/             # Helm releases
    ├── alb-controller.tf
    ├── prometheus.tf
    ├── grafana.tf
    └── storage-classes.tf
```

## IAM Roles Created (15 total)

1. EKS Cluster Role
2. EKS Node Group Role
3. Bastion Role
4. ALB Controller Role (IRSA)
5. EBS CSI Driver Role (IRSA)
6. Prometheus Role (IRSA)
7. Grafana Role (IRSA)
8. VPC Flow Logs Role
9. Cluster Autoscaler Role (IRSA)
10. External DNS Role (IRSA)
11. Secrets Manager Access Role (IRSA)
12. S3 Access Role (IRSA)
13. CloudWatch Logs Role (IRSA)
14. ECR Access Role (IRSA)
15. WAF Logging Role

## Cleanup

```bash
terraform destroy
```

## Security Notes

- Bastion SSH access is restricted by `bastion_allowed_cidr`
- All EBS volumes are encrypted
- S3 buckets enforce HTTPS
- WAF protects the Grafana ALB
- Secrets are stored in AWS Secrets Manager

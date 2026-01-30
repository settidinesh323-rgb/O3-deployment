# Uncomment and configure for remote state
# terraform {
#   backend "s3" {
#     bucket         = "your-terraform-state-bucket"
#     key            = "eks-monitoring/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-state-lock"
#   }
# }

# For initial setup, use local backend
# After creating the S3 bucket and DynamoDB table, migrate to remote state

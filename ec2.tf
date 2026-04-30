# EC2 instance is referenced via data source (managed manually for now)
# Use this locals block to generate the startup script for reference
locals {
  ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}"
}

# Output the startup script so you can run it manually on EC2
# Future: manage EC2 fully with Terraform by replacing data source with resource

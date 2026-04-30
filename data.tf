data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_caller_identity" "current" {}

# Reference existing resources created manually (not managed by Terraform)
data "aws_security_group" "ec2" {
  name = "predicta-ec2-sg"
}

data "aws_security_group" "rds" {
  name = "predicta-rds-sg"
}

data "aws_instance" "app" {
  filter {
    name   = "tag:Name"
    values = ["predicta-app"]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

data "aws_db_instance" "main" {
  db_instance_identifier = "predicta-db"
}

data "aws_iam_instance_profile" "ec2" {
  name = "predicta-ec2-profile"
}

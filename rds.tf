# RDS instance referenced via data source (managed manually for now)
# DB subnet group is managed by Terraform
resource "aws_db_subnet_group" "main" {
  name       = "${var.app_name}-subnet-group"
  subnet_ids = data.aws_subnets.default.ids
}

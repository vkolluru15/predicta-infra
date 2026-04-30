# Store all app secrets in SSM Parameter Store (free for standard parameters)
# EC2 reads these at startup via user data script

locals {
  ssm_prefix = "/${var.app_name}"
  db_url     = "mysql://admin:${var.db_password}@${data.aws_db_instance.main.address}:3306/${var.app_name}"
  oauth_redirect = var.domain_name != "" ? "https://${var.domain_name}/auth/callback" : "http://${aws_lb.main.dns_name}/auth/callback"
}

resource "aws_ssm_parameter" "database_url" {
  name  = "${local.ssm_prefix}/DATABASE_URL"
  type  = "SecureString"
  value = local.db_url
}

resource "aws_ssm_parameter" "google_client_id" {
  name  = "${local.ssm_prefix}/GOOGLE_CLIENT_ID"
  type  = "SecureString"
  value = var.google_client_id
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "${local.ssm_prefix}/GOOGLE_CLIENT_SECRET"
  type  = "SecureString"
  value = var.google_client_secret
}

resource "aws_ssm_parameter" "oauth_redirect_uri" {
  name  = "${local.ssm_prefix}/OAUTH_REDIRECT_URI"
  type  = "String"
  value = local.oauth_redirect
}

resource "aws_ssm_parameter" "cricapi_key" {
  name  = "${local.ssm_prefix}/CRICAPI_KEY"
  type  = "SecureString"
  value = var.cricapi_key
}

resource "aws_ssm_parameter" "worker_trigger_key" {
  name  = "${local.ssm_prefix}/WORKER_TRIGGER_KEY"
  type  = "SecureString"
  value = var.worker_trigger_key
}

resource "aws_ssm_parameter" "vapid_public_key" {
  name  = "${local.ssm_prefix}/VAPID_PUBLIC_KEY"
  type  = "String"
  value = var.vapid_public_key
}

resource "aws_ssm_parameter" "vapid_private_key" {
  name  = "${local.ssm_prefix}/VAPID_PRIVATE_KEY"
  type  = "SecureString"
  value = var.vapid_private_key
}

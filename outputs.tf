output "alb_dns_name" {
  description = "ALB DNS name — use this as your app URL until domain is configured"
  value       = "http://${aws_lb.main.dns_name}"
}

output "app_url" {
  description = "App URL"
  value       = var.domain_name != "" ? "https://${var.domain_name}" : "http://${aws_lb.main.dns_name}"
}

output "ec2_public_ip" {
  description = "EC2 public IP for SSH"
  value       = data.aws_instance.app.public_ip
}

output "ec2_ssh_command" {
  description = "SSH command"
  value       = "ssh -i ~/predicta-key.pem ec2-user@${data.aws_instance.app.public_ip}"
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = data.aws_db_instance.main.address
}

output "ecr_repository_url" {
  description = "ECR URL for Docker pushes"
  value       = aws_ecr_repository.app.repository_url
}

output "oauth_redirect_uri" {
  description = "Add this to Google Cloud Console authorized redirect URIs"
  value       = var.domain_name != "" ? "https://${var.domain_name}/auth/callback" : "http://${aws_lb.main.dns_name}/auth/callback"
}

output "route53_nameservers" {
  description = "Update your domain registrar to use these nameservers"
  value       = var.domain_name != "" ? aws_route53_zone.main[0].name_servers : []
}

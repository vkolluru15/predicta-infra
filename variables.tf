variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name used for resource naming"
  type        = string
  default     = "predicta"
}

variable "domain_name" {
  description = "Primary domain (e.g. mypredicta.com). Leave empty to skip ACM + Route53."
  type        = string
  default     = ""
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Name of an existing EC2 key pair for SSH access"
  type        = string
  default     = "predicta-key"
}

# App environment variables stored as SSM parameters
variable "google_client_id" {
  description = "Google OAuth client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth client secret"
  type        = string
  sensitive   = true
}

variable "cricapi_key" {
  description = "CricAPI key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "worker_trigger_key" {
  description = "Internal worker trigger secret"
  type        = string
  sensitive   = true
}

variable "vapid_public_key" {
  description = "Web Push VAPID public key"
  type        = string
  default     = ""
}

variable "vapid_private_key" {
  description = "Web Push VAPID private key"
  type        = string
  sensitive   = true
  default     = ""
}

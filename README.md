# Predicta Infrastructure

Terraform code managing all AWS resources for the Predicta cricket app.

## Architecture

```
Internet
   │
   ▼
[ALB :80/:443]  ──── ACM cert (HTTPS, when domain set)
   │
   ▼
[EC2 t3.micro]  ──── Docker container (predicta:latest from ECR)
   │
   ▼
[RDS MySQL 8]   ──── db.t3.micro (free tier)
```

## Resources managed

| Resource | Description |
|----------|-------------|
| `aws_ecr_repository` | Docker image registry |
| `aws_db_instance` | MySQL 8 database (free tier) |
| `aws_instance` | EC2 app server (free tier) |
| `aws_lb` | Application Load Balancer (port 80/443) |
| `aws_acm_certificate` | SSL cert (when `domain_name` is set) |
| `aws_route53_zone` | DNS zone (when `domain_name` is set) |
| `aws_security_group` | ALB, EC2, RDS firewalls |
| `aws_iam_role` | EC2 role to pull from ECR + read SSM |
| `aws_ssm_parameter` | App secrets (DB password, Google OAuth, etc.) |

## Quick start

```bash
# 1. Copy and fill in values
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars — at minimum set db_password, google_client_id, google_client_secret

# 2. Init and apply
make init
make plan
make apply
```

## First-time setup (existing resources)

If you already created resources manually, import them first:
```bash
make import-existing
make plan   # should show minimal/no diff
```

## Without a domain (HTTP only)

Leave `domain_name = ""` in `terraform.tfvars`. The app will be available at:
```
http://<alb-dns-name>
```
Google OAuth won't work at HTTP non-localhost URLs — you need a domain + HTTPS.

## With a domain (full HTTPS setup)

1. Set `domain_name = "mypredicta.com"` in `terraform.tfvars`
2. Run `make apply`
3. Check `terraform output route53_nameservers`
4. Update your domain registrar's nameservers to the Route53 values
5. Wait ~5 min for DNS propagation, then ACM validates automatically
6. Check `terraform output oauth_redirect_uri` and add it to Google Cloud Console

## Deploying new code

```bash
make deploy   # builds Docker image, pushes to ECR, restarts EC2 container
```

## Environment variables

All secrets are stored in AWS SSM Parameter Store under `/predicta/*`.
The EC2 startup script fetches them automatically on boot.

To update a secret without re-applying Terraform:
```bash
aws ssm put-parameter --name "/predicta/CRICAPI_KEY" --value "new-key" --type SecureString --overwrite
ssh -i ~/predicta-key.pem ec2-user@<ec2-ip> "/home/ec2-user/start-app.sh"
```

## Running migrations

After provisioning, SSH into EC2 and run:
```bash
ssh -i ~/predicta-key.pem ec2-user@$(terraform output -raw ec2_public_ip)
# Install mysql client
sudo dnf install -y mariadb105
# Run migrations (copy SQL files from predicta repo first)
mysql -h <rds-endpoint> -u admin -p<password> predicta < all_migrations.sql
```

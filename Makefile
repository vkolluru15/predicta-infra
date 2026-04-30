TFVARS = terraform.tfvars

.PHONY: init plan apply destroy fmt validate import-existing

init:
	terraform init

fmt:
	terraform fmt -recursive

validate: fmt
	terraform validate

plan:
	terraform plan -var-file=$(TFVARS)

apply:
	terraform apply -var-file=$(TFVARS)

apply-auto:
	terraform apply -var-file=$(TFVARS) -auto-approve

destroy:
	terraform destroy -var-file=$(TFVARS)

# Import existing manually-created resources into Terraform state
import-existing:
	@echo "Importing existing resources..."
	terraform import -var-file=$(TFVARS) aws_ecr_repository.app predicta
	terraform import -var-file=$(TFVARS) aws_db_instance.main predicta-db
	terraform import -var-file=$(TFVARS) aws_instance.app i-0f01d202a515b8721
	terraform import -var-file=$(TFVARS) aws_security_group.ec2 sg-0bbfdd9e82b1580c9
	terraform import -var-file=$(TFVARS) aws_security_group.rds sg-095b3a8b6adb65c3f
	terraform import -var-file=$(TFVARS) aws_iam_role.ec2 predicta-ec2-role
	terraform import -var-file=$(TFVARS) aws_iam_instance_profile.ec2 predicta-ec2-profile
	@echo "Done. Run 'make plan' to see drift."

# Deploy new Docker image to EC2 without Terraform
deploy:
	@echo "Building and pushing new image..."
	aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $$(terraform output -raw ecr_repository_url | cut -d/ -f1)
	docker build --platform linux/amd64 -f ../predicta/Dockerfile.prod -t predicta:latest ../predicta
	docker tag predicta:latest $$(terraform output -raw ecr_repository_url):latest
	docker push $$(terraform output -raw ecr_repository_url):latest
	@echo "Restarting container on EC2..."
	ssh -i ~/predicta-key.pem ec2-user@$$(terraform output -raw ec2_public_ip) "/home/ec2-user/start-app.sh"

output:
	terraform output

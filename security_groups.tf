# ALB security group — new resource managed by Terraform
resource "aws_security_group" "alb" {
  name        = "${var.app_name}-alb-sg"
  description = "ALB: allow HTTP and HTTPS from internet"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.app_name}-alb-sg" }
}

# Allow ALB to reach EC2 on port 8787
resource "aws_security_group_rule" "ec2_from_alb" {
  type                     = "ingress"
  from_port                = 8787
  to_port                  = 8787
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id
  security_group_id        = data.aws_security_group.ec2.id
  description              = "Allow ALB to reach app"
}

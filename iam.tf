# IAM role and profile are referenced via data source
# Attach additional policies needed for SSM access
resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = "predicta-ec2-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_read" {
  role       = "predicta-ec2-role"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role       = "predicta-ec2-role"
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

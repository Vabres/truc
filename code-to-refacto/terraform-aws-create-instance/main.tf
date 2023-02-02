###############################################################################
# Instance
###############################################################################

#----------------------
# Creating the security group for the instance
#----------------------

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "main" {
  name        =var.instance_name
  description = "allow https traffic"

  ingress {
    description = "Allow public HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow public HTTP traffic for testing purposes"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["200.200.200.200/32"]
  }

  egress {
    description = "Allow any outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#----------------------
# Creating aws instance
#----------------------

resource "aws_instance" "main" {
  ami               = "ami-0ee415e1b8b71305f"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  security_groups   = [aws_security_group.main.name]

  root_block_device {
    encrypted = true # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enable-at-rest-encryption/
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enforce-http-token-imds/
  }

  tags = {
    Name =var.instance_name
  }
}

#----------------------
# Creating and attaching an encrypted ebs volume
#----------------------

resource "aws_kms_key" "main" {
  enable_key_rotation = true
}

resource "aws_ebs_volume" "main" {
  availability_zone = "eu-west-1a"
  size              = 1

  encrypted  = true
  kms_key_id = aws_kms_key.main.arn

  tags = {
    Name = "${var.instance_name}_data_volume"
  }
}

resource "aws_volume_attachment" "main" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.main.id
  instance_id = aws_instance.main.id
}

#----------------------
# Creating the instance role and policy
#----------------------

data "aws_iam_policy_document" "main" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${var.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "main" {
  name        = "${var.instance_name}_role"
  description = "IAM role for the ${var.instance_name}"

  assume_role_policy    = data.aws_iam_policy_document.main.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "main" {
  name = "${var.instance_name}_policy"
  role = aws_iam_role.main.id

  #tfsec:ignore:aws-iam-no-policy-wildcards
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

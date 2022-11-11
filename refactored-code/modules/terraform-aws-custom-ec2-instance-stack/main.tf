#----------------------
# Creating the security group for the instance_1
#----------------------

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "this" {
  name        = "instance_1"
  description = "allow https traffic"

  ingress {
    description = "Allow public HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_instance" "this" {
  ami               = "ami-5b673c34"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3"
  security_groups   = [aws_security_group.this.name]

  root_block_device {
    encrypted = true # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enable-at-rest-encryption/
  }

  metadata_options {
    http_tokens = "required" # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enforce-http-token-imds/
  }

  tags = {
    Name = "instance_1"
  }
}

#----------------------
# Creating and attaching an encrypted ebs volume
#----------------------

resource "aws_kms_key" "this" {
  enable_key_rotation = true
}


resource "aws_ebs_volume" "this" {
  availability_zone = "eu-west-3"
  size              = 1

  encrypted  = true
  kms_key_id = aws_kms_key.this.arn

  tags = {
    Name = "instance_1 volume"
  }
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
}

#----------------------
# Creating the instance_1 role and policy
#----------------------

data "aws_partition" "current" {}

locals {
  iam_role_name = "instance_1_role"
}

data "aws_iam_policy_document" "assume_role_policy" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name        = local.iam_role_name
  description = "IAM role for the instance_1"

  assume_role_policy    = data.aws_iam_policy_document.this_assume_role_policy[0].json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "this" {
  name = "instance_1 policy"
  role = aws_iam_role.this.id

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

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = var.this_policy.arn
  role       = aws_iam_role.this.name
}

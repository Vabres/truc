###############################################################################
# Instance 1 
###############################################################################

#----------------------
# Creating the security group for the instance_1
#----------------------

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "instance_1" {
  name        = "instance_1"
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

resource "aws_instance" "instance_1" {
  ami               = "ami-0ee415e1b8b71305f"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  security_groups   = [aws_security_group.instance_1.name]

  root_block_device {
    encrypted = true # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enable-at-rest-encryption/
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enforce-http-token-imds/
  }

  tags = {
    Name = "instance_1"
  }
}

#----------------------
# Creating and attaching an encrypted ebs volume
#----------------------

resource "aws_kms_key" "ebs_encryption_instance_1" {
  enable_key_rotation = true
}

resource "aws_ebs_volume" "instance_1_data_vol" {
  availability_zone = "eu-west-1a"
  size              = 1

  encrypted  = true
  kms_key_id = aws_kms_key.ebs_encryption_instance_1.arn

  tags = {
    Name = "instance_1_data_volume"
  }
}

resource "aws_volume_attachment" "instance_1_vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.instance_1_data_vol.id
  instance_id = aws_instance.instance_1.id
}

#----------------------
# Creating the instance_1 role and policy
#----------------------

data "aws_iam_policy_document" "instance_1_assume_role_policy" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "instance_1" {
  name        = "instance_1_role"
  description = "IAM role for the instance_1"

  assume_role_policy    = data.aws_iam_policy_document.instance_1_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "instance_1_policy" {
  name = "instance_1_policy"
  role = aws_iam_role.instance_1.id

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

###############################################################################
# Instance 2
###############################################################################

#----------------------
# Creating the security group for the instance_2
#----------------------

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "instance_2" {
  name        = "instance_2"
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

resource "aws_instance" "instance_2" {
  ami               = "ami-0ee415e1b8b71305f"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  security_groups   = [aws_security_group.instance_2.name]

  root_block_device {
    encrypted = true # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enable-at-rest-encryption/
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enforce-http-token-imds/
  }

  tags = {
    Name = "instance_2"
  }
}

#----------------------
# Creating and attaching an encrypted ebs volume
#----------------------

resource "aws_kms_key" "ebs_encryption_instance_2" {
  enable_key_rotation = true
}

resource "aws_ebs_volume" "instance_2_data_vol" {
  availability_zone = "eu-west-1a"
  size              = 1

  encrypted  = true
  kms_key_id = aws_kms_key.ebs_encryption_instance_2.arn

  tags = {
    Name = "instance_2_data_volume"
  }
}

resource "aws_volume_attachment" "instance_2_vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.instance_2_data_vol.id
  instance_id = aws_instance.instance_2.id
}

#----------------------
# Creating the instance_2 role and policy
#----------------------

data "aws_iam_policy_document" "instance_2_assume_role_policy" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "instance_2" {
  name        = "instance_2_role"
  description = "IAM role for the instance_2"

  assume_role_policy    = data.aws_iam_policy_document.instance_2_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "instance_2_policy" {
  name = "instance_2_policy"
  role = aws_iam_role.instance_2.id

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
###############################################################################
# Instance 3
###############################################################################

#----------------------
# Creating the security group for the instance_3
#----------------------

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group" "instance_3" {
  name        = "instance_3"
  description = "allow SSH traffic"

  ingress {
    description = "Allow public SSH traffic"
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "instance_3" {
  ami               = "ami-0ee415e1b8b71305f"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-1a"
  security_groups   = [aws_security_group.instance_3.name]

  root_block_device {
    encrypted = true # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enable-at-rest-encryption/
  }


  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required" # see : https://aquasecurity.github.io/tfsec/v1.27.5/checks/aws/ec2/enforce-http-token-imds/
  }

  tags = {
    Name = "instance_3"
  }
}

#----------------------
# Creating and attaching an encrypted ebs volume
#----------------------

resource "aws_kms_key" "ebs_encryption_instance_3" {
  enable_key_rotation = true
}

resource "aws_ebs_volume" "instance_3_data_vol" {
  availability_zone = "eu-west-1a"
  size              = 1

  encrypted  = true
  kms_key_id = aws_kms_key.ebs_encryption_instance_3.arn

  tags = {
    Name = "instance_3_data_volume"
  }
}

resource "aws_volume_attachment" "instance_3_vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.instance_3_data_vol.id
  instance_id = aws_instance.instance_3.id
}

#----------------------
# Creating the instance_3 role and policy
#----------------------

data "aws_iam_policy_document" "instance_3_assume_role_policy" {

  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "instance_3" {
  name        = "instance_3_role"
  description = "IAM role for the instance_3"

  assume_role_policy    = data.aws_iam_policy_document.instance_3_assume_role_policy.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "instance_3_policy" {
  name = "instance_3_policy"
  role = aws_iam_role.instance_3.id

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

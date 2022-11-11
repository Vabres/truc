###############################################################################
# Instance 1 
###############################################################################

#----------------------
# Creating the security group for the instance_1
#----------------------

resource "aws_security_group" "instance_1" {
  name        = "instance_1"
  description = "allow https traffic"

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
}


#----------------------
# Creating aws instance
#----------------------

resource "aws_instance" "instance_1" {
  ami               = "ami-5b673c34"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3"
  security_groups   = ["${aws_security_group.instance_1.name}"]
  tags = {
    Name = "instance_1"
  }
}

#----------------------
# Creating and attaching ebs volume
#----------------------

resource "aws_ebs_volume" "instance_1-data-vol" {
  availability_zone = "eu-west-3"
  size              = 1
  tags = {
    Name = "instance_1-data-volume"
  }
}

resource "aws_volume_attachment" "instance_1-vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.data-vol.id
  instance_id = aws_instance.instance_1.id
}

#----------------------
# Creating the instance_1 role and policy
#----------------------

data "aws_partition" "current" {}

locals {
  iam_role_name = "instance_1_role"
}

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
  name        = local.iam_role_name
  description = "IAM role for the instance_1"

  instance_1_assume_role_policy = data.aws_iam_policy_document.instance_1_assume_role_policy[0].json
  force_detach_policies         = true
}

resource "aws_iam_role_policy" "instance_1_policy" {
  name = "instance_1_policy"
  role = aws_iam_role.instance_1.id

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

resource "aws_iam_role_policy_attachment" "instance_1" {
  policy_arn = var.instance_1_policy.arn
  role       = aws_iam_role.instance_1.name
}


###############################################################################
# Instance 2
###############################################################################

#----------------------
# Creating the security group for the instance_2
#----------------------

resource "aws_security_group" "instance_2" {
  name        = "instance_2"
  description = "allow https traffic"

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
}


#----------------------
# Creating aws instance
#----------------------

resource "aws_instance" "instance_2" {
  ami               = "ami-5b673c34"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3"
  security_groups   = ["${aws_security_group.instance_2.name}"]
  tags = {
    Name = "instance_2"
  }
}

#----------------------
# Creating and attaching ebs volume
#----------------------

resource "aws_ebs_volume" "instance_2-data-vol" {
  availability_zone = "eu-west-3"
  size              = 1
  tags = {
    Name = "instance_2-data-volume"
  }
}

resource "aws_volume_attachment" "instance_2-vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.data-vol.id
  instance_id = aws_instance.instance_2.id
}

#----------------------
# Creating the instance_2 role and policy
#----------------------

data "aws_partition" "current" {}

locals {
  iam_role_name = "instance_2_role"
}

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
  name        = local.iam_role_name
  description = "IAM role for the instance_2"

  instance_2_assume_role_policy = data.aws_iam_policy_document.instance_2_assume_role_policy[0].json
  force_detach_policies         = true
}

resource "aws_iam_role_policy" "instance_2_policy" {
  name = "instance_2_policy"
  role = aws_iam_role.instance_2.id

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

resource "aws_iam_role_policy_attachment" "instance_2" {
  policy_arn = var.instance_2_policy.arn
  role       = aws_iam_role.instance_2.name
}

###############################################################################
# Instance 3
###############################################################################

#----------------------
# Creating the security group for the instance_3
#----------------------

resource "aws_security_group" "instance_3" {
  name        = "instance_3"
  description = "allow https traffic"

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
}


#----------------------
# Creating aws instance
#----------------------

resource "aws_instance" "instance_3" {
  ami               = "ami-5b673c34"
  instance_type     = "t2.micro"
  availability_zone = "eu-west-3"
  security_groups   = ["${aws_security_group.instance_3.name}"]
  tags = {
    Name = "instance_3"
  }
}

#----------------------
# Creating and attaching ebs volume
#----------------------

resource "aws_ebs_volume" "instance_3-data-vol" {
  availability_zone = "eu-west-3"
  size              = 1
  tags = {
    Name = "instance_3-data-volume"
  }
}

resource "aws_volume_attachment" "instance_3-vol" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.data-vol.id
  instance_id = aws_instance.instance_3.id
}

#----------------------
# Creating the instance_3 role and policy
#----------------------

data "aws_partition" "current" {}

locals {
  iam_role_name = "instance_3_role"
}

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
  name        = local.iam_role_name
  description = "IAM role for the instance_3"

  instance_3_assume_role_policy = data.aws_iam_policy_document.instance_3_assume_role_policy[0].json
  force_detach_policies         = true
}

resource "aws_iam_role_policy" "instance_3_policy" {
  name = "instance_3_policy"
  role = aws_iam_role.instance_3.id

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

resource "aws_iam_role_policy_attachment" "instance_3" {
  policy_arn = var.instance_3_policy.arn
  role       = aws_iam_role.instance_3.name
}

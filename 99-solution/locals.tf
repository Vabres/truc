locals {
  instances = {
    "instance_1" = {
      name    = "instance_1"
      sg_name = "Allow public HTTPS and specific HTTP traffic"
      sg_ingress_rules = {
        "1" = {
          description = "Allow public HTTPS traffic"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        "2" = {
          description = "Allow public HTTP traffic for testing purposes"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["200.200.200.200/32"]
        }
      }
    }
    "instance_2" = {
      name    = "instance_2"
      sg_name = "Allow public HTTPS traffic"
      sg_ingress_rules = {
        "1" = {
          description = "Allow public HTTPS traffic"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
      }
    },
    "instance_3" = {
      name    = "instance_3"
      sg_name = "Allow specific SSH traffic"
      sg_ingress_rules = {
        "1" = {
          description = "Allow specific SSH traffic"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["200.200.200.200/32"]
        },
      }
    }
  }
}

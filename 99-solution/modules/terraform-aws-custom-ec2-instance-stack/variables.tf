variable "instance_name" {
  type        = string
  description = "The name to give to identify the EC2 instance"
}

variable "sg_name" {
  type        = string
  description = "The name of the security group to create for EC2 instance"
}


variable "sg_ingress_rules" {
  type        = map(any)
  description = "A map of ingress rules to add to the EC2 instance security group"
}

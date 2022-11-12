module "ec2_instances" {
  source   = "./modules/terraform-aws-custom-ec2-instance-stack"
  for_each = local.instances

  instance_name    = each.value.name
  sg_name          = each.value.sg_name
  sg_ingress_rules = each.value.sg_ingress_rules
}


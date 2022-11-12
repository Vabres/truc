# https://developer.hashicorp.com/terraform/language/expressions/version-constraints

terraform {
  required_providers {
    mycloud = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

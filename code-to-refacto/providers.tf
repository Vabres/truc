provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      "owner"    = "formation-terraform"
      "practice" = "cloud-and-devops"
    }
  }
}

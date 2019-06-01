provider "scaleway" {
  version = "~> 1.8"
  region       = "par1"
}

provider "aws" {
  version = "~> 2.13"
  region  = "eu-west-3"
}

terraform {
  required_version = "~> 0.11"
}

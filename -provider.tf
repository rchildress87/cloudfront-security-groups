provider "archive" {
  version = "~> 1.3"
}

provider "aws" {
  region  = var.aws_region
  version = "~> 2.51"
}

provider "null" {}
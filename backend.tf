terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket  = "vaibhavi-tfstate-backup"
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}

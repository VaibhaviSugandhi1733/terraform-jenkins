variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "vaibhavi-practice-bucket-2005"
}

variable "bucket_tags" {
  description = "Tags for S3 bucket"
  type        = map(string)
  default = {
    Name        = "vaibhavi-practice-bucket-2005"
    Environment = "Dev"
  }
}

variable "iam_user_name" {
  description = "Name of the IAM user"
  type        = string
  default     = "vaibhavi2005"
}

variable "iam_user_path" {
  description = "IAM user path"
  type        = string
  default     = "/system/"
}

variable "iam_user_tags" {
  description = "Tags for IAM user"
  type        = map(string)
  default = {
    Environment = "Dev"
    Project     = "Terraform"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.1.0/24"
}


variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_tags" {
  description = "Tags for EC2 instances"
  type        = map(string)
  default = {
    Name = "my-instance"
  }
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}
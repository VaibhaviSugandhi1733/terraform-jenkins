
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  tags   = var.bucket_tags
}


resource "aws_iam_user" "vaibhavi" {
  name = var.iam_user_name
  path = var.iam_user_path
  tags = var.iam_user_tags
}


resource "aws_vpc" "vpc1" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = "vpc1"
  }
}


resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.public_subnet_cidr

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.private_subnet_cidr

  tags = {
    Name = "private"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "igw1"
  }
}


resource "aws_egress_only_internet_gateway" "egw1" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "egw1"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egw1.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "private"
  }
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my-instance" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public.id
  tags          = var.instance_tags
}

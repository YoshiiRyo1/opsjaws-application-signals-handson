locals {
  vpc_cidr_block    = "10.30.0.0/16"
  subnet_cidr_block = "10.30.30.0/24"

}


// VPC
resource "aws_vpc" "main" {
  cidr_block           = local.vpc_cidr_block
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
}

// Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subenet"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

// Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public_route_table"
  }
}

// Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

// IAM Role for Cloud9
resource "aws_iam_role" "cloud9" {
  name = "cloud9-handson-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/IAMFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
  ]
}

// Cloud9 Environment
resource "aws_cloud9_environment_ec2" "main" {
  instance_type               = "m5.large"
  name                        = "opsjaws-handson"
  image_id                    = "amazonlinux-2023-x86_64"
  automatic_stop_time_minutes = 30
  subnet_id                   = aws_subnet.public.id
}

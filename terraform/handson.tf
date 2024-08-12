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
    Name = "opsjaws_handson_public_subenet"
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
    Name = "opsjaws_handson_public_route_table"
  }
}

// Route Table Association
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

// IAM Role for EC2
resource "aws_iam_role" "ec2" {
  name = "ec2-handson-role"
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
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/CloudWatchSyntheticsFullAccess"
  ]
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ec2-handson-profile"
  role = aws_iam_role.ec2.name
}

// Security Group
resource "aws_security_group" "main" {
  name        = "allow_http"
  description = "opsjaws handson security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "opsjaws_handson_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.main.id
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "main" {
  security_group_id = aws_security_group.main.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

// Handson Instance
resource "aws_instance" "main" {
  instance_type        = "m5.large"
  ami                  = "ami-0c865e0f6120c0c63" # Amazon ECS-Optimized Amazon Linux 2023 (AL2023) x86_64 AMI
  subnet_id            = aws_subnet.public.id
  iam_instance_profile = aws_iam_instance_profile.ec2.name

  tags = {
    "Name" = "opsjaws_handson"
  }
}

resource "aws_cloudwatch_log_group" "dice-server" {
  name              = "dice-server"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "petseach" {
  name              = "petseach"
  retention_in_days = 1
}

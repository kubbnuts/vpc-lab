terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

# Create a VPC
resource "aws_vpc" "DemoVPC-Test" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Demo-VPC-Test"
  }
}

resource "aws_subnet" "public_subnet-a" {
  vpc_id            = aws_vpc.DemoVPC-Test.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1a"
 
  tags = {
    Name = "Public Subnet A"
  }
}


resource "aws_subnet" "public_subnet-b" {
  vpc_id            = aws_vpc.DemoVPC-Test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "private_subnet-a" {
  vpc_id            = aws_vpc.DemoVPC-Test.id
  cidr_block        = "10.0.16.0/20"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "Private Subnet A"
  }
}

resource "aws_subnet" "private-subnet-b" {
  vpc_id            = aws_vpc.DemoVPC-Test.id
  cidr_block        = "10.0.32.0/20"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "Private Subnet B"
  }
}

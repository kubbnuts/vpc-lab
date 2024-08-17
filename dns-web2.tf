
#https://developer.hashicorp.com/terraform/language/providers/configuration
provider "aws" {
  alias  = "west"
  region = "us-west-1"
}

resource "aws_security_group" "SG-1" {
  provider    = aws.west
  name        = "PermissiveSG"
  description = "Allow SSH inbound traffic"
#  vpc_id      = aws_vpc.DemoVPC-Test.id

  tags = {
    Name = "PermissiveSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_in_bastion_1" {
  provider          = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_443_in_bastion_1" {
  provider    = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_1" {
  provider    = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_80_bastion_1" {
  provider    = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
} 

resource "aws_vpc_security_group_egress_rule" "allow_443_bastion_1" {
  provider    = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
} 

resource "aws_vpc_security_group_egress_rule" "allow_outbound_ssh_1" {
  provider    = aws.west
  security_group_id = aws_security_group.SG-1.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


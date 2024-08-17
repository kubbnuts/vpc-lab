#https://developer.hashicorp.com/terraform/language/providers/configuration
provider "aws" {
  alias  = "apac"
  region = "ap-south-1"
}

resource "aws_security_group" "SG-2" {
  provider    = aws.apac
  name        = "PermissiveSG-2"
  description = "Allow SSH inbound traffic"

  tags = {
    Name = "PermissiveSG-2"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_in_bastion_2" {
  provider          = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_443_in_bastion_2" {
  provider    = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_2" {
  provider    = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_80_bastion_2" {
  provider    = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
} 

resource "aws_vpc_security_group_egress_rule" "allow_443_bastion_2" {
  provider    = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
} 

resource "aws_vpc_security_group_egress_rule" "allow_outbound_ssh_2" {
  provider    = aws.apac
  security_group_id = aws_security_group.SG-2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}


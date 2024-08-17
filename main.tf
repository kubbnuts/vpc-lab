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
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = {
    Name = "Demo-VPC-Test"
  }
}

resource "aws_subnet" "public-subnet-a" {
  vpc_id                  = aws_vpc.DemoVPC-Test.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = "true"
 
  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public-subnet-b" {
  vpc_id            = aws_vpc.DemoVPC-Test.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "private-subnet-a" {
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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DemoVPC-Test.id

  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "BastionHostSG" {
  name        = "BastionHostSG"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.DemoVPC-Test.id

  tags = {
    Name = "BastionHostSG"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_80_in_bastion" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_443_in_bastion" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_3306_bastion" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 3306
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_80_bastion" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
} 

resource "aws_vpc_security_group_egress_rule" "allow_443_bastion" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
} 

resource "aws_vpc_security_group_egress_rule" "allow_outbound_ssh" {
  security_group_id = aws_security_group.BastionHostSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

resource "aws_key_pair" "TFKeyPair" {
  key_name = "TFKey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCx0Hk9wRzauPFyXQVz5ZivDsvkTPuA5BXVzvX2trNLAzMg7Mea3qQ89jS8CC+LJIy1XWSKqbjfxtIJH8W5ByJBie05fPyxWW6oIgu9lc2g3XUPX33D1O1izoN9Wdflunim9P7Nk+FKDpl1VpdsHRXBebRHF8iC+XOrPYPIbazunCkR9Wm5DPKsBLM9wjB6p86/zKffu2LDmDvBLv9I6BvvPM+1xD3QnKMfIMS3zqHzceF4VvhkrOF3bhf5Lkk2XxAm+5TonNe4PZywCybDGwP7NNzPFFe1LBTr1vH4LqJUZHTdwqjVUrLiGR2ee1apCcHenpSM3yIxnruDrjZKIrbyTM6O9YyR2qukDnzZqW/FD0k69llw7h0d7JJd/G+lfyWm0o6tCYZ800Bke98lB4b5ze762tKoVJMtu9Fz01IYbPDEbBLgh63NQMb+7wn1YIe7Xxa47k05D8IaOgSSgaTayNsPlOQan3+Uyifa/yBQ0H1gKWCK1Qrlo4q9q6esI6izvWDO7bFe2UJpz68MJ5IshaWlhjZ3p4TvURo4OJrbAd5AE3XKai5wljUSuASNSh7/DW9y8S9Rh9X6yMA8HtHSGDi43X703dn9qG537/EOvkHZKlq+V+MRts0wFO1P6J4RORUgjSkuImOrBkUhUwPCNB7VyiVJOUmDfN1lOyiaUw== sophiekubitz@Sophies-MacBook-Air.local"
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.DemoVPC-Test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public-a" {
  subnet_id      = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public-b" {
  subnet_id      = aws_subnet.public-subnet-b.id
  route_table_id = aws_route_table.public-route-table.id
}

#resource "aws_route_table" "private-route-table" {
#  vpc_id = aws_vpc.DemoVPC-Test.id

#  route 
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_nat_gateway.DemoNATGW.id #nat

##    depends_on = [ aws_nat_gateway.DemoNATGW ]
#  }


#  tags = {
#    Name = "PrivateRouteTable"
#  }
#}

resource "aws_route_table_association" "private-a" {
  subnet_id      = aws_subnet.private-subnet-a.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private-b" {
  subnet_id      = aws_subnet.private-subnet-b.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_iam_role" "EC2-SSM-TF" {
  name = "EC2-SSM-TF"
  managed_policy_arns   = [ "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" ]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "EC2-SSM-TF"
  }
}

resource "aws_security_group" "PrivateSG" {
  name        = "PrivateSG"
  description = "Allow SSH inbound traffic from Bastion"
  vpc_id      = aws_vpc.DemoVPC-Test.id

  tags = {
    Name = "PrivateSG"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_443" {
  security_group_id = aws_security_group.PrivateSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_80" {
  security_group_id = aws_security_group.PrivateSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}
   
resource "aws_vpc_security_group_egress_rule" "allow_icmp" {
  security_group_id = aws_security_group.PrivateSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
} 

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_from_bastionhost" {
  security_group_id = aws_security_group.PrivateSG.id
#  cidr_ipv4         = "0.0.0.0/0"
  referenced_security_group_id = aws_security_group.BastionHostSG.id
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22 
} 

resource "aws_vpc_security_group_ingress_rule" "allow_EC2_Instance_Connect" {
  security_group_id = aws_security_group.PrivateSG.id
  cidr_ipv4         = "18.202.216.48/29"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
} 

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_placeholder" {
  security_group_id = aws_security_group.PrivateSG.id
  cidr_ipv4         = "10.0.0.0/24"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}   

# Lab 335 VPC Peering
# Create a VPC
#resource "aws_vpc" "DefaultVPC" {
#  cidr_block = "172.31.0.0/16"
#  tags = {
#    Name = "DefaultVPC"
#  }
#}
# Incorrect - use resource "aws_default_vpc" "default" {

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Lab 337 VPC Endpoints
resource "aws_iam_role" "EC2-S3-TF" {
  name = "EC2-S3-TF"
  managed_policy_arns   = [ "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" ]
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },            
    ]
  })

  tags = {
    name = "EC2-S3-TF"
  }
}

resource "aws_iam_instance_profile" "s3_profile" {
  name = "s3_profile"
  role = aws_iam_role.EC2-S3-TF.name
}

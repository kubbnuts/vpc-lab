# Lab 328 NAT Instances (for Elastic IP Creation)
resource "aws_eip" "nat-eip" {
  domain   = "vpc"

  depends_on = [aws_internet_gateway.igw]
}


# Lab 330 NAT Gateways

resource "aws_nat_gateway" "DemoNATGW" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet-a.id

  tags = {
    Name = "gw NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

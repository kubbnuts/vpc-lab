resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.DemoVPC-Test.id

#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.gw.id
#  }


  tags = {
    Name = "PrivateRouteTable"
  }
}


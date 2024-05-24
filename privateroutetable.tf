resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.DemoVPC-Test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.DemoNATGW.id #nat

#    depends_on = [ aws_nat_gateway.DemoNATGW ]
  }


  tags = {
    Name = "PrivateRouteTable"
  }
}


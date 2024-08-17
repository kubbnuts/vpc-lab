resource "aws_instance" "bastion-server" {
  ami                    = "ami-0d421d84814b7d51c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-subnet-a.id
  vpc_security_group_ids = [ aws_security_group.BastionHostSG.id ]
  key_name               = "TFKey"

  tags = {
    Name ="Bastion Host"
  }
}

resource "aws_instance" "PrivateEC2" {
  ami                    = "ami-0d421d84814b7d51c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private-subnet-a.id
  vpc_security_group_ids = [ aws_security_group.PrivateSG.id ]
  key_name               = "TFKey"
  
  tags = {
    Name = "PrivateEC2"
  }
} 

#Lab 335 Part 2
#resource "aws_instance" "DefaultEc2" { 
#  ami                    = "ami-0d421d84814b7d51c"
#  instance_type          = "t2.micro"
  
 
#  tags = {
#    Name = "DefaultEC2" 
#  }
#} 

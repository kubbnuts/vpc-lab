resource "aws_instance" "bastion-server" {
  ami                    = "ami-0d421d84814b7d51c"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public-subnet-a.id
  vpc_security_group_ids = [ aws_security_group.BastionHostSG.id ]
  key_name               = "TFKey"
  iam_instance_profile   = "s3_profile"

  tags = {
    Name ="Bastion Host"
  }
}


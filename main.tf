provider "aws" {
  region = "us-east-1"

}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-007855ac798b5175e"
  instance_type = "t2.micro"
  key_name      = "mykey-1"
  count = "1"
  subnet_id     = "subnet-0dfa93eda3617de6e"
  vpc_security_group_ids = ["sg-0939199220c5735aa"]
   associate_public_ip_address = true
  tags = {
    Name = "riyaz ec2"
  }
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "riyazvpc"
  }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Example Subnet"
  }
}

resource "aws_security_group" "sample-test" {
  name_prefix = "mysg"
    vpc_id = aws_vpc.myvpc.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Example Security Group"
  }
}



resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "mygateway"
  }
}


resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myig.id
  }
}

 resource "aws_route_table_association" "subnet" {
  subnet_id      = aws_subnet.publicsubnet.id
  route_table_id = aws_route_table.myroute.id
} 

  

 

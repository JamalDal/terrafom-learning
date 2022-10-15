terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "vpc1"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_subnet_1"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id  = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    "name" = "private_subnet_1"
  }
}

resource "aws_security_group" "sg_22" {
  name        = "sg_22"
  description = "Allow TLS inbound ssh traffic"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description      = "ssh TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "security_group_22"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = "main_igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_rt_1"
  }
}

resource "aws_route_table_association" "public_association_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_key_pair" "key_pair_1" {
  key_name   = "key_pair_1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLaun1tuHkQpYZWMqV/sbQ2SxBp/3HGJnwVu1hAcclvc8aotnbPvUfbFNk1Hizr2AsHIXzaHKDJG2ow6kKtVEuEQtfWM5MByrtPFQRG5xNCFvrdSvxJuC9SnNfrqdzUadC3QYy+C+sfIzs6QbGk38m23ZedSiiGU4kFTTksCghWFtqj7AY9cLQ6JW3SJh1CHtWRUzGEEqtR3h8TP7Vej008t0pg4GEUGZw0jeQHj4DOigod7v4W3xzR/kVgUPp60AGGnbJQrgt5VeWSp4E2aWHPa/UZ+ql8wDYMipmhzkRNC4cL8xdLxeoCnzsWKzqeYsqK09xMMtUi6+hUmHzmO77VmQ7AKAdeOtB2A7HZgwzhnV0LXxlhkArzcjx20YgpH7MxkyrlTBbmubfeQY6SWOFBV91U03pN8EAYUiCnrpu1E+oj/WB8iDLRC3JdOuTrz7nCZpX6MllDX9KbnZekEd5BrkiLNzAIFUhfg2OQpZig2rMid++vE3P/QJn1jQE5W8= mohammadjamal@Mohammads-MacBook-Air-2.local"
}


resource "aws_instance" "webtest" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
  subnet_id               = aws_subnet.public_subnet.id
  key_name                = aws_key_pair.key_pair_1.id
  vpc_security_group_ids   = [aws_security_group.sg_22.id]

  tags = {
    Name        = "web_server"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
  subnet_id               = aws_subnet.private_subnet.id
  key_name                = aws_key_pair.key_pair_1.id
  vpc_security_group_ids   = [aws_security_group.sg_22.id]

  tags = {
    Name        = "db_server"
  }
}

resource "aws_eip" "web-eip" {
  instance = aws_instance.webtest.id
  vpc      = true
}

resource "aws_eip" "nat_gateway-eip" {
  vpc      = true
}

resource "aws_nat_gateway" "public_nat_gw" {
  allocation_id = aws_eip.nat_gateway-eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "NAT_gw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.public_nat_gw.id
  }

  tags = {
    Name = "private_rt_1"
  }
}


resource "aws_route_table_association" "private_association_rt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}




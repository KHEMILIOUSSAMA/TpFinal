terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.16"
    }
  }
}

variable "myname" {
  description = "Mon nom à ajouter dans chaque nommage"
  default     = "oussama"
}

provider "aws" {
  region = "eu-west-1"
}

resource "tls_private_key" "mykey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.myname}-macle"
  public_key = tls_private_key.mykey.public_key_openssh
}

resource "aws_vpc" "vpc-oussama" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPC-Oussama"
  }
}

resource "aws_subnet" "subnet-oussama" {
  vpc_id                  = aws_vpc.vpc-oussama.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-Oussama"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "${var.myname}-allow_ssh"
  vpc_id      = aws_vpc.vpc-oussama.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH from any IP"
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SecurityGroup-Oussama"
  }
}

resource "aws_instance" "myinstance1" {
  ami              = "ami-07355fe79b493752d"
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.mykeypair.key_name
  subnet_id        = aws_subnet.subnet-oussama.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Instance-Oussama-1"
  }
}

resource "aws_instance" "myinstance2" {
  ami              = "ami-07355fe79b493752d"
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.mykeypair.key_name
  subnet_id        = aws_subnet.subnet-oussama.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Instance-Oussama-2"
  }
}

resource "aws_instance" "myinstance3" {
  ami              = "ami-07355fe79b493752d"
  instance_type    = "t2.micro"
  key_name         = aws_key_pair.mykeypair.key_name
  subnet_id        = aws_subnet.subnet-oussama.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Instance-Oussama-3"
  }
}


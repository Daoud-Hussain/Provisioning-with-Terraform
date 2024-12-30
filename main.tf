terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "app_server" {
  ami           = "ami-053b12d3152c0cc71"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ec2-key.key_name
  security_groups = [aws_security_group.ec2_sg.name]  


  tags = {
    Name = "TerraformCreatedServer"
  }
}


resource "aws_key_pair" "ec2-key"{
 key_name = "terraform-key"
 public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_security_group" "ec2_sg" {
 name_prefix = "ec2-sg-"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]                 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

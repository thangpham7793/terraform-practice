terraform {
  //which providers to download
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  //refer to aws creds instead of hardcoding creds
  profile = "default"
  region  = var.region
}

resource "aws_instance" "example" {
  ami           = var.amis[var.region]
  instance_type = "t2.micro"
}

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.example.id
}

output "ami" {
    value = aws_instance.example.ami
}

output "ip" {
    value = aws_eip.ip.public_ip
}
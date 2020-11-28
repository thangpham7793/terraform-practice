provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "aws_server_port"
  type = number
  default = 8080
}

output "public_ip" {
  value = aws_instance.instance.public_ip
  description = "The Public IP so you don't have to look it up!"
}


output "test_route" {
  value = "curl http://${aws_instance.instance.public_ip}:${var.server_port} -v"
  description = "Curl this!"
}

resource "aws_instance" "instance" {
  ami = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro" 
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF


  tags = {
    Name = "new-tag"
  }
}

resource "aws_security_group" "instance" {
  name = "aws-example-instance-sg"

  ingress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allowing ingress from all IPs"
    from_port = var.server_port
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "tcp"
    security_groups = []
    self = false
    to_port = var.server_port
  } ]
}

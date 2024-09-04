provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02c21308fed24a8ab" # Replace with the latest Amazon Linux 2 AMI ID for your region
  instance_type = "t2.micro"

  tags = {
    Name = "Nextjs-Staging-Server"
  }

  # Add a security group to allow SSH and HTTP access
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              usermod -aG docker ec2-user
              docker run -d -p 80:3000 mud2003/my-nextjs-app:latest
              EOF
}

resource "aws_security_group" "app_sg" {
  name_prefix = "app-sg-next"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

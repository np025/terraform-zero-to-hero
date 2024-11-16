provider "aws" {
  region = "ap-south-1" # Replace with your desired AWS region
}

# Define Security Group
resource "aws_security_group" "nginx_security_group" {
  name        = "allow-nginx"
  description = "Allow HTTP traffic on port 80"

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from anywhere
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx-security-group"
  }
}

# Define EC2 Instance
resource "aws_instance" "nginx_instance" {
  ami           = "ami-09298640a92b2d12c" # Replace with an appropriate Ubuntu AMI ID for ap-south-1
  instance_type = "t2.micro"

  # Enable public IP
  associate_public_ip_address = true

  # Attach the security group
  security_groups = [aws_security_group.nginx_security_group.name]

  # User Data to install and start NGINX
  user_data = <<-EOF
  #!/bin/bash
  apt-get update
  apt-get install -y nginx
  systemctl start nginx
  systemctl enable nginx
  EOF

  tags = {
    Name = "nginx-instance"
  }
}

# Output the public IP
output "nginx_public_ip" {
  value = aws_instance.nginx_instance.public_ip
  description = "The public IP of the NGINX server"
}

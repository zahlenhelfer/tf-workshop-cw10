provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = "ami-0a261c0e5f51090b1"
  user_data     = file("install_webserver.sh")
}


resource "aws_security_group" "web_access" {
  name        = "web-security-group"
  description = "Terraform web security group"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

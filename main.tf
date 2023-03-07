provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  count                  = 4
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_access.id]
  ami                    = "ami-0a261c0e5f51090b1"
  user_data              = file("install_webserver.sh")
  subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]

  tags = {
    Name = "web-${count.index + 1}"
  }

}

resource "aws_security_group" "web_access" {
  name        = "web-security-group"
  description = "Terraform web security group"
  vpc_id      = module.vpc.vpc_id
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

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

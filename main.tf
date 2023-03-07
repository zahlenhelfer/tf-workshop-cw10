provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami           = "ami-0a261c0e5f51090b1"
  user_data     = file("install_webserver.sh")
}

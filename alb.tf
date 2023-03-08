resource "aws_lb" "alb-webserver" {
  name               = "alb-web-demo"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_access.id]
  subnets            = module.vpc.public_subnets

  tags = {
    Costcenter = "666"
  }
}

resource "aws_security_group" "alb_access" {
  name        = "alb-security-group"
  description = "Terraform alb security group"
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
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb-webserver.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-webserver.arn
  }
}

resource "aws_lb_target_group" "tg-webserver" {
  name     = "tf-alb-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_target_group_attachment" "tga-webserver" {
  count            = var.node_count
  target_group_arn = aws_lb_target_group.tg-webserver.arn
  target_id        = aws_instance.web[count.index].id
  port             = 80
}

resource "aws_lb" "this" {
  name               = "${var.env_name}-ALB"
  security_groups    = [aws_security_group.alb.id]
  load_balancer_type = "application"

  subnets = var.public_subnets #subnetprivada ver se funciona

}

resource "aws_lb_target_group" "this" {
  name        = "${var.env_name}ALB-TG"
  port        = 8081
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200,301,302"
    path                = "/health"
    timeout             = "5"
    unhealthy_threshold = "5"
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.env_name}-ALB-SG"
  description = "SG-ALB-${var.env_name}"
  vpc_id      = var.vpc_id


  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = var.container_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
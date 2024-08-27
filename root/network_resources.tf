resource "aws_alb" "three-tier-web-lb" {
    name = "three-tier-web-lb"
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.three-tier-web-sg-lb-1.id]
    subnets = [ module.network.public_subnet_ids[0].id, module.network.public_subnet_ids[1].id  ]
    enable_deletion_protection = true
    tags = {
        Environment = "three-tier-web-lb"
  }
}

resource "aws_lb_target_group" "three-tier-web-lb-tg" {
    name = "three-tier-web-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = module.network.vpc_id

    health_check {
      interval = 30
      path = "/"
      port = "traffic-port"
      timeout = 10
      healthy_threshold = 3
      unhealthy_threshold = 3
    }
}

resource "aws_lb_listener" "three-tier-web-lb-listener" {
    load_balancer_arn = aws_alb.three-tier-web-lb.arn
    port = 80
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.three-tier-web-lb-tg.arn
    }
}

resource "aws_autoscaling_attachment" "three-tier-web-attach-tg" {
    autoscaling_group_name = aws_autoscaling_group.three-tier-web-asg.name
    lb_target_group_arn = aws_lb_target_group.three-tier-web-lb-tg.arn
}
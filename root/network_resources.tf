resource "aws_cloudfront_distribution" "web_distribution" {
    origin {
        domain_name              = aws_lb.three-tier-web-lb.dns_name
        origin_id                = "myALBOrigin"
    }
    
    enabled = true
    is_ipv6_enabled = false
    default_root_object = "index.html"

    aliases = ["www.example.com"]

    default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "myALBOrigin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
    
    price_class = "PriceClass_All"

    restrictions {
        geo_restriction {
          restriction_type = none
          locations = []
        }
    }

    viewer_certificate {
     cloudfront_default_certificate = true
    }
}


resource "aws_lb" "three-tier-web-lb" {
    name = "three-tier-web-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.three-tier-web-sg-lb-1.id]
    subnets = [ module.network.public_subnet_ids[0].id, module.network.public_subnet_ids[1].id  ]
    enable_deletion_protection = true
    tags = {
        Environment = "three-tier-web-lb"
  }
}

resource "aws_lb" "three-tier-app-lb" {
    name = "three-tier-app-lb"
    internal = true
    load_balancer_type = "application"
    security_groups = [aws_security_group.three-tier-app-sg-lb-2.id]
    subnets = [ module.network.private_subnet_ids[0].id, module.network.private_subnet_ids[1].id  ]
    enable_deletion_protection = true
    tags = {
      Environment = "three-tier-app-alb"
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
      protocol = "HTTP"
      healthy_threshold = 3
      unhealthy_threshold = 3
    }
}

resource "aws_lb_target_group" "three-tier-app-lb-tg" {
    name = "three-tier-app-lb-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = module.network.vpc_id

    health_check {
      interval = 30
      path = "/"
      port = "traffic-port"
      timeout = 10
      protocol = "HTTP"
      healthy_threshold = 3
      unhealthy_threshold = 3
    }
}

## Nesse load balancer eu adiciono o certificado para fazer um SSL termination
resource "aws_lb_listener" "three-tier-web-lb-listener" {
    load_balancer_arn = aws_lb.three-tier-web-lb.arn
    port = "443"
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-2016-08"
    certificate_arn = module.acm_certificate.arn
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.three-tier-web-lb-tg.arn
    }
}

resource "aws_lb_listener" "three-tier-app-lb-listener" {
    load_balancer_arn = aws_lb.three-tier-app-lb.arn
    port = "80"
    protocol = "HTTP"
    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.three-tier-app-lb-tg.arn
    }
}

resource "aws_autoscaling_attachment" "three-tier-web-attach-tg" {
    autoscaling_group_name = aws_autoscaling_group.three-tier-web-asg.name
    lb_target_group_arn = aws_lb_target_group.three-tier-web-lb-tg.arn
}

resource "aws_autoscaling_attachment" "three-tier-app-attach-tg" {
    autoscaling_group_name = aws_autoscaling_group.three-tier-app-asg.name
    lb_target_group_arn = aws_lb_target_group.three-tier-app-lb-tg.arn
}
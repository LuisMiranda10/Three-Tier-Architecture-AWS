## web load balancer security group
resource "aws_security_group" "three-tier-web-sg-lb-1" {
  name        = "three-tier-web-sg"
  description = "Allow HTTPS into Load balancer security group for web tier"
  vpc_id      = module.network.vpc_id
  depends_on  = [module.network.vpc_id]

  ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    prefix_list_ids = ["pl-global-cloudfront-origin"] # lista gerenciada pela AWS de prefixos do CloudFront
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three-tier-web-sg-lb-1"
  }
}

## app load balancer security group
resource "aws_security_group" "three-tier-app-sg-lb-2" {
  name        = "three-tier-app-sg-lb-2"
  description = "Allow traffic into Load balancer security group for app tier"
  vpc_id      = module.network.vpc_id
  depends_on  = [module.network.vpc_id]

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.three-tier-web-ec2-asg-sg.id]
  }

  tags = {
    Name = "three-tier-app-sg-lb-2"
  }
}

## web ec2 auto scaling group
resource "aws_security_group" "three-tier-web-ec2-asg-sg" {
  name        = "three-tier-web-ec2-asg-sg"
  description = "Allow traffic from ALB"
  vpc_id      = module.network.vpc_id
  depends_on  = [module.network.vpc_id]

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.three-tier-web-sg-lb-1.id]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three-tier-web-ec2-asg-sg"
  }
}

## app ec2 auto scaling group
resource "aws_security_group" "three-tier-app-ec2-asg-sg" {
  name        = "three-tier-app-ec2-asg-sg"
  description = "Allow traffic from ALB"
  vpc_id      = module.network.vpc_id
  depends_on  = [module.network.vpc_id]

  ingress {
    from_port       = "80"
    to_port         = "80"
    protocol        = "tcp"
    security_groups = [aws_security_group.three-tier-app-sg-lb-2.id]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three-tier-app-ec2-asg-sg"
  }
}
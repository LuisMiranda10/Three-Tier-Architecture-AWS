## web load balancer security group
resource "aws_security_group" "three-tier-web-sg-lb-1" {
    name = "three-tier-web-sg"
    description = "Allow HTTP into Load balancer security group for web tier"
    vpc_id = module.network.vpc_id
    depends_on = [ module.network.vpc_id ]  

    ingress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        self = "colocar o cloudfront aqui ainda"
    }
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

## web ec2 auto scaling group
resource "aws_security_group" "three-tier-web-ec2-asg-sg" {
    name = "three-tier-web-ec2-asg-sg"
    description = "Allow traffic from VPC"
    vpc_id = module.network.vpc_id
    depends_on = [ module.network.vpc_id ]

    ingress {
        from_port   = "80"
        to_port     = "80"
        protocol    = "tcp"
        self = aws_security_group.three-tier-web-sg-lb-1.id
    }
    egress {
        from_port   = "0"
        to_port     = "0"
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
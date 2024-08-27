resource "aws_autoscaling_group" "three-tier-web-asg" {
  name                 = "three-tier-web-asg"
  launch_configuration = aws_launch_configuration.three-tier-web-config
  vpc_zone_identifier  = [module.network.subnets-public-id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
  health_check_type = "ELB"
}

resource "aws_launch_configuration" "three-tier-web-config" {
    name_prefix                 = "three-tier-web-config"
    image_id                    = "ami-0b3a4110c36b9a5f0"
    instance_type               = "t2.micro"
    key_name                    = "three-tier-web-asg-kp"
    security_groups = [aws_autoscaling_group.three-tier-web-asg.id]
    user_data_base64 =  <<-EOF
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
        EOF
    associate_public_ip_address = true
    lifecycle {
        prevent_destroy = true
        ignore_changes = all
    }
}
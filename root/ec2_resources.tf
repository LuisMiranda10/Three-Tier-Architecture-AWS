resource "aws_autoscaling_group" "three-tier-web-asg" {
  name                 = "three-tier-web-asg"
  launch_configuration = aws_launch_configuration.three-tier-web-config.id
  vpc_zone_identifier  = [module.network.public_subnet_ids[0].id, module.network.public_subnet_ids[1].id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
}

resource "aws_autoscaling_group" "three-tier-app-asg" {
  name                 = "three-tier-app-asg"
  launch_configuration = aws_launch_configuration.three-tier-app-config.id
  vpc_zone_identifier  = [module.network.private_subnet_ids[0].id, module.network.private_subnet_ids[1].id]
  min_size             = 2
  max_size             = 3
  desired_capacity     = 2
}

resource "aws_launch_configuration" "three-tier-web-config" {
  name_prefix                 = "three-tier-web-config"
  image_id                    = "ami-0b3a4110c36b9a5f0"
  instance_type               = "t2.micro"
  key_name                    = "three-tier-web-asg-kp"
  security_groups             = [aws_security_group.three-tier-web-ec2-asg-sg.id]
  user_data                   = <<-EOF
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
        EOF
  associate_public_ip_address = true
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}

resource "aws_launch_configuration" "three-tier-app-config" {
  name_prefix                 = "three-tier-app-config"
  image_id                    = "ami-0b3a4110c36b9a5f0"
  instance_type               = "t2.micro"
  key_name                    = "three-tier-app-asg-kp"
  security_groups             = [aws_security_group.three-tier-app-ec2-asg-sg.id]
  user_data                   = <<-EOF
        #!/bin/bash

        sudo yum install mysql -y
        EOF
  associate_public_ip_address = false
  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}


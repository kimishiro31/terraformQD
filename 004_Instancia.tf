

resource "aws_security_group" "sg-ins-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id
  name = "SG_INS_PRJ2023"
  ingress {
    description = "Acesso Interno"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Requisicao LB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = []
    security_groups = ["${aws_security_group.sg-elb-prj2023.id}"]
  }

  egress {
    description = "Saida LB"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = []
    security_groups = ["${aws_security_group.sg-elb-prj2023.id}"]
  }

  egress {
    description = "Saida BD"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = []
    security_groups = ["${aws_security_group.sg-rds-prj2023.id}"]
  }

  tags = var.default_tags
}

resource "aws_launch_template" "ins-prj2023" {
  image_id      = "ami-0e5e218942becdecf"
  instance_type = "t2.micro"

  vpc_security_group_ids = ["${aws_security_group.sg-elb-prj2023.id}", "${aws_security_group.sg-ins-prj2023.id}"]

  tags = merge(var.default_tags, {
    Name = "ins-prj2023"
  })
}

resource "aws_autoscaling_group" "AS_prj2023" {
  desired_capacity          = 4
  max_size                  = 8
  min_size                  = 4
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = ["${aws_subnet.pub-subnet-prj2023-a1.id}", "${aws_subnet.pub-subnet-prj2023-b1.id}"]
  load_balancers            = ["${aws_elb.elb-prj2023.id}"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.ins-prj2023.id
    version = "$Latest"
  }

  depends_on = [aws_elb.elb-prj2023]

  dynamic "tag" {
    for_each = var.default_as_tags
    content {
      key                 = tag.value.key
      propagate_at_launch = tag.value.propagate_at_launch
      value               = tag.value.value
    }
  }
}

## Scale Up
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "prj-2023-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.AS_prj2023.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "prj-2023-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" 

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.AS_prj2023.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}


## Scale Down
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "prj-2023-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.AS_prj2023.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "prj-2023-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.AS_prj2023.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}


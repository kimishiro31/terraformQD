

resource "aws_security_group" "sg-elb-prj2023" {
  vpc_id = aws_vpc.vpc-prj2023.id
    name = "SG_ELB_PRJ2023"
  ingress {
    description = "Acesso Interno"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Acesso Externo"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.default_tags
}

resource "aws_vpc_security_group_egress_rule" "sg-ins-sg-elb" {
  security_group_id = aws_security_group.sg-elb-prj2023.id

  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
  referenced_security_group_id = aws_security_group.sg-ins-prj2023.id
}

resource "aws_elb" "elb-prj2023" {
  name = "elb-prj2023"
  security_groups = ["${aws_security_group.sg-elb-prj2023.id}"]
  subnets         = ["${aws_subnet.pub-subnet-prj2023-a1.id}", "${aws_subnet.pub-subnet-prj2023-b1.id}"]

  // Vai armazenar os logs dentro do bucket
  access_logs {
    bucket   = "elb-bucket-prj2023"
    interval = 60
  }

  // controle de trafego
  listener {
    instance_port     = 80     // porta que vai enviar a solicitação de acesso
    instance_protocol = "http" // protocolo da solicitação

    lb_port     = 8000   // porta em que vai vim a solicitação de acesso
    lb_protocol = "http" // protocolo da solicitação
  }

  health_check {
    healthy_threshold   = 2          // numero de verificações antes de ser considerada integra
    unhealthy_threshold = 2          // numero de verificações antes de ser considerada não integra 
    timeout             = 3          // tempo antes que a verificação expire em segundos
    target              = "HTTP:80/" // alvo da verificação "procolo:porta:/caminho"
    interval            = 30         // intervalo entre uma verificação e outra
  }

  tags = merge(var.default_tags, {
    Name = "elb-prj2023"
  })
}

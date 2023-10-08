variable "region" {
  type        = string
  description = "Região no AWS onde nossos recursos estarão."
  default     = "us-east-1"
}

variable "ami" {
  type        = string
  description = "ID da imagem EC2 que desejamos utilizar para nossa instância."
  default     = "ami-053b0d53c279acc90" // Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-05-16
}

variable "instance_type" {
  type        = string
  description = "Tipo de instância a ser utilizado"
  default     = "t2.micro"
}

variable "default_tags" {
  type        = map(string)
  description = "Tags Default para todos os recursos."

  default = {
    Ambiente    = "Laboratorio"
    Projeto     = "Small Infrastructure"
    Responsavel = "Thiago Lima"
    Managed-by  = "Terraform"
  }
}

variable "default_as_tags" {
  default = [
    {
      key                 = "Name"
      value               = "ins-prj2023"
      propagate_at_launch = true
    },
    {
      key                 = "Ambiente"
      value               = "Laboratorio"
      propagate_at_launch = true
    },
    {
      key                 = "Projeto"
      value               = "Small Infrastructure"
      propagate_at_launch = true
    },
    {
      key                 = "Responsavel"
      value               = "Thiago Lima"
      propagate_at_launch = true
    },
    {
      key                 = "Managed-by"
      value               = "Terraform"
      propagate_at_launch = true
    },
  ]
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Se é necessário criar ip publico."
  default     = false
}


variable "final_snapshot_identifier" {
  type        = bool
  description = "Se é necessário criar snap publico."
  default     = false
}

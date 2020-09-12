provider "aws"{
    region = "us-west-1"
}
terraform {
  backend "remote" {
    organization = "AWS-projects"

    workspaces {
      name = "terraform_aws_test"
    }
  }
}

output "security_groups" {
    value = aws_security_group.websrv_security_group
}

resource "aws_security_group" "websrv_security_group" {
    name = "Allow HTTP(S)"
    description = "Allow HTTP and HTTPS inbound traffic"

    dynamic "ingress"{
    iterator = port
    for_each = var.ingress
    content{
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }
    dynamic "egress"{
    iterator = port
    for_each = var.ingress
    content{
        from_port = port.value
        to_port = port.value
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
        }
    }

}

variable "ingress" {
    type = list(number)
    default = [80,443]
}
variable "egress" {
    type = list(number)
    default = [80,443]
}
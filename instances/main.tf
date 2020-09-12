provider "aws"{
    region = "us-west-1"
}

variable "sec_groups" {
    type = list(string)
}


variable "ami" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "webserver_name" {
    type = string
}

resource "aws_instance" "db_ec2"{
    ami = var.ami
    instance_type = var.instance_type
    tags = {
        Name = "DB Server"
    }
}

resource "aws_instance" "websrv_ec2" {
    ami = var.ami
    instance_type = var.instance_type
    security_groups = var.sec_groups
    user_data = file("./instances/install_apache.sh")
    #depends_on = [aws_eip.eip]
    tags = {
      Name = "${var.webserver_name} Webserver"
    }
}

output "webserver_id" {
    value = aws_instance.websrv_ec2
}

output "db_id" {
    value = aws_instance.db_ec2
}


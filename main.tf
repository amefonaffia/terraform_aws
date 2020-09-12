terraform {
  backend "remote" {
    organization = "AWS-projects"

    workspaces {
      name = "terraform_aws_test"
    }
  }
}

provider "aws"{
    region = "us-west-1"
}

module "sgroup" {
    source = "./sgroup"
}

module "instances" {
    source = "./instances"
    sec_groups = [module.sgroup.security_groups.name]
    ami = "ami-0cd230f950c3de5d8"
    instance_type = "t2.micro"
    webserver_name = "Amefon"
}

module "eip" {
    source = "./eip"
    webserver_id = module.instances.webserver_id.id
}

output "dbprivate_ip_module" {
    value = module.instances.db_id.private_ip
}

output "webpublic_ip_module" {
    value = "http://${module.eip.EIP.public_ip}/index.html"
}
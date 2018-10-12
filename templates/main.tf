variable "region" {
    description = "aws region"
    default = "us-east-1"
}

provider "aws" {
  region                  = "$${var.region}"
/*
  shared_credentials_file = "~/.aws/creds"
  profile                 = "lab"
  */
}

data "aws_security_group" "secure_access" {
   filter {
    name   = "tag:dynamic-update"
    values = ["true"]
  }
}

resource "aws_security_group_rule" "allow_all_tcp" {
  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["${homeip}/32"]
  security_group_id = "$${data.aws_security_group.secure_access.id}"
  description     = "dynamic ip access"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_icmp" {
  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = "icmp"
  cidr_blocks     = ["${homeip}/32"]
  security_group_id = "$${data.aws_security_group.secure_access.id}"
  description     = "dynamic ip access"
  lifecycle {
    create_before_destroy = true
  }
}

variable "externalip" {
    description = "alternate external ip"
    default = ""
}

variable "externalip_count" {
    description = "alternate external ip"
    default = "0"
}


resource "aws_security_group_rule" "allow_all_tcp_2" {

  count           = "$${var.externalip_count}"

  type            = "ingress"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  cidr_blocks     = ["$${var.externalip}/32"]
  security_group_id = "$${data.aws_security_group.secure_access.id}"
  description     = "dynamic ip access"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "allow_all_icmp_2" {

  count           = "$${var.externalip_count}"

  type            = "ingress"
  from_port       = -1
  to_port         = -1
  protocol        = "icmp"
  cidr_blocks     = ["$${var.externalip}/32"]
  security_group_id = "$${data.aws_security_group.secure_access.id}"
  description     = "dynamic ip access"
  lifecycle {
    create_before_destroy = true
  }
}

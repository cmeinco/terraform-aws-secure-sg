provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/creds"
  profile                 = "lab"
}

resource "aws_security_group" "secure_access" {
  name        = "sg_secure_access"
  /*
  description = "Allow inbound traffic from my ip and access to all"
  */
  vpc_id      = "$\{aws_vpc.main.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${emit(homeip)}$/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "allow_all" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  prefix_list_ids   = ["$\{aws_vpc_endpoint.my_endpoint.prefix_list_id}"]
  from_port         = 0
  security_group_id = "sg-123456"
}

#!/usr/bin/env bash

#if state does not exist; query to get the sg and wipe this rule? find by description?

# data "aws_security_group" "secure_access" {
#   filter {
#     name   = "tag:dynamic-update"
#     values = ["true"]
#   }
# }

# description     = "dynamic ip access"

# wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
# unzip terraform_0.11.8_linux_amd64.zip

python scripts/generate_terraform.py
cd temp
../terraform init 
../terraform apply -auto-approve 1> output.log 2> err.log

cd ..

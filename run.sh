#!/usr/bin/env bash

# if terraform does not exist
# wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
# unzip terraform_0.11.8_linux_amd64.zip

# region needed if default in creds profile is different 
set_region="--region us-east-1 "

# query to get the sg and wipe this rule; found by description of the rule
dup_sg=`aws ec2 describe-security-groups --filters "Name=tag:dynamic-update,Values=true" --output text --query "SecurityGroups[].[GroupId]" ${set_region}`
if [[ ${dup_sg} != "" ]]; then
    echo "Found Security Group ${dup_sg}"
else
    echo "No Security Group Found"
    exit
fi
# remove the old rule
existing_ip=`aws ec2 describe-security-groups --filters "Name=tag:dynamic-update,Values=true" --output text ${set_region} | grep "dynamic ip access" | awk '{print $2}'`
aws ec2 revoke-security-group-ingress --group-id ${dup_sg} --protocol tcp --port 0 --cidr "${existing_ip}" ${set_region}

python scripts/generate_terraform.py
cd temp
../terraform init 
../terraform apply -auto-approve 1> output.log 2> err.log
cd ..


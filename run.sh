#!/bin/bash

#set -x

#defaults
externalip="" set_region="us-east-1"
while [ -n "$1" ]; do # while loop starts
    case "$1" in
    -e|--externalip)
        externalip="$2"
        shift
        ;;
 
    -r|--region) 
        set_region="$2"
        shift
        ;;

    --)
        shift # The double dash makes them parameters
        break
        ;;
 
    *) echo "Option $1 not recognized" ;;
 
    esac
    
    if [ $# -ge 2 ]; then
        shift
    else
        break
    fi
done

# if terraform does not exist
if [ ! -f ./terraform ]; then
    echo "Terraform not found!, going to get it..."
    wget https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
    unzip terraform_0.11.8_linux_amd64.zip
fi

# query to get the sg and wipe this rule; found by description of the rule
dup_sg=`aws ec2 describe-security-groups --filters "Name=tag:dynamic-update,Values=true" --output text --query "SecurityGroups[].[GroupId]" --region ${set_region}`
if [[ ${dup_sg} != "" ]]; then
    echo "Found Security Group ${dup_sg}"
else
    echo "No Security Group Found"
    exit
fi
# remove the old rule
existing_ip=`aws ec2 describe-security-groups --filters "Name=tag:dynamic-update,Values=true" --output text --region ${set_region} | grep "dynamic ip access" | awk '{print $2}'`
aws ec2 revoke-security-group-ingress --group-id ${dup_sg} --protocol tcp --port 0 --cidr "${existing_ip}" --region ${set_region}

echo "region = \"$set_region\"" > temp/terraform.tfvars
    
if [[ -n $externalip ]]; then
    echo "externalip = \"$externalip\"" >> temp/terraform.tfvars
    echo "externalip_count = 1" >> temp/terraform.tfvars
fi

./terraform init
../terraform apply -auto-approve 2> err.log

echo "holding for debug"
sleep 30

COUNTER=0

while true; do

    #python scripts/generate_terraform.py
    cd temp
    if [[ COUNTER == 0 ]]; then
        ../terraform init 
    fi
    ../terraform apply -auto-approve 2>> err.log
    cd .. 
    
    COUNTER=$[$COUNTER]
    
    echo "Sleeping for 60s...press Ctrl-C to end Loop. (${COUNTER})"
    sleep 60
done




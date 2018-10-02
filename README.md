# Dynamic SG Rule for Dynamic External IP
Use terraform to build SG rule to limit traffic to your dynamically changing IP address.  This is for home or lab users who want things to work between their machine and the aws lab, cutting off the rest of the world.  

# install
1. pip install -r requirements.txt
1. Download and extract Terraform to the repo dir https://releases.hashicorp.com/terraform/ (script tries to automate this)
1. tag your sg with dynamic-update tag with a value of true.

# run
1. run ```run.sh``` from your machine or a machine on your network to continuously check your external ip and update the SG with the IP, every 60 seconds.
1. Press Ctrl-C to end the script loop

# terraform-aws-secure-sg
terraform to build a secure sg

using terraform because as the detected Ip address changes, it will
remove the old IP when adding the new one.  This allows continuous
checks of the external IP and idempotent runs of terraform.

# install
pip install -r requirements.txt

Download and install Terraform https://releases.hashicorp.com/terraform/

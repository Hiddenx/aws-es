# Elasticsearch cluster on AWS using Terraform

## Setup

##### Prerequisites:
- You should have a EC2 instance with necessary permissions to create ES domain, EC2 instances, security groups etc.. 

<pre>
git clone https://github.com/Hiddenx/aws-es.git
cd aws-es
terraform init
terraform plan -var-file=defaults.tfvar
terraform plan -var-file=defaults.tfvar
</pre>

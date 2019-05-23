#!/bin/bash
MATER_SIZE=1
AWS_KUBE_MASTER_NUM=1
AWS_ETCD_NUM=1
AWS_KUBE_WORKER_NUM=1

# Git clone

repository="https://github.com/jaibapna/kubespray.git"

git clone $repository

cd kubespray

cd contrib/terraform/aws

# Install terraform

sudo apt-get install unzip

sudo sudo apt-get install software-properties-commonwget https://releases.hashicorp.com/terraform/0.11.14/terraform_0.11.14_linux_amd64.zip

sudo unzip terraform_0.11.14_linux_amd64.zip

sudo mv terraform /usr/local/bin/

terraform --version

# Set environment variable

export TF_VAR_AWS_ACCESS_KEY_ID=$1
export TF_VAR_AWS_SECRET_ACCESS_KEY=$2
export TF_VAR_AWS_SSH_KEY_NAME=$3
export TF_VAR_AWS_DEFAULT_REGION=$4

#export TF_VAR_data.aws_ami.distro.name=centOs

export TF_VAR_MATER_SIZE=$MATER_SIZE
export TF_VAR_AWS_KUBE_MASTER_NUM=$AWS_KUBE_MASTER_NUM
export TF_VAR_AWS_ETCD_NUM=$AWS_ETCD_NUM
export TF_VAR_AWS_KUBE_WORKER_NUM=$AWS_KUBE_WORKER_NUM

echo "**************************************************"
echo "Get Terraform Modules"
echo "**************************************************"

terraform get -no-color -update

## Fetch remote state if existent
terraform refresh -no-color


## Plan execution
terraform plan -no-color -out ${CUSTOMER}-${STACK_ENVIRONMENT}.plan


## Provision
terraform apply -no-color -auto-approve

# terraform deploy 

# Install python 3.6.7 

sudo apt-get update

sudo apt-get install python3.6

# Install pip3

sudo apt update

sudo pt install python3-pip

cd ../../..

# install dependency
sudo pip3 install -r requirements.txt


sudo ansible-playbook -i ./inventory/hosts ./cluster.yml -e ansible_user=centos -b --become-user=root --flush-cache  --private-key=~/.ssh/private_key

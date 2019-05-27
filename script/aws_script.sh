#!/bin/bash
set -ex

# Install packages
sudo apt-get update -y
sudo apt-get -y install wget unzip python3-pip

# Install ansible
sudo add-apt-repository ppa:ansible/ansible-2.8 -y
sudo apt-get update -y
sudo apt install ansible -y
ansible --version


# Install terraform
terraform_version=0.11.13

if [[ ! -f /usr/local/bin/terraform ]]; then
  wget https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip
  sudo unzip ./terraform_${terraform_version}_linux_amd64.zip -d /usr/local/bin/
fi

terraform -v

# Methos for help to run bash script
usage()
{
   echo "Use this parameter for run script  ."
   echo "Usage: $0 -a AWS_ACCESS_KEY_ID -r AWS_DEFAULT_REGION -s AWS_SECRET_ACCESS_KEY -l AWS_SSH_KEY_NAME"
           echo "    -a: AWS_ACCESS_KEY_ID"
   echo "    -r: AWS_DEFAULT_REGION"
   echo "    -s: AWS_SECRET_ACCESS_KEY"
   echo "    -l: AWS_SSH_KEY_NAME"
   exit 1
}

# Case statement for Run Script
while getopts "a:r:s:l:h:" opt; do
 case $opt in
         a)
           AWS_ACCESS_KEY_ID=$OPTARG
           ;;
         r)
           AWS_DEFAULT_REGION=$OPTARG
           ;;
         s)
           AWS_SECRET_ACCESS_KEY=$OPTARG
           ;;
         l)
           AWS_SSH_KEY_NAME=$OPTARG
           ;;
         h)
           usage
           ;;
   esac
done

echo $AWS_ACCESS_KEY_ID
echo $AWS_DEFAULT_REGION
echo $AWS_SECRET_ACCESS_KEY
echo $AWS_SSH_KEY_NAME
echo $KEY_name

if [ "$AWS_ACCESS_KEY_ID" == "" ] || [ "$AWS_DEFAULT_REGION" == "" ] || [ "$AWS_SECRET_ACCESS_KEY" == "" ] || [ "$AWS_SSH_KEY_NAME" == "" ];then
   echo "prameter  missing"
   usage
   exit 1
fi

aws_kube_master_num=1
aws_etcd_num=1
aws_kube_worker_num=1
ansible_user=centos
key_name=$KEY_name

echo $key_name


# Set environment variable


cat <<EOF > /etc/profile.d/exportfile.sh
export TF_VAR_AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export TF_VAR_AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SSH_KEY_NAME=$AWS_SSH_KEY_NAME
export TF_VAR_aws_kube_master_num=$aws_kube_master_num
export TF_VAR_aws_etcd_num=$aws_etcd_num
export TF_VAR_aws_kube_worker_num=$aws_kube_worker_num
EOF

source /etc/profile.d/exportfile.sh


# Git clone
repository="https://github.com/jaibapna/kubespray.git"

#git clone $repository
cd kubespray
cd contrib/terraform/aws

echo "**************************************************"
echo "Get Terraform Modules"
echo "**************************************************"

terraform init

## Plan execution
terraform plan -no-color

## Provision
terraform apply -no-color -auto-approve

# terraform deploy
#terraform destroy  -auto-approve  ./terraform.tfstate
cd ../../..

## add key to ssh 
eval $(ssh-agent)
ssh-add ~/.ssh/$key_name

# install dependency
pip3 install -r requirements.txt

ansible-playbook -i ./inventory/hosts ./cluster.yml -e ansible_user=$ansible_user -b --become-user=root --flush-cache  --private-key=~/.ssh/$key_name \
 --extra-vars "kubectl_localhost=true kubeconfig_localhost=true dashboard_enabled=true" -vv


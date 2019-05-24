#!/bin/bash

# Conditions for check Reqired software with version

if which terraform 
then
		echo "terraform installed"
		terraform --version
		if which pip3
		then 
			echo "Installed pip3"
		else
			echo "Please Install pip3"
			exit 1
		fi
		if which python3
		then
			echo "Installed Python"
		else
			echo "Please install python3"
			exit 1
		fi
else
		echo "terraform Not installed"
		exit 1
fi

# Methos for help to run bash script 

usage()
{
       echo "Use this parameter for run script  ."
       echo "Usage: $0 -a AWS_ACCESS_KEY_ID -r AWS_DEFAULT_REGION -s AWS_SECRET_ACCESS_KEY -l AWS_SSH_KEY_NAM -p KEY_name"
   	   echo "    -a: AWS_ACCESS_KEY_ID"
  	   echo "    -r: AWS_DEFAULT_REGION"
       echo "    -s: AWS_SECRET_ACCESS_KEY"
       echo "    -l: AWS_SSH_KEY_NAME"
       echo "    -p: KEY_name"
       exit 1
}

# Case statement for Run Script


while getopts "c:dhkp:r:a:s:l:p" opt; do
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
                       p)
                 KEY_name=$OPTARG
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

if [ "$AWS_ACCESS_KEY_ID" == "" ] || [ "$AWS_DEFAULT_REGION" == "" ] || [ "$AWS_SECRET_ACCESS_KEY" == "" ] || [ "$AWS_SSH_KEY_NAME" == "" ] || [ "$KEY_name" == "" ];then

       echo "prameter  missing"
       usage
       exit 1
fi

aws_kube_master_num=1
aws_etcd_num=1
aws_kube_worker_num=1
key_name=$KEY_name

# Set environment variable

export TF_VAR_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export TF_VAR_AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
export TF_VAR_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export TF_VAR_AWS_SSH_KEY_NAME=$AWS_SSH_KEY_NAME

# Set instance Number

export TF_VAR_aws_kube_master_num=$aws_kube_master_num
export TF_VAR_aws_etcd_num=$aws_etcd_num
export TF_VAR_aws_kube_worker_num=$aws_kube_worker_num

# Git clone

repository="https://github.com/jaibapna/kubespray.git"

git clone $repository

cd kubespray

cd contrib/terraform/aws

echo "**************************************************"
echo "Get Terraform Modules"
echo "**************************************************"

terraform get -no-color -update
echo env.

## Fetch remote state if existent
terraform refresh -no-color


## Plan execution
terraform plan -no-color -out ${CUSTOMER}-${STACK_ENVIRONMENT}.plan

## Provision
terraform apply -no-color -auto-approve

# terraform deploy 

cd ../../..

# install dependency
pip3 install -r requirements.txt

ansible-playbook -i ./inventory/hosts ./cluster.yml -e ansible_user=centos -b --become-user=root --flush-cache  --private-key=~/.ssh/$key_name


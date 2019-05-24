#!/bin/bash

# Conditions for check Reqired software with version

if which terraform 
then
		echo "terraform installed"
		terraform --version
		if which ansible 
		then
			echo "Install ansible"
			ansible_versions= ansible --version
			if  [ansible_versions>=3.0]
			then
				echo "Required ansible installed"
			else
				echo "Please install ansible 3.0 version"
				exit 1
			fi
		else
			echo "Please install ansible 3.0 version"
			exit 1
		fi
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
       echo "Usage: $0 -a AWS_ACCESS_KEY_ID -r AWS_DEFAULT_REGION -s AWS_SECRET_ACCESS_KEY -k AWS_SSH_KEY_NAM -p KEY_name"
   	   echo "    -a: AWS_ACCESS_KEY_ID"
  	   echo "    -r: AWS_DEFAULT_REGION"
       echo "    -s: AWS_SECRET_ACCESS_KEY"
       echo "    -k: AWS_SSH_KEY_NAME"
       echo "    -p: KEY_name"
       exit 1
}

# Case statement for Run Script

while getopts "c:dhkp:o:a:" opt; do
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
                       k)
                         AWS_SSH_KEY_NAME=$OPTARG
                         ;;
                       p)
                         KEY_name=$OPTARG
                         ;;
                       h)
                         usage
                         ;;
               esac
done


if [ "$AWS_ACCESS_KEY_ID" == "" ];then
       echo "Please enter AWS_ACCESS_KEY_ID"
       exit 1

       if [ "$AWS_DEFAULT_REGION" == "" ];then
       	echo "Please enter AWS_DEFAULT_REGION"
       	exit 1

       	if [ "$AWS_SECRET_ACCESS_KEY" == "" ];then
       		echo "Please enter AWS_SECRET_ACCESS_KEY"
       		exit 1

       		if [[ "$AWS_SSH_KEY_NAME" == "" ]]; then
       			echo "Please enter AWS_SSH_KEY_NAME"
       			exit 1

       			if [[ "$KEY_name" == "" ]]; then
       			echo "Please enter KEY_name"
       			exit 1

       			fi
       		fi
       	fi

  	   fi
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


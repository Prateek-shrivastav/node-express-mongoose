#!/bin/bash
set -ex

# Install packages
sudo apt-get update -y
sudo apt-get -y install wget unzip python3-pip

# Install ansible

pip install --upgrade pip virtualenv virtualenvwrapper
virtualenv ansible2.7.8
source ansible2.7.8/bin/activate
pip install ansible==2.7.8


# Git clone
repository="https://github.com/jaibapna/kubespray.git"

#git clone $repository
cd kubespray

pip install netaddr

# install dependency
pip3 install -r requirements.txt

vagrant up

